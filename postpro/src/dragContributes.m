function [forceData] = dragContributes(folderPath, forceData, meanIter)
%DRAG CONTRIBUTES - load parsed drag component
%
%   syntax:
%       [forceData] = dragContributes(folderPath, forceData, meanIter)   
%
%   input:
%       folderPath - path to the folder with different components data
%       forceData  - struct in output from forceBreakdown.m
%       meanIter - number of iterations to average over
%
%   output:
%       forceData - structure containing the force data + drag components
%

    % optional inputs
    if nargin < 3 || isempty(meanIter)
        meanIter = 1;
    end
    
    
    % save drag contributes for base fields
    warning("off");
    [forceData.lowerBody.Cd_visc,   forceData.lowerBody.Cd_pres,   forceData.lowerBody.Cd_tot] ...
        = readComponent(folderPath, 'lowerBody.dat', meanIter);
    [forceData.upperBody.Cd_visc,   forceData.upperBody.Cd_pres,   forceData.upperBody.Cd_tot] ...
        = readComponent(folderPath, 'upperBody.dat', meanIter);
    [forceData.spoiler.Cd_visc,     forceData.spoiler.Cd_pres,     forceData.spoiler.Cd_tot] ...
        = readComponent(folderPath, 'spoiler.dat',   meanIter);
    [forceData.frontTyre.Cd_visc,   forceData.frontTyre.Cd_pres,   forceData.frontTyre.Cd_tot] ...
        = readComponent(folderPath, 'frontTyre.dat', meanIter);
    [forceData.rearTyre.Cd_visc,    forceData.rearTyre.Cd_pres,    forceData.rearTyre.Cd_tot] ...
        = readComponent(folderPath, 'rearWheel.dat',  meanIter);
    warning("on");

    % compute drag contributes for composite fields
    forceData.totalTyre.Cd_visc = forceData.frontTyre.Cd_visc + forceData.rearTyre.Cd_visc;
    forceData.totalTyre.Cd_pres = forceData.frontTyre.Cd_pres + forceData.rearTyre.Cd_pres;
    forceData.totalTyre.Cd_tot  = forceData.frontTyre.Cd_tot  + forceData.rearTyre.Cd_tot; 

    forceData.totalBody.Cd_visc = forceData.upperBody.Cd_visc + forceData.lowerBody.Cd_visc + forceData.spoiler.Cd_visc;
    forceData.totalBody.Cd_pres = forceData.upperBody.Cd_pres + forceData.lowerBody.Cd_pres + forceData.spoiler.Cd_pres;
    forceData.totalBody.Cd_tot  = forceData.upperBody.Cd_tot  + forceData.lowerBody.Cd_tot  + forceData.spoiler.Cd_tot; 

    forceData.overall_rel.Cd_visc = forceData.totalTyre.Cd_visc + forceData.totalBody.Cd_visc;
    forceData.overall_rel.Cd_pres = forceData.totalTyre.Cd_pres + forceData.totalBody.Cd_pres;
    forceData.overall_rel.Cd_tot  = forceData.totalTyre.Cd_tot  + forceData.totalBody.Cd_tot ;

    forceData.overall_abs.Cd_visc =  abs(forceData.upperBody.Cd_visc) + abs(forceData.lowerBody.Cd_visc) + abs(forceData.spoiler.Cd_visc) + abs(forceData.frontTyre.Cd_visc) + abs(forceData.rearTyre.Cd_visc);
    forceData.overall_abs.Cd_pres =  abs(forceData.upperBody.Cd_pres) + abs(forceData.lowerBody.Cd_pres) + abs(forceData.spoiler.Cd_pres) + abs(forceData.frontTyre.Cd_pres) + abs(forceData.rearTyre.Cd_pres);
    forceData.overall_abs.Cd_tot  =  abs(forceData.upperBody.Cd_tot ) + abs(forceData.lowerBody.Cd_tot ) + abs(forceData.spoiler.Cd_tot ) + abs(forceData.frontTyre.Cd_tot ) + abs(forceData.rearTyre.Cd_tot);


end



function [Cd_visc, Cd_pres, Cd_tot] = readComponent(folderPath, patchName, meanIter)

    % build target file path
    filePath = fullfile(folderPath,patchName);

    % read the data
    dragTable = readtable(filePath, Delimiter='\t');

    % read iteration number data
    totIter  = length(dragTable.Time);

    Cd_visc = mean(dragTable.CdViscous(totIter-meanIter:end));
    Cd_pres = mean(dragTable.CdPressure(totIter-meanIter:end));
    Cd_tot  = mean(dragTable.CdTotal(totIter-meanIter:end));

end