function SimpleHarmonicMotion_kinetics_V2(Y0)
%% Function to construct a video that fades and illustrates the simple harmonic oscillator.
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
if isempty(Y0)==0
    Y0 = Y0;    
else
    Y0 = [theta0, omega0]; 
end

pars.l = l; % length from the fulcrum to the bob.
pars.g = g; % accelaration due to gravity.
[T, Y] = ode45(@(t, y) shm(t, y, pars), tspan, Y0);
theta = Y(:,1); % angle displaced from fulcrum to bob.
omega = Y(:,2); % angular velocity of the bob.
X = l * sin(theta); % x-coordinate rel. to eq.
Y = l - l * cos(theta); % y-coordinate rel. to eq.


%% plot the results
fig = figure(1); clf; xlim([-l*1.05,l*1.05]); ylim([-0.25,l*1.35]);
set_figure_defaults;
axis off; grid off;

%% Prepare background for plot setup.
plot(0, l, 'ys', 'MarkerFaceColor', 'yellow', 'MarkerEdgeColor', 'k', 'MarkerSize', 15);
% plot the boundaries of where the Bob is held.
yline(l, 'k'); hold on;
yline(l*1.25, 'k'); 
% plot equilibrium from the x-axis.
plot([0 0], [0 l], 'k:'); % axis of equilibrium.
% plot trajectory the pendulum can take.
xs = linspace(-pi, 0, 100);
plot(l*cos(xs), l+l*sin(xs), 'k:');
Tf = text(-1.5, l+1.05, "Fulcrum");
Teq = text(-2.05, -0.65, "Equilibrium");
Tf.Interpreter = 'latex';
Tf.FontSize = 16;
Teq.Interpreter = 'latex';
Teq.FontSize = 16;

title('Simple Harmonic Motion', 'Interpreter', 'latex', 'FontSize', 18);
% Braces on top.
N = floor(8*l);
for i = 1:N
    plot([-l + l*(i-1)/40, -l+l*i/40], [l, l*1.050], 'k-');
end
axis off; grid off; % grid and axis off.
plot(0, 0, 'r^', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');

%% Label of starting condition
dby = drawbrace([X(1), 0], [X(1), Y(1)], 20, 'Color', 'b');
dbx = drawbrace([X(1), Y(1)], [0, Y(1)], 20, 'Color', 'b');

dby_r = drawbrace([-X(1), Y(1)], [-X(1), 0], 20, 'Color', 'b');
dbx_r = drawbrace([0, Y(1)], [-X(1), Y(1)], 20, 'Color', 'b');

% draw
dx_xpos = dbx.XData(length(dbx.XData)/2);
dx_ypos = dbx.YData(length(dby.YData)/2);

dy_xpos = dby.XData(length(dby.XData)/2);
dy_ypos = dby.YData(length(dby.YData)/2);

T_dbx=text(dx_xpos,dx_ypos+1*sign(X(1)), "x");
T_dby=text(dy_xpos+1*sign(X(1)), dy_ypos, "y");

T_dbx_r=text(dx_xpos*-1,dx_ypos+1*sign(X(1)), "x");
T_dby_r=text(dy_xpos*-1+1*sign(X(1)), dy_ypos, "y");


T_dbx.Interpreter = 'latex';
T_dby.Interpreter = 'latex';
T_dbx.FontSize = 12;
T_dby.FontSize = 12;

T_dbx_r.Interpreter = 'latex';
T_dby_r.Interpreter = 'latex';
T_dbx_r.FontSize = 12;
T_dby_r.FontSize = 12;

%% Continuation of plots.
% Array of graphics objects to store the lines. Could use a cell array.
lines = gobjects( 1, n );
marbles = gobjects( 1, n );

% "Buffer" size, number of historic lines to keep, and governs the 
% corresponding fade increments.
nFade = 7;

% Main plotting loop
for ii = 1:n
    % Plot the line
    lines(ii) = line( [X(ii), 0], [Y(ii), l]);
    xlines(ii) = line( [X(ii), 0], [Y(ii), Y(ii)]);
    ylines(ii) = line( [X(ii), X(ii)], [Y(ii), 0]);

    lines(ii).Color = 'k';
    xlines(ii).Color = 'k';
    ylines(ii).Color = 'b';

    hold on;
    marbles(ii) = plot(X(ii), Y(ii), 'ko', 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'black', 'MarkerSize', 12);
    % Loop over past lines.
    if ii == 1
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
        xlines(ip).Color(4) = max( 0, 1 - (ii-ip)/nFade );
        ylines(ip).Color(4) = max( 0, 1 - (ii-ip)/nFade );

    end
    
    for ip = max(1,ii-nFade):ii
        % Set the 4th Color attribute value (the alpha) as a percentage
        % from the current index. Could do this various ways.
        %marbles(ip).MarkerFaceColor = max( 0, 1 - (ii-ip)/nFade );
        marbles(ip).MarkerFaceColor = [0 0 1] * (1-(ii-ip)/nFade);
        fadeBool = logical((1-(ii-ip)/nFade)~=0);
        marbles(ip).Visible = fadeBool;
    end
    frame = getframe(fig);
    idx = ii;
    im{idx} = frame2im(frame);
    % Delay for animation
    %pause(0.1); 
end
%
nImages = n;
% export to a .gif file.
filename = 'Simple_Harmonic_Motion_Kinetic_Dynamics_V2.gif'; % Specify the output file name
for idx = 1:nImages
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.05);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.05);
    end
end
end