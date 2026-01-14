disp('Courbes statique dynamique pour la validation');

%{
On considère la force FB et le couple CB exercés sur l’extrémité B de BA. FB est appliquée par OB
alors que CB est appliqué par MB. Il faut déterminer FB et le moment de CB en fonction des m_Asses,
des angles et de l1 et l 2, dans le cas où le robot est immobile. Il faut aussi déterminer FB et le
moment de CB, dans le cas où BA tourne avec une accélération angulaire constante BA pendant que OB est immobile

Vous décidez de illustrer vos résultats à l’aide de m_ATLAB en produisant des courbes de l'évolution
du moment de CB dans les cas statique et dynamique, le tout en fonction de  lorsque  est
compris entre -/3 et /3. On prendra l0 = 50 cm, l1 = l2 = 25 cm, m_A=100 g, mBA= 1 kg et BA = 5
rad/s2.

Il faut déterminer FB et CB, dans le cas où BA tourne avec une accélération
angulaire constante BA pendant que OB est immobile.
%}

l0 = 0.5;
l1 = 0.25;
l2 = 0.25;
m_OB = 1;
m_AB= 1;
m_A = 0.1;
alpha_AB = 5;
G  = -9.81;

phi = linspace(pi/3,-pi/3,100);
figure('Name', 'Hello', 'NumberTitle', 'off');


% Statique %
force_gravite_AB = m_AB * G * cos(phi);
force_gravite_A = m_A * G * cos(phi);
force_B = force_gravite_AB + force_gravite_A;

couple_gravite = force_gravite_AB * l2/2 + force_gravite_A * l2;
couple_B = -couple_gravite;


subplot(3, 1, 1);
plot(phi, couple_B);
grid on;
title('Couple rotation B en fonction de phi');
xlabel('phi (rad)');
ylabel('Couple Force B (N/m)');

% Dynamique %
omega_AB = sqrt(2 * alpha_AB * abs(phi - phi(1)));
acceleration_lin_AB_normale = omega_AB.^2 * l2/2;
acceleration_lin_AB_tangente = alpha_AB * l2/2;
acceleration_lin_A_normale = omega_AB.^2 * l2;
acceleration_lin_A_tangente = alpha_AB * l2;
acceleration_lin_AB_normale_x = acceleration_lin_AB_normale .* cos(phi + pi);
acceleration_lin_AB_normale_y = acceleration_lin_AB_normale .* sin(phi + pi);
acceleration_lin_AB_tangente_x = acceleration_lin_AB_tangente .* cos(phi + pi/2);
acceleration_lin_AB_tangente_y = acceleration_lin_AB_tangente .* sin(phi + pi/2);
acceleration_lin_A_normale_x = acceleration_lin_A_normale .* cos(phi + pi);
acceleration_lin_A_normale_y = acceleration_lin_A_normale .* sin(phi + pi);
acceleration_lin_A_tangente_x = acceleration_lin_A_tangente .* cos(phi + pi/2);
acceleration_lin_A_tangente_y = acceleration_lin_A_tangente .* sin(phi + pi/2);
force_B_dyn_x = m_AB * (acceleration_lin_AB_normale_x + acceleration_lin_AB_tangente_x) + m_A * (acceleration_lin_A_normale_x + acceleration_lin_A_tangente_x);
force_B_dyn_y = m_AB * (acceleration_lin_AB_normale_y + acceleration_lin_AB_tangente_y) + m_A * (acceleration_lin_A_normale_y + acceleration_lin_A_tangente_y) + force_B;

moment_AB = m_AB * l2^2 / 3;
moment_A = m_A * l2^2;
moments = moment_AB + moment_A;
inertie = moments * alpha_AB;
couple_B_dyn = inertie - couple_gravite;


subplot(3, 1, 2);
plot(phi, couple_B_dyn);
grid on;
title('Couple rotation B dynamique en fonction de phi');
xlabel('phi (rad)');
ylabel('Couple Force B (N/m)');

subplot(3, 1, 3);
plot(phi, sqrt(force_B_dyn_x.^2 + force_B_dyn_y.^2));
grid on;
title('Force B dynamique - Magnitude');
xlabel('phi (rad)');
ylabel('Force totale (N)');

