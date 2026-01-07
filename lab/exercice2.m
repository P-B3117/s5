OB = 0.1;
AB = 0.45;
omegaOB = 60 / 60 * 2*pi;
teta = linspace(0, 2*pi, 100);
beta = asin((OB * (1 + cos(teta))) / AB);

omegaAB = (-OB * omegaOB * sin(teta)) ./ (AB * cos(beta));
velLame = (-OB * omegaOB * cos(teta)) + (AB * omegaAB .* sin(beta));
alphaAB = (-OB * omegaOB^2 * cos(teta) + AB * omegaAB.^2 .* sin(beta)) ./ (AB * cos(beta));
accelLinLame = (OB * omegaOB^2 * sin(teta)) + (AB * omegaAB.^2 .* cos(beta)) + (AB * alphaAB .* sin(beta));

% Plot
figure;

% Blade speed subplot
subplot(3, 2, 1);
plot(teta, velLame, 'LineWidth', 2);
grid on;
xlabel('Angle teta (deg)');
ylabel('Velocity (m/s)');
title('Acceleration Profile of Lame vs Rotation');
xlim([0, 2*pi]);

% Angular AB speed subplot
subplot(3, 2, 3);
plot(teta, omegaAB, 'LineWidth', 2);
grid on;
xlabel('Angle teta (deg)');
ylabel('Angular Velocity (rad/s)');
title('Angular Velocity Profile of AB vs Rotation');
xlim([0, 2*pi]);

% Linear blade acceleration subplot
subplot(3, 2, 2);
plot(teta, accelLinLame, 'LineWidth', 2);
grid on;
xlabel('Angle teta (deg)');
ylabel('Acceleration (m/s^2)');
title('Acceleration Profile of Lame vs Rotation');
xlim([0, 2*pi]);

% Angular AB acceleration subplot
subplot(3, 2, 4);
plot(teta, alphaAB, 'LineWidth', 2);
grid on;
xlabel('Angle teta (deg)');
ylabel('Angular Acceleration (rad/s^2)');
title('Angular Acceleration Profile of AB vs Rotation');
xlim([0, 2*pi]);

% AB angle subplot
subplot(3, 2, 5);
plot(teta, beta, 'LineWidth', 2);
grid on;
xlabel('Angle teta (deg)');
ylabel('Angle beta (rad)');
title('Angle Profile of AB vs Rotation');
xlim([0, 2*pi]);
