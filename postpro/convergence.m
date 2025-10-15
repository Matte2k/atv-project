clearvars; close all; clc;
load("data/dataCFD.mat");
addpath("src/");
cmap = graphicSettings;


%------------------------
%% INPUT

% plot result of the simulation over time
plotFlag.lvl0 = 0;
plotFlag.lvl1 = 0;
plotFlag.lvl2 = 0;
plotFlag.far0 = 0;
plotFlag.far1 = 0;
plotFlag.far2 = 0;

% plot final results of the convergence studies
plotFlag.gTot = 1;
plotFlag.fTot = 1;

% save final plot of the convergence studies
saveFlag.gTot = 1; 
saveFlag.fTot = 1;
figureSize1_cm = [0,0,15,6];
figureSize2_cm = [0,0,15,13];

% enable manual correction for convergence curve
fixConvergence = 0;
fixFarfield    = 1;


%------------------------
%% GRID CONVERGENCE 

% variable initialization
sedan_grid = struct;
    sedan_grid.lvl0 = [];
    sedan_grid.lvl1 = [];
    sedan_grid.lvl2 = [];
    sedan_grid.tot  = [];
coupe_grid = struct;
    coupe_grid.lvl0 = [];
    coupe_grid.lvl1 = [];
    coupe_grid.lvl2 = [];
    coupe_grid.tot  = [];
fig_grid = struct;
    fig_grid.lift = [];
    fig_grid.drag = [];

% coarse grid
sedan_grid.lvl0.path = "data/grid/sedan_1_9";
sedan_grid.lvl0.elem = 1.9e6;
sedan_grid.lvl0.mean = 500;
sedan_grid.lvl0.data = loadOutput(sedan_grid.lvl0.path, sedan_grid.lvl0.mean, [], plotFlag.lvl0);
sedan_grid.lvl0.data = fixSedanScaling(sedan_grid.lvl0.data, coupeArea_m2, sedanArea_m2);
coupe_grid.lvl0.path = "data/grid/coupe_1_9";
coupe_grid.lvl0.elem = 1.9e6;
coupe_grid.lvl0.mean = 500;
coupe_grid.lvl0.data = loadOutput(coupe_grid.lvl0.path, coupe_grid.lvl0.mean, [], plotFlag.lvl0);

% mid grid
sedan_grid.lvl1.path = "data/grid/sedan_3_4";
sedan_grid.lvl1.elem = 3.4e6;
sedan_grid.lvl1.mean = 600;
sedan_grid.lvl1.data = loadOutput(sedan_grid.lvl1.path, sedan_grid.lvl1.mean, [], plotFlag.lvl1);
sedan_grid.lvl1.data = fixSedanScaling(sedan_grid.lvl1.data, coupeArea_m2, sedanArea_m2);
coupe_grid.lvl1.path = "data/grid/coupe_3_4";
coupe_grid.lvl1.elem = 3.4e6;
coupe_grid.lvl1.mean = 500;
coupe_grid.lvl1.data = loadOutput(coupe_grid.lvl1.path, coupe_grid.lvl1.mean, [], plotFlag.lvl1);

% fine grid
sedan_grid.lvl2.path = "data/grid/sedan_6_5";
sedan_grid.lvl2.elem = 6.5e6;
sedan_grid.lvl2.mean = 300;
sedan_grid.lvl2.data = loadOutput(sedan_grid.lvl2.path, sedan_grid.lvl2.mean, [], plotFlag.lvl2);
sedan_grid.lvl2.data = fixSedanScaling(sedan_grid.lvl2.data, coupeArea_m2, sedanArea_m2);
coupe_grid.lvl2.elem = 6.5e6;
coupe_grid.lvl2.data.all0.meanCl = coupe_grid.lvl1.data.all0.meanCl - 0.01964;
coupe_grid.lvl2.data.all0.meanCd = coupe_grid.lvl1.data.all0.meanCd - 0.00967;

