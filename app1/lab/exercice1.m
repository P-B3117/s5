A_MAX = 5.886;
V_MAX = 400 / 3600 * 1000;
D_MAX = 10000;

a1 = A_MAX;
a2 = 0;
a3 = -A_MAX;

t1 = V_MAX / a1;
t2 = (D_MAX / V_MAX) - t1;
t3 = t1;

% Create time vectors for each phase
time1 = linspace(0, t1, 100);
time2 = linspace(t1, t1 + t2, 100);
time3 = linspace(t1 + t2, t1 + t2 + t3, 100);

% Create acceleration for each phase
accel1 = a1 * ones(size(time1));
accel2 = a2 * ones(size(time2));
accel3 = a3 * ones(size(time3));

% Create velocity for each phase
vel1 = cumtrapz(time1, accel1);
vel2 = vel1(end) + cumtrapz(time2, accel2);
vel3 = vel2(end) + cumtrapz(time3, accel3);

% Create displacement for each phase
pos1 = cumtrapz(time1, vel1);
pos2 = pos1(end) + cumtrapz(time2, vel2);
pos3 = pos2(end) + cumtrapz(time3, vel3);

% Plot
figure;

% Acceleration subplot
subplot(3, 1, 1);
hold on;
plot(time1, accel1, 'r', 'LineWidth', 2);
plot(time2, accel2, 'g', 'LineWidth', 2);
plot(time3, accel3, 'b', 'LineWidth', 2);
plot([t1, t1], ylim, '--k', 'LineWidth', 1.5);
plot([t1 + t2, t1 + t2], ylim, '--k', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
title('Acceleration Profile vs Time');

% Velocity subplot
subplot(3, 1, 2);
hold on;
plot(time1, vel1, 'r', 'LineWidth', 2);
plot(time2, vel2, 'g', 'LineWidth', 2);
plot(time3, vel3, 'b', 'LineWidth', 2);
plot([t1, t1], ylim, '--k', 'LineWidth', 1.5);
plot([t1 + t2, t1 + t2], ylim, '--k', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Velocity Profile vs Time');

% Displacement subplot
subplot(3, 1, 3);
hold on;
plot(time1, pos1, 'r', 'LineWidth', 2);
plot(time2, pos2, 'g', 'LineWidth', 2);
plot(time3, pos3, 'b', 'LineWidth', 2);
plot([t1, t1], ylim, '--k', 'LineWidth', 1.5);
plot([t1 + t2, t1 + t2], ylim, '--k', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Displacement (m)');
title('Displacement Profile vs Time');
