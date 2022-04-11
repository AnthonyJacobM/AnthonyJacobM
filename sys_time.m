function [im, X, Y, pars] = sys_time(N, pars, tspan, sys_id)
%% Function to plot a general system of ode's in time.
% Set up the figure defaults.
close all;
clc;
sys_id = lower(sys_id); % lowercase on the system identification.

%% Get the system by requesting the user's input.

% Solve the system of ode's.
%tspan = 0:0.25:50;
t = tspan;
n = numel(tspan);
eps = 1e-2; % A small value
for k = 1:N
    Y0 = eps*randn(1,2); % random initial conditions.
    if isfield(pars, 'forced_bool')
        if pars.forced_bool == 1
            Y0(end + 1) = rand(1) * 0.001;
        end
    end
    if strcmp(sys_id, 'vdp')
        [T, Y] = ode45(@(t, y) van_der_pol(t, y, pars), t, Y0); % integrate RK-45
    elseif strcmp(sys_id, 'duffing')
        Y0(end+1) = 0.01 * rand(1);
        [T, Y] = ode45(@(t, y) duffing_ode(t, y, pars), t, Y0); % integrate RK-45
    end

    x{k} = Y(:,1); % variable in x-coordinate.
    y{k} = Y(:,2); % vairable in y-coordinate.
end

X = cell2mat(x);
Y = cell2mat(y);
ym = max(max(Y));
xm = max(max(X));
xmm = min(min(X));
ymm = min(min(Y));



%% Plot results;
fig = figure(1); clf; 
set_figure_defaults;
set(gca, 'color', 'w');

%% Prepare background for plot setup.
axis off; grid off; 
hold on;
yline(0, 'k-');
usr_tit = input('\n Please choose a Title Name \n', 's');
tit = title(usr_tit, 'FontName', 'Times New Roman', 'FontSize', 16);
tit.Interpreter = 'latex';
disp(fields(pars));
pname = input('\n Please choose one of the paramers listed in **pars** above: \n', 's');

%stit = subtitle(strcat(pname, '=', num2str(pars.(pname))));
%stit.Interpreter = 'latex';
xlab = text(xmm*1.05, ym*1.10, 'X', 'Interpreter', 'latex');
ylab = text(xmm*1.05, ym*0.50, 'Y', 'Interpreter', 'latex');
text(min(tspan)*1, ym*0.10, '$t_0$', 'Interpreter', 'latex');
text(max(tspan)*1, ym*0.10, '$t_f$', 'Interpreter', 'latex');
xlab.Color = 'black';
ylab.Color = 'blue';

for k = 1:N
    xl = plot(tspan, X(:,k), 'k:');
    hold on;
    yl = plot(tspan, Y(:,k), 'b:');
    xl.Color(4) = 0.05;
    yl.Color(4) = 0.05;
end

%% Continuation of plots.
% Array of graphics objects to store the lines. Could use a cell array.
xlim([tspan(1)-1, tspan(end)+1]); ylim([min(xmm,ymm)*1.15,max(xm,ym)*1.15]);
axis off; grid off;
xlines = gobjects(N, n );
ylines = gobjects(N, n );
nFade = 7;

% Main plotting loop
for ii = 1:n-1
    for k = 1:N
        % Plot the line
        xlines(k,ii) = line([tspan(ii:ii+1)], [X(ii:ii+1, k)]);
        xlines(k,ii).Color = 'k';
        xlines(k,ii).LineWidth = 2;
        ylines(k,ii) = line([tspan(ii:ii+1)], [Y(ii:ii+1, k)]);
        ylines(k,ii).Color = 'b';
        ylines(k,ii).LineWidth = 2;
    end
    if ii == 1
        pause(1);
    else
        pause(0.01);
    end
        % Note that we only need to go back as far as ii-nFade, earlier lines
        % will already by transparent with this method!
    for k = 1:N
        for ip = max(1,ii-nFade):ii
            % Set the 4th Color attribute value (the alpha) as a percentage
            % from the current index. Could do this various ways.
            xlines(k, ip).Color(4) = max( 0, 1 - (ii-ip)/nFade );
            ylines(k, ip).Color(4) = max( 0, 1 - (ii-ip)/nFade );
        end
    end
    frame = getframe(fig);
    idx = ii;
    im{idx} = frame2im(frame);
end
%

end