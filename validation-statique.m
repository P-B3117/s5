disp('Courbes statique dynamique pour la validation');

%{
On considère la force FB et le couple CB exercés sur l’extrémité B de BA. FB est appliquée par OB
alors que CB est appliqué par MB. Il faut déterminer FB et le moment de CB en fonction des masses,
des angles et de l1 et l 2, dans le cas où le robot est immobile. Il faut aussi déterminer FB et le
moment de CB, dans le cas où BA tourne avec une accélération angulaire constante BA pendant que OB est immobile

Vous décidez de illustrer vos résultats à l’aide de MATLAB en produisant des courbes de l'évolution
du moment de CB dans les cas statique et dynamique, le tout en fonction de  lorsque  est
compris entre -/3 et /3. On prendra l0 = 50 cm, l1 = l2 = 25 cm, mA=100 g, mBA= 1 kg et BA = 5
rad/s2.
%}

nbPoints = 100

l0 = 0.5
l1 = 0.25;
l2 = 0.25;
Mob= 1;
Mab= 1;
Ma = 0.1;
alphaBA = 5;
G  = 9.81

phi = linspace(-pi/3,pi/3,nbPoints);

% FBA = Somme des forces Gravite sur bras, gravite sur payload

relation_gravite_AB = Mab / 3 * G * cos(phi);
relation_gravite_MA = Ma * G * cos(phi);

FBA = relation_gravite_AB + relation_gravite_MA;

CB = FBA * l2;

hFig = figure('Name', 'Hello', 'NumberTitle', 'off');
subplot(2, 1, 1);
plot(phi, CB);
grid on;
title('Couple rotation B en fonction de phi');
xlabel('phi (rad)');
ylabel('Couple Force B (N/m)');

