function [Y0, pars] = vdp_time(N, pars)
%% Function to plot the coordinates (x, y) as a function of time.
% van_der_pol is an altered version of the simple harmonic oscillator.
% Set up the figure defaults.
close all;
clc;

% Solve the system of ode's.
tspan = linspace(0, 100, 1001); % time for the simulation
t = tspan;
n = numel(tspan);
eps = 1e-3; % A small value
for k = 1:N
    Y0 = eps*randn(1,2); % random initial conditions.
    if isfield(pars, 'forced_bool')
        if pars.forced_bool == 1
            Y0(end + 1) = rand(1) * 0.01;
        end
    end

    [T, Y] = ode45(@(t, y) van_der_pol(t, y, pars), t, Y0); % integrate RK-45
    x{k} = Y(:,1); % variable in x-coordinate.
    y{k} = Y(:,2); % vairable in y-coordinate.
end

X = cell2mat(x);
Y = cell2mat(y);
ym = max(max(Y));
xm = max(max(X));



%% Plot results;
fig = figure(1); clf; xlim([-xm * 1.15, xm*1.15]); ylim([-ym*1.15, ym*1.15]);
set_figure_defaults;


%% Prepare background for plot setup.
axis off; grid off; 
hold on;
yline(0, 'k-');
tit = title(strcat('Van Der Pol Oscillator'), 'FontName', 'Times New Roman', 'FontSize', 16);
tit.Interpreter = 'latex';
tmp_val =round(pars.mu, 4);
stit = subtitle(strcat('$\mu$=', num2str(tmp_val)));
stit.Interpreter = 'latex';
xlab = text(-xm*0.55, -ym*0.9, 'Position', 'Interpreter', 'latex');
ylab = text(-xm*0.55, ym*0.9, 'Velocity', 'Interpreter', 'latex');
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
xlim([-1, tspan(end)]); ylim([-ym*1.15,ym*1.15]);
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
% 
%% Export as a Video!
Create_Video(im);
end