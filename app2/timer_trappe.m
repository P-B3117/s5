% Calcul de la minuterie pour la trappe (Ballon-Mouse)
% Il faut calculer le temps douverture de la trappe pour séparer les cas où le ballon est attrapé (G1) et où il rebondit (G2).

clear all;
close all;
clc;

v_participant = 15.0;

m_participant = 80;
v_ballon = -1.0;
m_ballon = 8;
L_trappe = 3.0;
marge_securite = 0.02;

% --- Calculs des collisions ---

% Conservation de la quantité de mouvement : m_p*vp + m_b*vb = m_p*vp' + m_b*vb'
% Coefficient de restitution : e = -(vb' - vp') / (vb - vp)  => vb' = vp' + e(vp - vb)
% Substitution : m_p*vp + m_b*vb = m_p*vp' + m_b*(vp' + e(vp - vb))
% vp' * (m_p + m_b) = m_p*vp + m_b*vb - m_b*e*(vp - vb)
% vp' = ( m_p*vp + m_b*vb - m_b*e*(vp - vb) ) / (m_p + m_b)

delta_v = v_participant - v_ballon; % Vitesse relative

% Cas G1 : Ballon attrapé (e = 0)
e_G1 = 0;
v_p_G1 = (m_participant * v_participant + m_ballon * v_ballon - m_ballon * e_G1 * delta_v) / (m_participant + m_ballon);

% Cas G2 : Ballon rebondit (e = 0.8) - Pire cas (vitesse la plus faible pour le participant ?)
% e = 0.8 donne le transfert d'impulsion le plus grand, mais vérifions la vitesse vp'.
% vp = (Mv + mvb - m*e*(v-vb)) / (M+m)
% Plus 'e' est grand, plus le terme négatif soustrait est grand.
% Donc vp est MINIMALE quand e est maximal (0.8).
% Vitesse minimale -> Temps de traversée MAXIMAL.
% Cest bien le cas G2 "limite" pour rester SUR la trappe.
e_G2 = 0.8;
v_p_G2 = (m_participant * v_participant + m_ballon * v_ballon - m_ballon * e_G2 * delta_v) / (m_participant + m_ballon);

% --- Calcul des temps de traversée ---
% t = d / v
t_traversee_G1 = L_trappe / v_p_G1; % Temps pour quitter la trappe (Attrapé)
t_traversee_G2 = L_trappe / v_p_G2; % Temps pour quitter la trappe (Rebond)

% --- Conditions pour la minuterie ---
% G1 (Attrapé) : Doit avoir quitté AVANT l'ouverture.
% t_ouverture > t_traversee_G1 + marge
t_min = t_traversee_G1 + marge_securite;

% G2 (Rebond) : Doit être ENCORE SUR la trappe QUAND ça s'ouvre.
% t_ouverture < t_traversee_G2 - marge (Le participant est encore dessus tant que t < t_traversee_G2)
t_max = t_traversee_G2 - marge_securite;

% --- Affichage des résultats ---
disp(' ');
disp('--- Résultats des collisions ---');
disp(['G1 (e=', num2str(e_G1), ') : Vitesse après impact = ', num2str(v_p_G1, '%.4f'), ' m/s']);
disp(['G1 (e=', num2str(e_G1), ') : Temps pour quitter   = ', num2str(t_traversee_G1, '%.4f'), ' s']);
disp(['G2 (e=', num2str(e_G2), ') : Vitesse après impact = ', num2str(v_p_G2, '%.4f'), ' m/s']);
disp(['G2 (e=', num2str(e_G2), ') : Temps pour quitter   = ', num2str(t_traversee_G2, '%.4f'), ' s']);

disp(' ');
disp('--- Conception de la minuterie (Delta t_m) ---');
disp(['Condition G1 (Quitté) : t_m > ', num2str(t_traversee_G1, '%.4f'), ' + ', num2str(marge_securite), ' = ', num2str(t_min, '%.4f'), ' s']);
disp(['Condition G2 (Dessus) : t_m < ', num2str(t_traversee_G2, '%.4f'), ' - ', num2str(marge_securite), ' = ', num2str(t_max, '%.4f'), ' s']);

if t_min < t_max
    t_m_optimal = (t_min + t_max) / 2;
    disp(' ');
    disp(['>>> SOLUTION POSSIBLE <<<']);
    disp(['Plage valide : ] ', num2str(t_min, '%.4f'), ' s , ', num2str(t_max, '%.4f'), ' s [']);
    disp(['Valeur suggérée (moyenne) : ', num2str(t_m_optimal, '%.4f'), ' s']);
else
    disp(' ');
    disp(['>>> ERREUR : AUCUNE SOLUTION <<<']);
    disp('Le temps min requis pour G1 est supérieur au temps max permis pour G2.');
    disp('Cela signifie que la différence de vitesse entre G1 et G2 n''est pas suffisante');
    disp('pour couvrir les marges de sécurité.');
    disp('Veuillez augmenter la vitesse initiale du participant.');
end

% --- Graphique illustratif ---
figure;
hold on; grid on;

% Trace des rectangles de "présence sur la trappe"
% G1 : Présent de 0 à t_trav_G1
fill([0, t_traversee_G1, t_traversee_G1, 0], [0.6, 0.6, 0.9, 0.9], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'r');
text(t_traversee_G1/2, 0.75, 'Sur trappe (G1)', 'HorizontalAlignment', 'center');

% G2 : Présent de 0 à t_trav_G2
fill([0, t_traversee_G2, t_traversee_G2, 0], [0.1, 0.1, 0.4, 0.4], 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'b');
text(t_traversee_G2/2, 0.25, 'Sur trappe (G2)', 'HorizontalAlignment', 'center');

% Limites
xline(t_min, 'r-', 'Min (G1 safe)');
xline(t_max, 'b-', 'Max (G2 safe)');

if t_min < t_max
    fill([t_min, t_max, t_max, t_min], [0, 1, 1, 0], 'g', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    text((t_min+t_max)/2, 0.5, 'ZOONE OPTIMALE', 'Rotation', 90, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
end

xlabel('Temps après impact (s)');
ylim([0, 1]);
title('Conception de la minuterie de trappe');