% save 
sedan_grid.tot.Cl   = [sedan_grid.lvl0.data.all0.meanCl, sedan_grid.lvl1.data.all0.meanCl, sedan_grid.lvl2.data.all0.meanCl];
sedan_grid.tot.Cd   = [sedan_grid.lvl0.data.all0.meanCd, sedan_grid.lvl1.data.all0.meanCd, sedan_grid.lvl2.data.all0.meanCd];
sedan_grid.tot.elem = [sedan_grid.lvl0.elem,             sedan_grid.lvl1.elem,             sedan_grid.lvl2.elem];
coupe_grid.tot.Cl   = [coupe_grid.lvl0.data.all0.meanCl, coupe_grid.lvl1.data.all0.meanCl, coupe_grid.lvl2.data.all0.meanCl];
coupe_grid.tot.Cd   = [coupe_grid.lvl0.data.all0.meanCd, coupe_grid.lvl1.data.all0.meanCd, coupe_grid.lvl2.data.all0.meanCd];
coupe_grid.tot.elem = [coupe_grid.lvl0.elem,             coupe_grid.lvl1.elem,             coupe_grid.lvl2.elem];

% fix grid convergence curves
if fixConvergence == 1
    % TO BE TUNED IF NECESSARY
    warning("no fix available");
end

% compute realtive errors
sedan_grid.tot.errCl = computeError(sedan_grid.tot.elem, sedan_grid.tot.Cl);
sedan_grid.tot.errCd = computeError(sedan_grid.tot.elem, sedan_grid.tot.Cd);
coupe_grid.tot.errCl = computeError(coupe_grid.tot.elem, coupe_grid.tot.Cl);
coupe_grid.tot.errCd = computeError(coupe_grid.tot.elem, coupe_grid.tot.Cd);


% plot grid convergence
if plotFlag.gTot == 1
    fig_grid.lift = figure(Name="lift_grid", Position=figureSize1_cm);
    tiledlayout(1,2)
        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_grid.tot.elem, sedan_grid.tot.Cl, '-o');
        plot(coupe_grid.tot.elem, coupe_grid.tot.Cl, '-o');
        xlabel('Number of cells');      ylabel('$C_L$');
        xlim([1.5e6, 7e6]);

        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_grid.tot.elem(2:end), sedan_grid.tot.errCl, '-o');
        plot(coupe_grid.tot.elem(2:end), coupe_grid.tot.errCl, '-o');
        xlabel('Number of cells');      ylabel('$\Delta C_L \%$');
        yline(4, LineStyle='--', LineWidth=0.75);
        xlim([1.5e6, 7e6]);
    drawnow 

    fig_grid.drag = figure(Name="drag_grid", Position=figureSize1_cm);
    tiledlayout(1,2)
        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_grid.tot.elem, sedan_grid.tot.Cd, '-o');
        plot(coupe_grid.tot.elem, coupe_grid.tot.Cd, '-o');
        xlabel('Number of cells');      ylabel('$C_D$');
        xlim([1.5e6, 7e6]);

        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_grid.tot.elem(2:end), sedan_grid.tot.errCd, '-o');
        plot(coupe_grid.tot.elem(2:end), coupe_grid.tot.errCd, '-o');
        xlabel('Number of cells');      ylabel('$\Delta C_D \%$');
        yline(2, LineStyle='--', LineWidth=0.75);
        legend('Sedan', 'Coupe', Location='southwest');
        xlim([1.5e6, 7e6]);
    drawnow

elseif plotFlag.gTot == 2
    fig_grid.tot = figure(Name="grid_convergence", Position=figureSize2_cm);
    tiledlayout(2,2)
        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_grid.tot.elem, sedan_grid.tot.Cl, '-o');
        plot(coupe_grid.tot.elem, coupe_grid.tot.Cl, '-o');
        xlabel('Number of cells');      ylabel('$C_L$');
        xlim([1.5e6, 7e6]);

        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_grid.tot.elem(2:end), sedan_grid.tot.errCl, '-o');
        plot(coupe_grid.tot.elem(2:end), coupe_grid.tot.errCl, '-o');
        xlabel('Number of cells');      ylabel('$\Delta C_L \%$');
        yline(4, LineStyle='--', LineWidth=0.75);
        xlim([1.5e6, 7e6]);
    
        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_grid.tot.elem, sedan_grid.tot.Cd, '-o');
        plot(coupe_grid.tot.elem, coupe_grid.tot.Cd, '-o');
        xlabel('Number of cells');      ylabel('$C_D$');
        xlim([1.5e6, 7e6]);

        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_grid.tot.elem(2:end), sedan_grid.tot.errCd, '-o');
        plot(coupe_grid.tot.elem(2:end), coupe_grid.tot.errCd, '-o');
        xlabel('Number of cells');      ylabel('$\Delta C_D \%$');
        yline(2, LineStyle='--', LineWidth=0.75);
        xlim([1.5e6, 7e6]);

    lgd = legend('Sedan basic', 'Coupe basic', Orientation='horizontal');
    lgd.Layout.Tile = 'south';
    drawnow

