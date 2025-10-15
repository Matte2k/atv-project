function [deltaData] = computeSpoiler(forceBasic, forceSpoiler)
%COMPUTE SPOILER - compute effect of spoiler
%
%   syntax:
%       [deltaData] = computeSpoiler(forceBasic, forceSpoiler)
%
%   input:
%       dragBasic - force struct of the car without spoiler
%       dragSpoiler - force struct of the car with spoiler
%
%   output:
%       deltaData - struct containing delta data
%
%   NOTE:
%       deltas are computed as baseline-spoiler
%       percs are computed as delta/baseline*100
%

    % variable initialization
    deltaData = struct;
        deltaData.dCd = [];
        deltaData.dCl = [];
        deltaData.dCd_perc = [];
        deltaData.dCl_perc = [];

    % compute delta values
    deltaData.dCd      = forceBasic.Cd - forceSpoiler.Cd;
    deltaData.dCl      = forceBasic.Cl - forceSpoiler.Cl;
    deltaData.dCd_perc = deltaData.dCd * 100 / forceBasic.Cd;
    deltaData.dCl_perc = deltaData.dCl * 100 / forceBasic.Cl;

end