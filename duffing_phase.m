function im = duffing_phase(N, pars, tspan, X, Y)
%% Function to plot the van der pol oscillator 
% figure is in the phase coordinates.
figure();
% Set up the figure defaults.
close all;
clc;

% Solve the system of ode's.
% tspan = 0:0.025:200; % linearly spaced points.
t = tspan;
n = numel(tspan);

ym = max(max(Y));
xm = max(max(X));

xmm = min(min(X));
ymm = min(min(Y));



%% Plot results;
fig = figure(1); clf; xlim([-xm * 1.15, xm*1.15]); ylim([-ym*1.15, ym*1.15]);
set_figure_defaults;
set(gcf, 'color', 'w');

%% Prepare background for plot setup.
axis off; grid off; 
hold on;
% plot Nullclines
yline(0, 'k'); % Nx -- Nullcline in the x-variable.
xn = linspace(xmm*1.15, xm*1.15, length(tspan)); % linearly spaced points -- x
Ny = 1/pars.delta * (-pars.alpha * xn - pars.beta * xn.^3); % Ny -- Nullcline in y-variable.
plot(xn, Ny, 'b'); 
tit = title(strcat('Duffing'), 'FontName', 'Times New Roman', 'FontSize', 16);
tit.Interpreter = 'latex';
% tmp_val = round(pars.mu, 4);
% stit = subtitle(strcat('$\mu$=', num2str(tmp_val)));
% stit.Interpreter = 'latex';
xlab = text(xmm, ymm, '$\Delta X = 0$', 'Interpreter', 'latex');
ylab = text(0, -ym, '$\Delta Y = 0$', 'Interpreter', 'latex');
xlab.Color = 'k';
ylab.Color = 'b';

% plot the slope directional field.
[Xg, Yg] = meshgrid(linspace(-xm*1.05, xm*1.05, 25), linspace(-ym*1.05, ym*1.05, 25));
dX = Yg; dX = dX./ norm(dX);
dY = - pars.delta * Yg - pars.alpha * Xg - pars.beta .* Xg^3; dY = dY ./ norm(dY); 
M = sqrt(norm(dX) + norm(dY)); 
Q = quiver(Xg, Yg, dX, dY, M, 'Color', 'k');

% Plot Stationary Points.
fps = plot(0, 0, 'ko');
fps.Color = 'w';
fps.MarkerEdgeColor = 'k';
fps.MarkerFaceColor = 'w';



%% Continuation of plots.
% Array of graphics objects to store the lines. Could use a cell array.
xlim([xmm*1.15, 1.15*xm]); ylim([ymm*1.15,ym*1.15]);
axis off; grid off;
ylines = gobjects( N, n );


nFade = 7;


for ii = 1:n-1
    for k = 1:N
        % Plot the line
        ylines(ii, k) = line([X(ii:ii+1,k)], [Y(ii:ii+1, k)]);
        ylines(ii, k).Color = 'k';
    end
    for k = 1:N
        if ii == 1
            pause(1);
            % plot the traces
            phase_tr = plot(X(:,k), Y(:,k), 'b:'); hold on;
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

end