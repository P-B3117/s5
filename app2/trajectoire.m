% s'assure que tout est reset à chaque run
clc;
close all;
clear all;

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

% disp("finished calculating polynomials");


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

% disp("finished calculating curves");
% disp("finished calculating derived curves");

% disp("finding best curve");
last_angles = angles(end, :);
bestAngle = 1;
% disp(length(last_angles));
for i = 1:length(last_angles);
  % disp(last_angles(i)); disp(last_angles(bestAngle));
  if abs(last_angles(i)) < abs(last_angles(bestAngle));
    bestAngle = i;
  endif
endfor

chosenTrajectoire = bestAngle;

% disp("finished finding best curve");
disp(["Best end height is: ", num2str(trajectoires(end, chosenTrajectoire)), "m"])
p_str = sprintf('%g ', p(chosenTrajectoire, :));
disp(["Best Trajectory polynomials are: ", p_str])

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

p_str = sprintf('%g ', pMu);
disp(["Best mu polynomials are: ", p_str])

% disp("finished calculating friction curve");
% disp(length(muTrajectoire));

%err(:, 1) = abs(muTrajectoire(1) - muEmp(1));
for i = 1:nbPlotsMu
  err(i) = muTrajectoire((ouverture(i) / 10) + 1) - muEmp(i);
endfor
muErr = sqrt(mean(err.^2));

% disp("finished finding friction's imprecision");
disp(["mu RMS is: ", num2str(muErr)]);

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

% --- Vitesse (Velocity) Time ---
figure; hold on; grid on;
kmhToMs = (1000/3600);
xPoints = linspace(0, 25, nbPoints);

% Safety boundaries (Visualizing limits)
plot([0 25], [45 * kmhToMs, 45 * kmhToMs], 'r--', 'HandleVisibility', 'off');
plot([0 25], [25 * kmhToMs, 25 * kmhToMs], 'y--', 'HandleVisibility', 'off');
plot([0 25], [20 * kmhToMs, 20 * kmhToMs], 'y--', 'HandleVisibility', 'off');
plot([0 25], [10 * kmhToMs, 10 * kmhToMs], 'g--', 'HandleVisibility', 'off');

height = trajectoires(:, chosenTrajectoire);

muTestSteps = 8;

targetEndSpeed = 22.5 * kmhToMs;
v = zeros(length(xPoints), muTestSteps);
vMax = zeros(length(xPoints), muTestSteps);
vMin = zeros(length(xPoints), muTestSteps);
mu = zeros(1, muTestSteps);
valveResult = zeros(1, muTestSteps);

for j = 1:muTestSteps
    mu(j) = 0.47 + 0.05 * j;

    % Find Valve % using quadratic formula
    aMu = pMu(1); bMu = pMu(2); cMu = pMu(3);
    coeffs = [aMu, bMu, (cMu - mu(j))];
    possible_x = roots(coeffs);
    r = possible_x(possible_x >= 0 & possible_x <= 100);
    if isempty(r); valveResult(j) = 0; else valveResult(j) = r(1); end

    % We calculate Work per unit mass (W/m)
    friction_per_unit_x = mu(j) * g;
    friction_per_unit_x_Max = (mu(j) + muErr) * g;
    friction_per_unit_x_Min = (mu(j) - muErr) * g;
    W_over_m = cumtrapz(xPoints, ones(size(xPoints)) * friction_per_unit_x);
    W_over_m_Max = cumtrapz(xPoints, ones(size(xPoints)) * friction_per_unit_x_Max);
    W_over_m_Min = cumtrapz(xPoints, ones(size(xPoints)) * friction_per_unit_x_Min);

    % Energy Balance: 0.5 * v^2 = g * (yIni - y) - (Work_lost / m)
    specific_energy = (g * (yIni - height)) - W_over_m';
    specific_energy_Max = (g * (yIni - height)) - W_over_m_Max';
    specific_energy_Min = (g * (yIni - height)) - W_over_m_Min';

    specific_energy(specific_energy < 0) = 0; % 0 wrong values to stop crashes
    v(:, j) = sqrt(2 * specific_energy);
    vMax(:, j) = sqrt(2 * specific_energy_Max);
    vMin(:, j) = sqrt(2 * specific_energy_Min);
end


% disp("finding best curve");
last_speeds = v(end, :);
bestEndSpeed = 1;
% disp(length(last_speeds));
for i = 1:length(last_speeds);
  % disp([num2str(abs(last_speeds(i) - (22.5*kmhToMs))), "<" , num2str(abs(last_speeds(bestEndSpeed) - (22.5*kmhToMs)))]);
  if abs(last_speeds(i) - (22.5*kmhToMs)) < abs(last_speeds(bestEndSpeed) - (22.5*kmhToMs));
    bestEndSpeed = i;
  endif
endfor

plot(xPoints, v(:, bestEndSpeed), 'DisplayName', sprintf('\\mu=%.2f, Valve=%.1f%%', mu(bestEndSpeed), valveResult));
plot(xPoints, vMax(:, bestEndSpeed), 'DisplayName', sprintf('\\mu=%.2f, Valve=%.1f%%', mu(bestEndSpeed), valveResult));
plot(xPoints, vMin(:, bestEndSpeed), 'DisplayName', sprintf('\\mu=%.2f, Valve=%.1f%%', mu(bestEndSpeed), valveResult));

disp(["Best end speed is: ", num2str(v(end, bestEndSpeed)), "m/s"])
disp(["Best end speed is: ", num2str(v(end, bestEndSpeed) * 1/kmhToMs), "km/h"])
disp(["Best max end speed is: ", num2str(vMax(end, bestEndSpeed) * 1/kmhToMs), "km/h"])
disp(["Best min end speed is: ", num2str(vMin(end, bestEndSpeed) * 1/kmhToMs), "km/h"])
disp(["Best friction coefficient is: ", num2str(mu(bestEndSpeed))])
disp(["Best valve opening is: ", num2str(valveResult(bestEndSpeed)), "%"])

legend('location', 'northeastoutside');
title('Velocity Evolution along Trajectory');
xlabel('Horizontal Distance (m)');
ylabel('Velocity (m/s)');
axis([0 26 0 46]);
