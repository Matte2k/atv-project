function [outputData, figForce, figResidual] = loadOutput(filePath, meanIter, spoilerFlag, plotForce, plotResidual)
%LOAD OUTPUT - load openFoam output data file
%
%   syntax:
%       [outputData, figForce, figResidual] = loadOutput(filePath, meanIter, spoilerFlag, plotForce, plotResidual)
%
%   input:
%       filePath - path to the file
%       meanIter - number of iterations to average over
%       spoilerFlag - 1 if the spoiler path is presente, 0 if not 
%       plotForce - 1 to plot, 0 to not plot
%       plotResidual - 1 to plot, 0 to not plot
%
%   output:
%       outputData - structure containing the force data
%       figForce - handle to the figure of total force coeff 
%       figForce - handle to the figure of residual
%

    % optional inputs
    if nargin < 5  || isempty(plotResidual)
        plotResidual = 0;
    end

    if nargin < 4  || isempty(plotForce)
        plotForce = 0;
    end

    if nargin < 3  || isempty(plotForce)
        spoilerFlag = 0;
    end

    if nargin < 2 || isempty(meanIter)
        meanIter = 1;
    end
    
    % variable initialization
    outputData  = struct;
        outputData.residual   = [];
        outputData.all0       = [];
        outputData.allDx      = [];
        outputData.allDz      = [];
        outputData.lowerBody  = [];
        outputData.upperBody  = [];
        outputData.frontTyre  = [];
        outputData.rearTyre   = [];
        outputData.spoiler    = [];

    % build file paths
    solverInfo_filePath = fullfile(filePath, 'solverInfo', '0', 'solverInfo.dat');
    all0_filePath       = fullfile(filePath, 'all_0',      '0', 'coefficient.dat');
    allDx_filePath      = fullfile(filePath, 'all_dx',     '0', 'coefficient.dat');
    allDz_filePath      = fullfile(filePath, 'all_dz',     '0', 'coefficient.dat');
    lowerBody_filePath  = fullfile(filePath, 'lowerBody',  '0', 'coefficient.dat');
    upperBody_filePath  = fullfile(filePath, 'upperBody',  '0', 'coefficient.dat');
    frontTyre_filePath  = fullfile(filePath, 'frontTyre',  '0', 'coefficient.dat');
    rearTyre_filePath   = fullfile(filePath, 'rearWheel',  '0', 'coefficient.dat');
    spoiler_filePath    = fullfile(filePath, 'spoiler',    '0', 'coefficient.dat');

    % load simulation results
    warning("off")
    [outputData.residual, figResidual] = loadResidual(solverInfo_filePath, meanIter, plotResidual);
    [outputData.all0,     figForce   ] = loadForce(all0_filePath, meanIter, plotForce);
    outputData.allDx      = loadForce(allDx_filePath,     meanIter);
    outputData.allDz      = loadForce(allDz_filePath,     meanIter);
    outputData.lowerBody  = loadForce(lowerBody_filePath, meanIter); 
    outputData.upperBody  = loadForce(upperBody_filePath, meanIter);
    outputData.frontTyre  = loadForce(frontTyre_filePath, meanIter);
    outputData.rearTyre   = loadForce(rearTyre_filePath,  meanIter);
    if spoilerFlag == 1
        outputData.spoiler   = loadForce(spoiler_filePath,  meanIter);
    else
        outputData.spoiler.meanCl  = 0;
        outputData.spoiler.meanCd  = 0;
        outputData.spoiler.meanCm  = 0;
    end
    warning("on")

    
end
