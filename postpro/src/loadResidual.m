function [residualData, figHandle] = loadResidual(filePath, meanIter, plotFlag)
%LOAD RESIDUAL - load openFoam residual data file
%
%   syntax:
%       [residualData, figHandle] = loadResidual(filePath, meanIter, plotFlag)    
%
%   input:
%       filePath - path to the file
%       meanIter - number of iterations to average over
%       plotFlag - 1 to plot, 0 to not plot
%
%   output:
%       residualData - structure containing the force data
%       figHandle    - handle to the figure
%

    % optional inputs
    if nargin < 3  || isempty(plotFlag)
        plotFlag = 0;
    end

    if nargin < 2 || isempty(meanIter)
        meanIter = 1;
    end

    % variable initialization
    residualData = struct;
        residualData.table    = [];
        residualData.meanP    = [];
        residualData.meanUx   = [];
        residualData.meanUy   = [];
        residualData.meanOm   = [];
        residualData.meanK    = [];
        residualData.meanIter = [];
        residualData.totIter  = [];

    % read the data
    residualData.table = readtable(filePath, Delimiter='\t');

    % read iteration number data
    residualData.totIter  = length(residualData.table.p_final);
    residualData.meanIter = meanIter;

    % compute the mean values
    residualData.meanP    = mean(residualData.table.p_final(residualData.totIter-meanIter:end));
    residualData.meanUx   = mean(residualData.table.Ux_final(residualData.totIter-meanIter:end));
    residualData.meanUy   = mean(residualData.table.Uy_final(residualData.totIter-meanIter:end));
    residualData.meanOm   = mean(residualData.table.omega_final(residualData.totIter-meanIter:end));
    residualData.meanK    = mean(residualData.table.k_final(residualData.totIter-meanIter:end));

    % plot the data if requested
    if plotFlag
        figHandle = figure();
        set(gca, 'YScale', 'log');  hold on;
        semilogy(residualData.table.x_Time, residualData.table.p_final,     LineWidth=1.5);
        semilogy(residualData.table.x_Time, residualData.table.Ux_final,    LineWidth=1.5);
        semilogy(residualData.table.x_Time, residualData.table.Uy_final,    LineWidth=1.5);
        semilogy(residualData.table.x_Time, residualData.table.omega_final, LineWidth=1.5);
        semilogy(residualData.table.x_Time, residualData.table.k_final,     LineWidth=1.5);
        grid minor; axis padded; box on; hold off;

        % Labeling the plot
        xlabel('Time', Interpreter='latex');
        ylabel('Residuals', Interpreter='latex');
        legend('$p$', '$U_x$', '$U_y$', '$\omega$', '$k$', Interpreter='latex');
        title('Residuals Over Time', Interpreter='latex');
    else
        figHandle = [];
    end

end