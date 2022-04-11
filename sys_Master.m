function sys_Master
%% Function to animate a System using the Master **file**.
close all;
flag = 0;
sys_list = ["Vdp", "Duffing", "SHM", "PredPreyLog"];
disp(sys_list);
sys_id = input('\n Please choose a System to Simulate: ', 's');
sys = System_gen(lower(sys_id));
pars = sys.pars;

% case: Duffing Iteration gamma_bin
load duffing_case_I.mat;
fprintf('\n Gamma Values to choose from: \n ');
disp(gamma_bin); % variation in gamma!

% Y0 = sys.Y0;
tspan = sys.tspan;
while flag==0
    disp(fields(pars));
    p0 = string(input("\n Please choose one of the parameters, {NA} to stop:  \n", 's'));
    if strcmp(p0, 'NA')==1
        flag = 1;
    else
        tmp = str2num(input('\n Please choose a value for the parameter: \n ', 's'));
        pars.(p0) = tmp;
    end % exit the loop
    N = str2num(input('\n Please enter the number of initial conditions, {NA} to stop: \n', 's'));
    [im, X, Y, pars] = sys_time(N, pars, tspan, sys_id);
    %vid_flag = input('\n 1 for video {0} for no video: \n ', 's');
    vid_flag = '1';
    if strcmp(vid_flag, '1')
        % Create a Video!
        Create_Video(im);
    end
    %% Phase
    if strcmp(sys_id, 'Duffing')
        im = duffing_phase(N, pars, tspan, X, Y);
    elseif strcmp(sys_id, 'Vdp')
        im = vdp_phase(N, pars);
    elseif strcmp(sys_id, 'PredPreyLog')
        im = predpred_phase(N, pars);
    end
    % 
    %vid_flag = input('\n 1 for video {0} for no video: \n ', 's');
    vid_flag = '1';
    if strcmp(vid_flag, '1')
        % Create a Video!
        Create_Video(im);
    end
end
end