function dxdt = van_der_pol(t, Y, pars)
%% Function to construct the Vand Der Pol Oscillator
% Input: t ~ time
% Input: Y ~ variable -- 2 x1 vecor input
% Input: pars ~ field containing parameters: mu.
x = Y(1);
y = Y(2);
z = Y(3);
% construct bounds on the parameter: {mu}.
% -- Damping coefficient
if isfield(pars, 'mu')
   mu = pars.mu;
else
   mu = 8.53;
end
% -- Amplitude of Perturbation
if isfield(pars, 'A')
   A = pars.A;
else
   A = 1.2;
end
% -- Angular Frequency
if isfield(pars, 'w')
   w = pars.w;
else
   w = 2 * pi / 10;
end
% -- Forced output
if isfield(pars, 'forced_bool')
    forced_bool = pars.forced_bool;
else
    forced_bool = 0;
end

dx = y; % change in x-coordinates
dy = mu*(1 - x*x)*y-x; % change in y coordinates.
dz = 1; % t = z --> dynamic variable for forced vdp.

if forced_bool==1
    dy = dy + A * sin(w * z);
    dxdt = [dx; dy; dz];
else
    dxdt = [dx; dy];
end

end