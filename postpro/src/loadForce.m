function [forceData, figHandle] = loadForce(filePath, meanIter, plotFlag)
%LOAD FORCE - load openFoam force data file
%
%   syntax:
%       [forceData, figHandle] = loadForce(filePath, meanIter, plotFlag)    
%
%   input:
%       filePath - path to the file
%       meanIter - number of iterations to average over
%       plotFlag - 1 to plot, 0 to not plot
%
%   output:
%       forceData - structure containing the force data
%       figHandle - handle to the figure
%

    % optional inputs
    if nargin < 3  || isempty(plotFlag)
        plotFlag = 0;
    end

    if nargin < 2 || isempty(meanIter)
        meanIter = 1;
    end

    % variable initialization
    forceData = struct;
        forceData.table    = [];
        forceData.meanCl   = [];
        forceData.meanCd   = [];
        forceData.meanCm   = [];
        forceData.meanIter = [];
        forceData.totIter  = [];

    % read the data
    forceData.table = readtable(filePath, Delimiter='\t');

    % read iteration number data
    forceData.totIter  = length(forceData.table.Cl);
    forceData.meanIter = meanIter;

    % compute the mean values
    forceData.meanCl   = mean(forceData.table.Cl(forceData.totIter-meanIter:end));
    forceData.meanCd   = mean(forceData.table.Cd(forceData.totIter-meanIter:end));
    forceData.meanCm   = mean(forceData.table.CmPitch(forceData.totIter-meanIter:end));

    % plot the data if requested
    if plotFlag
        figHandle = figure();
        hold on; 
        plot(forceData.table.x_Time, forceData.table.Cd, LineWidth=1.5);
        plot(forceData.table.x_Time, forceData.table.Cl, LineWidth=1.5);
        plot(forceData.table.x_Time, forceData.table.CmPitch, LineWidth=1.5);
        yline(0, LineStyle='--', Color='k', LineWidth=1);
        yline(forceData.meanCl,  Color=[0.8500, 0.3250, 0.0980], LineWidth=0.75);
        yline(forceData.meanCd,  Color=[0.0000, 0.4470, 0.7410], LineWidth=0.75);
        yline(forceData.meanCm,  Color=[0.9290, 0.6940, 0.1250], LineWidth=0.75);
        grid minor; axis padded; box on; hold off;

        % Labeling the plot
        xlabel('Time', Interpreter='latex');
        ylabel('Force Coefficient', Interpreter='latex');
        legend('$C_d$', '$C_l$', '$C_m$', Interpreter='latex');
        title('Force Coefficients Over Time', Interpreter='latex');
    else
        figHandle = [];
    end

end