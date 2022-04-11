function vdp_Master
%% Function to simulate Simple Harmonic Motion
% Master file.
close all;
flag = 0;
while flag==0
    mu = str2num(input("\n Please choose the value of mu, {NA} to stop:  \n", 's'));
    if strcmp(mu, 'NA')==1
        flag = 1;
    end % exit the loop
    N = str2num(input('\n Please enter the number of initial conditions, {NA} to stop: \n', 's'));
    [Y0, pars] = vdp_time(N, mu);
    vdp_phase(N, pars);
end
end