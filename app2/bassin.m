% On cherche la vitesse d'équilibre et la profondeur minimale sécuritaire du bassin.

m_participant = 80;
h_saut = 10;
b_eau = 47;
k_flotabilite = 0.95;
a_gravite = 9.81;
f_fin = 1.10;

% v_initiale = énergie potentielle initiale du participant
% force = m_participant * a_gravite - k_flotabilite * m_participant * a_gravite - b_eau * v.^2;

% --- Résolution ---
v_initiale = sqrt(2 * a_gravite * h_saut);
v_equilibre = sqrt((m_participant * a_gravite * (1 - k_flotabilite)) / b_eau);

delta_z_bassin = (m_participant / (2 * b_eau)) * log((v_initiale - v_equilibre) / ((f_fin - 1) * v_equilibre));


% --- Affichage des résultats ---
disp('--- Résultats : Bassin d''eau ---')
disp(['Vitesse initiale à l''entrée dans l''eau v_initiale = ', num2str(v_initiale), ' m/s'])
disp(['Vitesse limite dans l''eau v_equilibre = ', num2str(v_equilibre), ' m/s'])
disp(['Profondeur sécuritaire du bassin Δz = ', num2str(delta_z_bassin), ' m'])

% --- Graphique de la vitesse en fonction de la profondeur ---
z = linspace(0, delta_z_bassin, 500);
v_z = v_equilibre + (v_initiale - v_equilibre) .* exp(-(2 * b_eau / m_participant) .* z);


figure
plot(z, v_z, 'LineWidth', 2)
grid on
xlabel('Profondeur z (m)')
ylabel('Vitesse v (m/s)')
title('Vitesse du participant dans l''eau en fonction de la profondeur')