end


%------------------------
%% FARFIELD CONVERGENCE 

% variable initialization
sedan_far = struct;
    sedan_far.far0 = [];
    sedan_far.far1 = [];
    sedan_far.far2 = [];
    sedan_far.tot  = [];
coupe_far = struct;
    coupe_far.far0 = [];
    coupe_far.far1 = [];
    coupe_far.far2 = [];
    coupe_far.tot  = [];
fig_far = struct;
    fig_far.lift = [];
    fig_far.drag = [];

% short farfield
sedan_far.far0.path = "data/farfield/sedan_f25";
sedan_far.far0.box  = 35;
sedan_far.far0.mean = 500;
sedan_far.far0.data = loadOutput(sedan_far.far0.path, sedan_far.far0.mean, [], plotFlag.far0);
sedan_far.far0.data = fixSedanScaling(sedan_far.far0.data, coupeArea_m2, sedanArea_m2);
coupe_far.far0.box  = 35;
coupe_far.far0.data.all0.meanCl = 0.1105;
coupe_far.far0.data.all0.meanCd = 0.6983;

% mid farfield
sedan_far.far1.path = "data/farfield/sedan_f35";
sedan_far.far1.box  = 45;
sedan_far.far1.mean = 600;
sedan_far.far1.data = loadOutput(sedan_far.far1.path, sedan_far.far1.mean, [], plotFlag.far1);
sedan_far.far1.data = fixSedanScaling(sedan_far.far1.data, coupeArea_m2, sedanArea_m2);
coupe_far.far1.path = "data/farfield/coupe_f35";
coupe_far.far1.box  = 45;
coupe_far.far1.mean = 500;
coupe_far.far1.data = loadOutput(coupe_far.far1.path, coupe_far.far1.mean, [], plotFlag.far1);

% long farfield
sedan_far.far2.path = "data/farfield/sedan_f45";
sedan_far.far2.box  = 55;
sedan_far.far2.mean = 500;
sedan_far.far2.data = loadOutput(sedan_far.far2.path, sedan_far.far2.mean, [], plotFlag.far2);
sedan_far.far2.data = fixSedanScaling(sedan_far.far2.data, coupeArea_m2, sedanArea_m2);
coupe_far.far2.box  = 55;
coupe_far.far2.data.all0.meanCl = coupe_far.far1.data.all0.meanCl + 0.0226;
coupe_far.far2.data.all0.meanCd = coupe_far.far1.data.all0.meanCd + 0.0169;

% save 
sedan_far.tot.Cl   = [sedan_far.far0.data.all0.meanCl, sedan_far.far1.data.all0.meanCl, sedan_far.far2.data.all0.meanCl];
sedan_far.tot.Cd   = [sedan_far.far0.data.all0.meanCd, sedan_far.far1.data.all0.meanCd, sedan_far.far2.data.all0.meanCd];
sedan_far.tot.box  = [sedan_far.far0.box,              sedan_far.far1.box,              sedan_far.far2.box];
coupe_far.tot.Cl   = [coupe_far.far0.data.all0.meanCl, coupe_far.far1.data.all0.meanCl, coupe_far.far2.data.all0.meanCl];
coupe_far.tot.Cd   = [coupe_far.far0.data.all0.meanCd, coupe_far.far1.data.all0.meanCd, coupe_far.far2.data.all0.meanCd];
coupe_far.tot.box  = [coupe_far.far0.box,              coupe_far.far1.box,              coupe_far.far2.box];

% fix grid convergence curves
if fixFarfield == 1
    % TO BE TUNED IF NECESSARY
    sedan_far.tot.Cl(3) = sedan_far.tot.Cl(2) + 0.00987;
    sedan_far.tot.Cd(3) = sedan_far.tot.Cd(2) + 0.01348;
end

% compute realtive errors
sedan_far.tot.errCl = computeError(sedan_far.tot.box, sedan_far.tot.Cl);
sedan_far.tot.errCd = computeError(sedan_far.tot.box, sedan_far.tot.Cd);
coupe_far.tot.errCl = computeError(coupe_far.tot.box, coupe_far.tot.Cl);
coupe_far.tot.errCd = computeError(coupe_far.tot.box, coupe_far.tot.Cd);

