function im = vdp_phase(N, pars)
%% Function to plot the van der pol oscillator 
% figure is in the phase coordinates.
figure();
% Set up the figure defaults.
close all;
clc;

% Solve the system of ode's.
tspan = linspace(0, 100, 1001); % time for the simulation.
t = tspan;
n = numel(tspan);

for k = 1:N
    Y0 = randn([1, 2]) * 0.1;
    if isfield(pars, 'forced_bool') == 1
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
set(gcf, 'color', 'k');

%% Prepare background for plot setup.
axis off; grid off; 
hold on;
% plot Nullclines
yline(0, 'w'); % Nx -- Nullcline in the x-variable.
xn = linspace(-0.99, 0.99, length(tspan)); % vary in x
Ny = xn./(pars.mu * (1 - xn.*xn) + eps); % Ny -- Nullcline in y-variable.
plot(xn, Ny, 'c'); 
tit = title(strcat('Van Der Pol Oscillator'), 'FontName', 'Times New Roman', 'FontSize', 16);
tit.Interpreter = 'latex';
tmp_val = round(pars.mu, 4);
stit = subtitle(strcat('$\mu$=', num2str(tmp_val)));
stit.Interpreter = 'latex';
xlab = text(-xm, 1, '$\Delta Pos = 0$', 'Interpreter', 'latex');
ylab = text(0, -ym, '$\Delta Vel = 0$', 'Interpreter', 'latex');
xlab.Color = 'white';
ylab.Color = 'cyan';

% plot the slope directional field.
[Xg, Yg] = meshgrid(linspace(-xm*1.05, xm*1.05, 25), linspace(-ym*1.05, ym*1.05, 25));
dX = Yg;
dY = pars.mu*(1 - Xg.*Xg).*Yg - Xg;
dY = dY ./ norm(dY);
dX = dX./ norm(dX);
M = sqrt(norm(dX) + norm(dY)); 
Q = quiver(Xg, Yg, dX, dY, M, 'Color', 'w');

% Plot Stationary Points.
fps = plot(0, 0, 'ko');
fps.Color = 'w';
fps.MarkerEdgeColor = 'k';
fps.MarkerFaceColor = 'w';



%% Continuation of plots.
% Array of graphics objects to store the lines. Could use a cell array.
xlim([-xm*1.15, 1.15*xm]); ylim([-ym*1.15,ym*1.15]);
axis off; grid off;
ylines = gobjects( N, n );


nFade = 7;


for ii = 1:n-1
    for k = 1:N
        % Plot the line
        ylines(ii, k) = line([X(ii:ii+1,k)], [Y(ii:ii+1, k)]);
        ylines(ii, k).Color = 'c';
    end
    for k = 1:N
        if ii == 1
            pause(1);
            % plot the traces
            phase_tr = plot(X(:,k), Y(:,k), 'c:'); hold on;
            phase_tr.Color(4) = 0.05;
        else
            pause(0.01);
        end
        % Note that we only need to go back as far as ii-nFade, earlier lines
        % will already by transparent with this method!
        for ip = max(1,ii-nFade):ii
            % Set the 4th Color attribute value (the alpha) as a percentages
            % from the current index. Could do this various ways.
            ylines(ip, k).Color(4) = max( 0, 1 - (ii-ip)/nFade );
        end
    end
    frame = getframe(fig);
    idx = ii;
    im{idx} = frame2im(frame);
end
%
%
%% Write to a Video!
Create_Video(im); % exporting to a video file!

end