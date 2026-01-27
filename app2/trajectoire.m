% s'assure que tout est reset à chaque run
clc;
close all;
clear all;
pkg load signal;

nbPlots = 8;
nbPoints = 30;
polynomeDegree = 4;

% − Valeur de 𝑦𝑓 (hauteur à la fin de la trajectoire au point E).
% − Coefficient de friction dynamique μ𝑓 choisi avec l’erreur RMS de l’approximation.
% − Vitesse finale du participant au point E, erreur dans cette vitesse causée par l’erreur RMS dans μ𝑓.
% − Graphique de la vitesse du participant le long de la trajectoire (en fonction de la coordonnée horizontale, x)
% − Graphique des données avec droite de lissage et son erreur quadratique / RMS ou sa corrélation.
% − Ouverture de la valve en % qui correspond au coefficient de friction selon le polynôme d’approximation.

yIni = 30;
m = 80;
g = 9.81;
mg = m * g;

A = [0, 30];
B = [8,19];
C = [15, 20];
D = [20, 16];
E = [25, 0];
listX = [A(1), B(1), C(1), D(1), E(1)];
p = zeros(nbPlots + 1, polynomeDegree + 1);

for i = 0:nbPlots
  E(2) = (10 + (i / (nbPlots / 5)));
  listY = [A(2), B(2), C(2), D(2), E(2)];
  p(i + 1, :) = polyfit(listX, listY, polynomeDegree);
endfor

disp("finished calculating polynomials");


xPoints = linspace(0, 25, nbPoints);
trajectoires = zeros(length(xPoints), nbPlots + 1);
derivatives = zeros(length(xPoints), nbPlots + 1);
angles = zeros(length(xPoints), nbPlots + 1);

figure; hold on; grid on;
title('Evolution of Trajectories as Point E Moves');
xlabel('Distance (x)'); ylabel('Hauteur (y)');

for i = 1:(nbPlots + 1)
    current_coeffs = p(i, :);

    height = polyval(current_coeffs, xPoints);

    trajectoires(:, i) = height;

    derivedp = polyder(current_coeffs);

    der = polyval(derivedp, xPoints);

    angles(:, i) = atan(der);

    derivatives(:, i) = der;

    % Plot it immediately to see the "fanning" effect
    plot(xPoints, height);
endfor

disp("finished calculating curves");
disp("finished calculating derived curves");

% friction time

figure; hold on; grid on;
title('Evolution of friction as valve opens');
xlabel('Valve (%)'); ylabel('coefficient de friction');

ouverture = [0 10 20 30 40 50 60 70 80 90 100];
muEmp = [0.87 0.78 0.71 0.61 0.62 0.51 0.51 0.49 0.46 0.48 0.46];
nbPlotsMu = length(ouverture);
xPoints = linspace(0, 100, nbPoints);

pMu = polyfit(ouverture, muEmp, 2);
muPlot = polyval(pMu, xPoints);
muTrajectoire = polyval(pMu, ouverture);
plot(xPoints, muPlot);
plot(ouverture, muEmp, 'x');

err = zeros(nbPlotsMu, 1);

disp("finished calculating friction curve");
disp(length(muTrajectoire));

%err(:, 1) = abs(muTrajectoire(1) - muEmp(1));
for i = 1:nbPlotsMu
  err(i) = muTrajectoire((ouverture(i) / 10) + 1) - muEmp(i);
endfor

disp(length(err));
% muErr = muErr = sqrt((1 / length(err)) * sum(err.^2));
muErr = sqrt(mean(err.^2));
disp(length(muErr));

disp("finished finding friction's imprecision");
disp(muErr);

%plot(xPoints, muTrajectoire - muErr(:));
%plot(xPoints, muTrajectoire + muErr(:));

% Vitesse time
%
% Eg = Ep + Ek + W
%
% friction = mu * mg * cos(angles) * x
%
% W = - integral(friction, 0, x)
%
% Ep = mg * trajectoires
%
% Ek = (mv²) / 2
%
% since m est partout on peut l'enlever. après quelques bougeages on en revient à
%
% v = sqrt(2g(yIni - trajectoire(x) - W(x)))

figure; hold on; grid on;

kmhToMs = (1000/3600);
xValve = linspace(0, 100, nbPoints);
xPoints = linspace(0, 25, nbPoints);

x_lims = [0, xPoints(end)];

for j = 1:5
  subplot(2, 3, j);
  hold on; grid on;
  plot(x_lims, [45 * kmhToMs, 45 * kmhToMs], 'g', 'LineWidth', 2); % Green bar
  plot(x_lims, [15 * kmhToMs, 15 * kmhToMs], 'r', 'LineWidth', 2); % red bar
  plot(x_lims, [10 * kmhToMs, 10 * kmhToMs], 'g', 'LineWidth', 2); % Green bar
  % Initialize a container for legend labels
  labels = {};

  mu = 0.05 * j + 0.4
    % Your target mu values from the previous loop
  valveResult = 0;

  % Get the coefficients from your polyfit (pMu = [a, b, c])
  aMu = pMu(1);
  bMu = pMu(2);
  cMu = pMu(3);

  coeffs = [aMu, bMu, (cMu - mu)];
  possible_x = roots(coeffs);

  % 'roots' returns 2 values for a quadratic.
  % We pick the one between 0 and 100.
  valveResult = possible_x(possible_x >= 0 & possible_x <= 80);

  for i = 1:nbPlots
    height = trajectoires(:, i);
    angle = angles(:, i)';
    friction =  cos(angle);
    frictionMax = (mu + muErr) * g * cos(angle);
    frictionMin = (mu - muErr) * g * cos(angle);

    W = cumtrapz(xPoints(:), friction(:));
    WMax = cumtrapz(frictionMax(:), xPoints(:));
    WMin = cumtrapz(frictionMin(:), xPoints(:));

    % 3. Energy Balance: v = sqrt( 2 * (G_potential_loss - Work_loss) )
    % Height loss is (yIni - height)
    energy_balance = (g * (yIni - height(:))) - (mu * g .* W(:));

    % Ensure we don't take the square root of a negative (if friction stops the person)
    energy_balance(energy_balance < 0) = 0;

    v = sqrt(2 * energy_balance);

    plot(xPoints, v);
  %  plot(xPoints, vMin .* msToKmh);
  %  plot(xPoints, vMax .* msToKmh);
    axis([0 25 0 15]);
    labels{i} = [ 'Ey = ', num2str(height(end), '%.1f'), 'm' ];
  endfor
  legend(labels, 'location', 'northeastoutside', 'FontSize', 8);
  title({['mu (+/- ', num2str(muErr),')= ', num2str(mu)], ['valve (%) = ', num2str(valveResult)]});
  xlabel('position (m)'); ylabel('vitesse (m/s)');
endfor

axis auto;



