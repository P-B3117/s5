disp('Courbes pour la validation');

nbPlots = 3
nbPoints = 1000

posIni = 0;
posFin = pi/3;
l1 = 0.25;
l2 = 0.25;
vAngOB = 25;

tIni = 0;
tFin = posFin / vAngOB;
t = linspace(tIni, tFin, nbPoints);

teta = vAngOB * t + posIni;

phiX = -teta
posX = (l1 * cos(teta)) + (l2 * cos(phiX))
vX = diff(posX)
aX = diff(vX)

hFig = figure('Name', 'Mouvement horizontal', 'NumberTitle', 'off');
subplot(nbPlots, 1, 1);
plot(teta, posX);
grid on;
title('position vs angle');
xlabel('angle (rad)');
ylabel('position (m)');

subplot(nbPlots, 1, 2);
plot(teta(2:end), vX);
grid on;
title('vitesse vs angle');
xlabel('angle (rad)');
ylabel('vitesse (m/s)');

subplot(nbPlots, 1, 3);
plot(teta(3:end), aX);
grid on;
title('accel vs angle');
xlabel('angle (rad)');
ylabel('accelleration (m/s²)');

phiY = (pi/2) - teta
posX = (l1 * sin(teta)) + (l2 * sin(phiY))
vY = diff(posX)
aY = diff(vX)

vFig = figure('Name', 'Mouvement Vertical', 'NumberTitle', 'off');
subplot(nbPlots, 1, 1);
plot(teta, posX);
grid on;
title('position vs angle');
xlabel('angle (rad)');
ylabel('position (m)');

subplot(nbPlots, 1, 2);
plot(teta(2:end), vX);
grid on;
title('vitesse vs angle');
xlabel('angle (rad)');
ylabel('vitesse (m/s)');
