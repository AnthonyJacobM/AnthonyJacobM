function sys = System_gen(inp)
% Function to generate a system of differential equations
% INPUT: tspan, Y0 (ics), pars, dYdT (rhs)
% Output: sys -- structure containing INPUTs.
inp = lower(inp); % lowercase!

%% Set defaults
if strcmp(inp, 'vdp')
    pars.mu = 1;
    Y0 = rand(1,2) * 0.01;
elseif strcmp(inp, 'duffing')
    pars.alpha = 1;
    pars.beta = 5;
    pars.delta = 0.02;
    pars.gamma = 8;
    pars.omega = 0.5;
    Y0 = rand(1,2) * 0.01;
    Y0(end+1) = 0.001;
elseif strcmp(inp, 'predpreylog')
    pars.a = 0.21;
    pars.b = 0.45;
    pars.c = 0.38;
    pars.d = 0.48;
    pars.e = 0.02;
    Y0 = rand(1,2) * 0.01;
end

ti = str2num(input('\n Please choose an initial time: \n', 's'));
tf = str2num(input('\n Please choose a final time: \n', 's'));
h = str2num(input('\n Please choose a integration step size: \n', 's'));
tspan = ti:h:tf;

sys.tspan = tspan;
sys.Y0 = Y0;
sys.pars = pars;

end