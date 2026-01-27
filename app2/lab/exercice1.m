clc
close all
clear all

N = 5;
x = [1, 3, 4, 6, 7]';
y = [-1.6 4.8 6.1 14.6 15.1]';

% Affichage des données
figure()
plot(x,y, 'o')
grid on
hold on
xlabel('x', 'Fontsize',15)
ylabel('y', 'Fontsize',15)
title('E1', 'Fontsize',15)
axis([0 8 -2 16])

% Création des sommations permettant de simplifier l'écriture sous forme matricielle
sum_x = sum(x);
sum_y = sum(y);
sum_xy = x'*y;
sum_x2 = x'*x;

% Matrice selon la démonstration D2 page 7 des notes de cours
A = [N, sum_x ; sum_x, sum_x2];
B = [sum_y ; sum_xy];
solution = inv(A)*B;

% Solution finale de forme y = mx + b
y_estime = solution(2)*x+solution(1);

% Affichage de la droite calculée
plot(x, y_estime, 'LineWidth',2)

% Calcul de l'erreur quadratique
E = (y_estime-y)'*(y_estime-y);

% Calcul de la valeur RMS
err_rms = sqrt( mean((y_estime-y).*(y_estime-y)) );
y_moyen = mean(y);
R = (y_estime-y_moyen)'*(y_estime-y_moyen)/((y-y_moyen)'*(y-y_moyen));
NmoinsM = length(y)-length(solution);

% Affichage des résultats
disp(' ')
disp(['Fonction: g(x) = ', num2str(solution(2)), ' x + (', num2str(solution(1)), ')'])
disp(' ')
disp(['Erreur quadratique = ', num2str(E)])
disp(' ')
disp(['Erreur RMS = ', num2str(err_rms)])
disp(' ')
disp(['Corrélation = ', num2str(R)])
disp(' ')
disp(['N - M = ', num2str(NmoinsM)])