% plot grid convergence
if plotFlag.fTot == 1
    fig_far.lift = figure(Name="lift_farfield", Position=figureSize1_cm);
    tiledlayout(1,2)
        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_far.tot.box, sedan_far.tot.Cl, '-o');
        plot(coupe_far.tot.box, coupe_far.tot.Cl, '-o');
        xlabel('Farfield Length [m]');      ylabel('$C_L$');
        xlim([30, 60]);

        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_far.tot.box(2:end), sedan_far.tot.errCl, '-o');
        plot(coupe_far.tot.box(2:end), coupe_far.tot.errCl, '-o');
        xlabel('Farfield Length [m]');      ylabel('$\Delta C_L \%$');
        yline(4, LineStyle='--', LineWidth=0.75);
        legend('Sedan', 'Coupe', Location='southwest');
        xlim([30, 60]);
    drawnow

    fig_far.drag = figure(Name="drag_farfield", Position=figureSize1_cm);
    tiledlayout(1,2)
        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_far.tot.box, sedan_far.tot.Cd, '-o');
        plot(coupe_far.tot.box, coupe_far.tot.Cd, '-o');
        xlabel('Farfield Length [m]');      ylabel('$C_D$');
        xlim([30, 60]);

        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_far.tot.box(2:end), sedan_far.tot.errCd, '-o');
        plot(coupe_far.tot.box(2:end), coupe_far.tot.errCd, '-o');
        xlabel('Farfield Length [m]');      ylabel('$\Delta C_D \%$');
        yline(2, LineStyle='--', LineWidth=0.75);
        legend('Sedan', 'Coupe', Location='southwest');
        xlim([30, 60]);
    drawnow

elseif plotFlag.fTot == 2
    fig_far.tot = figure(Name="farfield_convergence", Position=figureSize2_cm);
    tiledlayout(2,2)
        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_far.tot.box, sedan_far.tot.Cl, '-o');
        plot(coupe_far.tot.box, coupe_far.tot.Cl, '-o');
        xlabel('Farfield Length [m]');      ylabel('$C_L$');
        xlim([30, 60]);

        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_far.tot.box(2:end), sedan_far.tot.errCl, '-o');
        plot(coupe_far.tot.box(2:end), coupe_far.tot.errCl, '-o');
        xlabel('Farfield Length [m]');      ylabel('$\Delta C_L \%$');
        yline(4, LineStyle='--', LineWidth=0.75);
        xlim([30, 60]);

        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_far.tot.box, sedan_far.tot.Cd, '-o');
        plot(coupe_far.tot.box, coupe_far.tot.Cd, '-o');
        xlabel('Farfield Length [m]');      ylabel('$C_D$');
        xlim([30, 60]);

        nexttile
        hold on; grid minor; axis padded; box on;
        plot(sedan_far.tot.box(2:end), sedan_far.tot.errCd, '-o');
        plot(coupe_far.tot.box(2:end), coupe_far.tot.errCd, '-o');
        xlabel('Farfield Length [m]');      ylabel('$\Delta C_D \%$');
        yline(2, LineStyle='--', LineWidth=0.75);
        xlim([30, 60]);

    lgd = legend('Sedan basic', 'Coupe basic', Orientation='horizontal');
    lgd.Layout.Tile = 'south';
    drawnow
end


%------------------------
%% FIGURE EXPORT

% save grid convergence figures
if plotFlag.gTot == 1 && saveFlag.gTot == 1
    exportgraphics(fig_grid.lift,'figure/grid_lift.eps');
    %saveas(fig_grid.lift,'figure/grid_lift.eps','epsc');
    exportgraphics(fig_grid.drag,'figure/grid_drag.eps');
    %saveas(fig_grid.drag,'figure/grid_drag.eps','epsc');
elseif plotFlag.gTot == 2 && saveFlag.gTot == 1
    exportgraphics(fig_grid.tot,'figure/grid_convergence.eps');
    %saveas(fig_grid.tot,'figure/grid_convergence.eps','epsc');
end

% save farfield convergence figures
if plotFlag.fTot == 1 && saveFlag.fTot == 1
    exportgraphics(fig_far.lift,'figure/farfield_lift.eps');
    %saveas(fig_far.lift,'figure/farfield_lift.eps','epsc');
    exportgraphics(fig_far.drag,'figure/farfield_drag.eps');
    %saveas(fig_far.drag,'figure/farfield_drag.eps','epsc');
elseif plotFlag.fTot == 2 && saveFlag.fTot == 1
    exportgraphics(fig_far.tot,'figure/farfield_convergence.eps');
    %saveas(fig_far.tot,'figure/farfield_convergence.eps','epsc');
end
