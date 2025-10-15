function [rCp] = computeCp(dataStruct, frontArea, wheelBase, r0, flowData)
%COMPUTE CP - compute center of pressure given aerodynamic loads
%   
%   syntax:
%       [rCp] = computeCp(dataStruct, frontArea, wheelBase, r0, flowData)
%
%   input:
%       dataStruct - aerodynamic loads results from cfd
%       frontArea - total car frontal area
%       wheelBase - car wheelbase length in meter
%       r0 - vector where the moment has been computed in cfd
%       flowData - struct containing rho and flow speed
%
%   output:
%       rCp - vector of coordinates of the Cp
%

    % optional inputs
    if nargin < 5 || isempty(flowData)
        flowData.rho = 1.225;
        flowData.U   = 17.5;
    end
    
    if nargin < 4 || isempty(r0)
        r0 = [0,0,0];
    end
    
    if nargin < 3 || isempty(wheelBase)
        wheelBase    = 1.854;
    end
    
    % initialize force cefficient
    Cd = dataStruct.meanCd;
    Cl = dataStruct.meanCl;
    Cm = dataStruct.meanCm;
     
    % compute cfd model reference area
    Aref = frontArea/2;
    
    % compute aerodynamic forces and moment
    L = 0.5 * flowData.rho * flowData.U^2 * Aref * Cl;
    D = 0.5 * flowData.rho * flowData.U^2 * Aref * Cd;
    M = 0.5 * flowData.rho * flowData.U^2 * Aref * Cm * wheelBase;
    
    % organize aerodynamic loads in vectors
    F_vec = [D,0,L];
    M_vec = [0,M,0];
    
    % compute pressure center
    F_norm_sq = dot(F_vec, F_vec);
    if F_norm_sq == 0       % exit with error if no force is present
        error('Force resultant is null. No center of pressure can be computed');
    end
    rCp = r0 + cross(M_vec, F_vec) / F_norm_sq;


end

