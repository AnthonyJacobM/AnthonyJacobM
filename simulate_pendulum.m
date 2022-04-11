function simulate_pendulum
%% Function to simulate the motion of the simple pendulum 
% Assume no friction, bob with mass m, with gravity g
% The system is conservative so energy is perserved.
l = 10; % length of the frictionless tether.
g = 9.81; % acceleration due to gravity.

%% Figure
figure();
set_figure_defaults;

% plot the boundaries of where the Bob is held.
yline(l, 'k'); hold on;
yline(l*1.25, 'k'); 
% plot equilibrium from the x-axis.
plot([0 0], [0 l], 'k:'); % axis of equilibrium.
% plot trajectory the pendulum can take.
xs = linspace(-pi, 0, 100);
plot(l*cos(xs), l+l*sin(xs), 'k:');
title('Simple Harmonic Motion', 'Interpreter', 'latex', 'FontSize', 18);


% plot the trajectory of the pendulum
N = floor(8*l);
for i = 1:N
    plot([-l + l*(i-1)/40, -l+l*i/40], [l, l*1.050], 'k-');
end


% random initial conditions.
flag = 0;
while flag ~= 1
    x0 = randi([-l, l], 1);
    if x0 == 0
        flag = 0;
    else 
        flag = 1;
    end
end

y0 = sqrt(l^2 - x0^2); % initial y-coord.
theta0 = atan(y0/x0); % arbitrary angle 
%theta0 = abs(norm(1)) / 10; % small-angle approximation.
T0 = 2 * pi * sqrt(l / g); % approximated period: theta0 << 1
omega0 = eps * randn(1);

% solve the ode.
tspan = 0:0.05:10; y0 = [theta0, omega0]; 
pars.l = l;
pars.g = g;
[T, Y] = ode45(@(t, y) shm(t, y, pars), tspan, y0);
theta = Y(:,1); 
omega = Y(:,2); 
X = l * sin(theta); % x-coordinate
Y = l - l * cos(theta); % y-coordinate

% plot the results
set_figure_defaults;
axis off; grid off;
for i = 1:length(tspan)
    plot(0, l, 'ys', 'MarkerFaceColor', 'yellow', 'MarkerEdgeColor', 'k', 'MarkerSize', 15);
    plot([X(i), 0], [Y(i), l], 'k-', 'LineWidth', 1.15); hold on;
    plot(X(i), Y(i), 'ko', 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'black', 'MarkerSize', 12);
    drawnow;
end

% figure();
% h2 = animatedline;
% axis([tspan(1), tspan(end), min(X), max(X)]);
% for k = 1:length(tspan)
%     addpoints(h2, tspan(k), X(k)); 
%     drawnow;
% end

end