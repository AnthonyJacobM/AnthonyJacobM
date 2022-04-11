function Y0 = SimpleHarmonicMotion_time
%% Function to construct a video that fades and illustrates the simple harmonic oscillator.
clear all;
close all;
clc;
l = 10; % length of the frictionless tether.
g = 9.81; % acceleration due to gravity.

%% ICS
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
tspan = 0:0.05:10; n = numel(tspan); % time to integrate over.
Y0 = [theta0, omega0]; 
pars.l = l; % length from the fulcrum to the bob.
pars.g = g; % accelaration due to gravity.
[T, Y] = ode45(@(t, y) shm(t, y, pars), tspan, Y0);
theta = Y(:,1); % angle displaced from fulcrum to bob.
omega = Y(:,2); % angular velocity of the bob.
X = l * sin(theta); % x-coordinate rel. to eq.
Y = l - l * cos(theta); % y-coordinate rel. to eq.

% find the peaks of position
% t_pk = local_max(X);
% find crossing of the equilibrium.
% t_cr = local_max(-Y); 

%% plot the results
fig = figure(2); clf; xlim([-1, tspan(end)]); ylim([-l*1.15,l*1.15]);
set_figure_defaults;
%axis off; grid off;

%% Prepare background for plot setup.

axis off; grid off; % grid and axis off.
hold on;
yline(0, 'k--');
yline(l, 'k--');
xline(tspan(1), 'k--');
xline(tspan(end), 'k--');
plot(linspace(0, tspan(end), 5), repelem(0, 5), 'r^', 'MarkerSize', 15,  'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');
plot(linspace(0, tspan(end), 5), repelem(l, 5), 'ys', 'MarkerSize', 15,  'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k');

% Uncomment below if one wishes to show the traces.
% plot(tspan, X, 'k:');
% plot(tspan, Y, 'b:');

xlabel('Time', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('Displacement From Equilibrium', 'Interpreter', 'latex', 'FontSize', 14);
title('Simple Harmonic Motion', 'Interpreter', 'latex', 'FontSize', 18);


%% Continuation of plots.
% Array of graphics objects to store the lines. Could use a cell array.
xlim([-1, tspan(end)]); ylim([-l*1.15,l*1.15]);
axis off; grid off;
lines = gobjects( 1, n );
ylines = gobjects( 1, n );

% "Buffer" size, number of historic lines to keep, and governs the 
% corresponding fade increments.
nFade = 7;

% Main plotting loop
for ii = 1:n-1
    % Plot the line
    lines(ii) = line([tspan(ii), tspan(ii+1)], [X(ii), X(ii+1)]);
    lines(ii).Color = 'k';
    ylines(ii) = line([tspan(ii), tspan(ii+1)], [Y(ii), Y(ii+1)]);
    ylines(ii).Color = 'b';
    ylines(ii).LineWidth = 2;
    lines(ii).LineWidth = 2;
    if ii == 1
        dbx = drawbrace([min(0, X(1)), max(0, X(1))], [0, 0], 20, 'Color', 'k'); hold on;
        dby = drawbrace( [min(0, Y(1)), max(0, Y(1))], [0, 0], 10, 'Color', 'b');
        dx_xpos = dbx.XData(length(dbx.XData)/2);
        dx_ypos = dbx.YData(length(dby.YData)/2);
        
        dy_xpos = dby.XData(length(dby.XData)/2);
        dy_ypos = dby.YData(length(dby.YData)/2);
        
        T_dbx=text(dx_xpos,dx_ypos, "X");
        T_dby=text(dy_xpos-0.65, dy_ypos, "Y");
        T_eq = text(mean(tspan)-1.15, -1.50, "Equilibrium");
        T_ful = text(mean(tspan)-0.65, l-1.35, 'Fulcrum');
        
        T_dbx.Interpreter = 'latex';
        T_dby.Interpreter = 'latex';
        T_eq.Interpreter = 'latex';
        T_eq.FontSize = 12;
        T_ful.Interpreter = 'latex';
        T_ful.FontSize = 12;
        T_dbx.FontSize = 12;
        T_dby.FontSize = 12;
        pause(1);
    else
        pause(0.01);
    end
    % Note that we only need to go back as far as ii-nFade, earlier lines
    % will already by transparent with this method!
    for ip = max(1,ii-nFade):ii
        % Set the 4th Color attribute value (the alpha) as a percentage
        % from the current index. Could do this various ways.
        lines(ip).Color(4) = max( 0, 1 - (ii-ip)/nFade );
        ylines(ip).Color(4) = max( 0, 1 - (ii-ip)/nFade );
    end
    frame = getframe(fig);
    idx = ii;
    im{idx} = frame2im(frame);
end
%
nImages = n-1;
% export to a .gif file.
filename = 'Simple_Harmonic_Motion_Displacement_Dynamics.gif'; % Specify the output file name
for idx = 1:nImages
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.05);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.05);
    end
end
end