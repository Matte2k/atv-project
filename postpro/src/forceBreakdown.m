function [forceData] = forceBreakdown(outputData)
%FORCE BREAKDOWN - compute lift, drag and momentum percentage of the different patches 
%
%   syntax:
%       [forceData] = forceBreakdown(outputData)
%
%   input:
%       outputData - structure containing the force data
%
%   output:
%       forceData - structure summerazing different patches force contribute
%

    forceData = struct;
        forceData.lowerBody   = initPart;
        forceData.upperBody   = initPart;
        forceData.spoiler     = initPart;
        forceData.frontTyre   = initPart;
        forceData.rearTyre    = initPart;
        forceData.totalBody   = initPart;
        forceData.totalTyre   = initPart;
        forceData.overall_rel = initPart;
        forceData.overall_abs = initPart;


    forceData.lowerBody.Cl = outputData.lowerBody.meanCl;
    forceData.lowerBody.Cd = outputData.lowerBody.meanCd;
    forceData.lowerBody.Cm = outputData.lowerBody.meanCm;

    forceData.upperBody.Cl = outputData.upperBody.meanCl;
    forceData.upperBody.Cd = outputData.upperBody.meanCd;
    forceData.upperBody.Cm = outputData.upperBody.meanCm;

    forceData.spoiler.Cl = outputData.spoiler.meanCl;
    forceData.spoiler.Cd = outputData.spoiler.meanCd;
    forceData.spoiler.Cm = outputData.spoiler.meanCm;

    forceData.frontTyre.Cl = outputData.frontTyre.meanCl;
    forceData.frontTyre.Cd = outputData.frontTyre.meanCd;
    forceData.frontTyre.Cm = outputData.frontTyre.meanCm;

    forceData.rearTyre.Cl = outputData.rearTyre.meanCl;
    forceData.rearTyre.Cd = outputData.rearTyre.meanCd;
    forceData.rearTyre.Cm = outputData.rearTyre.meanCm;

    forceData.totalBody.Cl = forceData.lowerBody.Cl + forceData.upperBody.Cl + forceData.spoiler.Cl;
    forceData.totalBody.Cd = forceData.lowerBody.Cd + forceData.upperBody.Cd + forceData.spoiler.Cd;
    forceData.totalBody.Cm = forceData.lowerBody.Cm + forceData.upperBody.Cm + forceData.spoiler.Cm;

    forceData.totalTyre.Cl = forceData.frontTyre.Cl + forceData.rearTyre.Cl;
    forceData.totalTyre.Cd = forceData.frontTyre.Cd + forceData.rearTyre.Cd;
    forceData.totalTyre.Cm = forceData.frontTyre.Cm + forceData.rearTyre.Cm;

    forceData.overall_rel.Cl = forceData.totalBody.Cl + forceData.totalTyre.Cl;
    forceData.overall_rel.Cd = forceData.totalBody.Cd + forceData.totalTyre.Cd;
    forceData.overall_rel.Cm = forceData.totalBody.Cm + forceData.totalTyre.Cm;

    forceData.overall_abs.Cl = abs(forceData.lowerBody.Cl) + abs(forceData.upperBody.Cl) + abs(forceData.spoiler.Cl) + abs(forceData.frontTyre.Cl) + abs(forceData.rearTyre.Cl); 
    forceData.overall_abs.Cd = abs(forceData.lowerBody.Cd) + abs(forceData.upperBody.Cd) + abs(forceData.spoiler.Cd) + abs(forceData.frontTyre.Cd) + abs(forceData.rearTyre.Cd);
    forceData.overall_abs.Cm = abs(forceData.lowerBody.Cm) + abs(forceData.upperBody.Cm) + abs(forceData.spoiler.Cm) + abs(forceData.frontTyre.Cm) + abs(forceData.rearTyre.Cm);

    % compute different percentage
    forceData.lowerBody = computePerc(forceData.lowerBody, forceData.overall_abs, forceData.overall_rel);
    forceData.upperBody = computePerc(forceData.upperBody, forceData.overall_abs, forceData.overall_rel);
    forceData.spoiler   = computePerc(forceData.spoiler  , forceData.overall_abs, forceData.overall_rel);
    forceData.frontTyre = computePerc(forceData.frontTyre, forceData.overall_abs, forceData.overall_rel);
    forceData.rearTyre  = computePerc(forceData.rearTyre , forceData.overall_abs, forceData.overall_rel);
    forceData.totalBody = computePerc(forceData.totalBody, forceData.overall_abs, forceData.overall_rel);
    forceData.totalTyre = computePerc(forceData.totalTyre, forceData.overall_abs, forceData.overall_rel);

end



function [partStruct] = initPart()
%INIT PART - initialize part field of the force struct
%

    partStruct = struct;
        partStruct.Cl = [];
        partStruct.Cd = [];
        partStruct.Cm = [];
        partStruct.Cl_absPerc = [];
        partStruct.Cd_absPerc = [];
        partStruct.Cm_absPerc = [];
        partStruct.Cl_relPerc = [];
        partStruct.Cd_relPerc = [];
        partStruct.Cm_relPerc = [];

end



function [part] = computePerc(part, total_abs, total_rel)
% COMPUTE PERCETAGE - compute lift, drag and momentum percetage
%

   part.Cl_absPerc = abs(part.Cl) / total_abs.Cl * 100; 
   part.Cd_absPerc = abs(part.Cd) / total_abs.Cd * 100;
   part.Cm_absPerc = abs(part.Cm) / total_abs.Cm * 100; 

   part.Cl_relPerc = (part.Cl) / total_rel.Cl * 100; 
   part.Cd_relPerc = (part.Cd) / total_rel.Cd * 100;
   part.Cm_relPerc = (part.Cm) / total_rel.Cm * 100; 
end