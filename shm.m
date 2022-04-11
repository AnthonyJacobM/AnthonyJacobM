function dydt = shm(t, y, pars)
%% Function to plot the Simple Harmonic Motion of a pendulum.
% t ~ time
% y ~ theta, omega
% pars ~ g, l
if isfield(pars, 'g') 
    g = pars.g; 
else 
    g = 9.81; 
end

if isfield(pars, 'l') 
    l = pars.l; 
else 
    l = 10; 
end

theta = y(1); % angular displacement from equilibrium.
omega = y(2); % angular velocity.

dtheta = y(2);
domega = -g/l*sin(y(1));

dydt = [dtheta; domega]; 
end