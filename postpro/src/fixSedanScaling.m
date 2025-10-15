function [dataStruct] = fixSedanScaling(dataStruct, coupeArea_m2, sedanArea_m2)
%FIX SEDAN SCALING - fix scaling error on all0, allDx and allDz patches
%
%   syntax:
%
%
%

    scaling = (coupeArea_m2/2) / (sedanArea_m2/2);

    dataStruct.all0.meanCl  = dataStruct.all0.meanCl  * scaling;
    dataStruct.all0.meanCd  = dataStruct.all0.meanCd  * scaling;
    dataStruct.all0.meanCm  = dataStruct.all0.meanCm  * scaling;
    dataStruct.allDx.meanCl = dataStruct.allDx.meanCl * scaling;
    dataStruct.allDx.meanCd = dataStruct.allDx.meanCd * scaling;
    dataStruct.allDx.meanCm = dataStruct.allDx.meanCm * scaling;
    dataStruct.allDz.meanCl = dataStruct.allDz.meanCl * scaling;
    dataStruct.allDz.meanCd = dataStruct.allDz.meanCd * scaling;
    dataStruct.allDz.meanCm = dataStruct.allDz.meanCm * scaling;


end