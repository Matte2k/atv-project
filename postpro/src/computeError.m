function [relError, figHandle] = computeError(cells, value, plotFlag)
%COMPUTE ERROR - compute relative error in grid convergence
%
%   syntax:
%       [error, figHandle] = computeError(cells, value, plotFlag)
%
%   input:
%       cells - vector containing number of cells
%       value - vector containing cfd results
%       plotForce - 1 to plot, 0 to not plot
%
%   output:
%       relError - vector containing relative errors
%       figHandle - handle to the figure
%

    % optional inputs
    if nargin < 3  || isempty(plotFlag)
        plotFlag = 0;
    end

    % compute relative error between two consecutive grids level
    relError = zeros(1,length(value)-1);
    for i = 1:length(relError)
        %relError(i) = abs((value(i+1)-value(i))/value(i))*100;
        relError(i) = abs((value(i+1)-value(i)))*100;
    end

    % plot relative erro plot
    if plotFlag == 1
        figHandle = figure();
            loglog(cells(2:end), relError, 'o-', 'LineWidth', 2);
            %set(gca, 'XDir','reverse')     % from max cells to min
            xlabel('Numero di celle');
            ylabel('Errore relativo');
            title(sprintf('Convergence Analysis'));
            grid minor; axis padded; box on;
    else
        figHandle = [];
    end

end