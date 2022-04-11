function dxdt = duffing_ode(t, Y, pars)
% Function to generate differential equation of duffing equation
% INPUT:
% t -- time
% y -- state-variable dimension 3
% pars -- str containing parameters
% OUTPUT: 
% dxdt -- derivative

%% Unpack inputs
if isfield(pars, 'gamma')
    gamma = pars.gamma;
else
    gamma = 0.22;
end

if isfield(pars, 'omega')
    omega = pars.omega;
else
    omega = pi / 12;
end

if isfield(pars, 'delta')
    delta = pars.delta;
else
    delta = 1.1;
end

if isfield(pars, 'alpha')
    alpha = pars.alpha;
else
    alpha = 0.32;
end

if isfield(pars, 'beta')
    beta = pars.beta;
else
    beta = 0.62;
end

%% ODE's on the right hand side!
x = Y(1);
y = Y(2);
z = Y(3);

dx = y; % change in x.
dy = gamma * cos(omega * z) - delta * y - alpha * x - beta * x^3; % change in y.
dz = 1; % change in z.

dxdt = [dx; dy; dz];
end