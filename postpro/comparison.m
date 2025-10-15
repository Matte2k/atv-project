clearvars; close all; clc;
load("data/dataCFD.mat");
addpath("src/");
cmap = graphicSettings;


%------------------------
%% INPUT

% plot result of the simulation over time
plotFlag.sedan_basic   = 0;
plotFlag.sedan_spoiler = 0;
plotFlag.coupe_basic   = 0;
plotFlag.coupe_spoiler = 0;

% save final plot of the convergence studies
writeFlag.sedan_basic   = 1;
writeFlag.coupe_basic   = 1;
writeFlag.sedan_spoiler = 1;
writeFlag.coupe_spoiler = 1;


%------------------------
%% LOAD DATA

% basic configuration of sedan chassis
sedan_basic = struct;
    sedan_basic.path  = "data/grid/sedan_3_4";
    sedan_basic.elem  = 600;
    sedan_basic.roof  = 0;
    sedan_basic.data  = loadOutput(sedan_basic.path, sedan_basic.elem, sedan_basic.roof, plotFlag.sedan_basic);             % to be rescaled
    sedan_basic.data  = fixSedanScaling(sedan_basic.data, coupeArea_m2, sedanArea_m2);
    sedan_basic.force = forceBreakdown(sedan_basic.data);
    sedan_basic.force = dragContributes("data/spoiler/drag_breakdown/sedan_basic", sedan_basic.force, sedan_basic.elem);    % to be rescaled

if writeFlag.sedan_basic == 1
    dragLatexTable(sedan_basic.force, 'sedan_basic.txt');
end


% basic configuration of coupe chassis
coupe_basic = struct;
    coupe_basic.path  = "data/grid/coupe_3_4";
    coupe_basic.elem  = 500;
    coupe_basic.roof  = 0;
    coupe_basic.data  = loadOutput(coupe_basic.path, coupe_basic.elem, coupe_basic.roof, plotFlag.coupe_basic);
    coupe_basic.force = forceBreakdown(coupe_basic.data);
    coupe_basic.force = dragContributes("data/spoiler/drag_breakdown/coupe_basic", coupe_basic.force, coupe_basic.elem);

if writeFlag.coupe_basic == 1
    dragLatexTable(coupe_basic.force, 'coupe_basic.txt');
end


% roof spoiler configuration of sedan chassis
sedan_spoiler = struct;
    sedan_spoiler.path  = "data/spoiler/sedan_3_4";
    sedan_spoiler.elem  = 500;
    sedan_spoiler.roof  = 1;
    sedan_spoiler.data  = loadOutput(sedan_spoiler.path, sedan_spoiler.elem, sedan_spoiler.roof, plotFlag.sedan_spoiler);
    sedan_spoiler.data  = fixSedanScaling(sedan_spoiler.data, coupeArea_m2, sedanArea_m2);
    sedan_spoiler.force = forceBreakdown(sedan_spoiler.data);
    sedan_spoiler.force = dragContributes("data/spoiler/drag_breakdown/sedan_spoiler", sedan_spoiler.force, sedan_spoiler.elem);

if writeFlag.sedan_spoiler == 1
    dragLatexTable(sedan_spoiler.force, 'sedan_spoiler.txt');
end


% roof spoiler configuration of coupe chassis
coupe_spoiler = struct;
    coupe_spoiler.path  = "data/spoiler/coupe_3_4";
    coupe_spoiler.elem  = 500;
    coupe_spoiler.roof  = 1;
    coupe_spoiler.data  = loadOutput(coupe_spoiler.path, coupe_spoiler.elem, coupe_spoiler.roof, plotFlag.coupe_spoiler);
    coupe_spoiler.force = forceBreakdown(coupe_spoiler.data);
    coupe_spoiler.force = dragContributes("data/spoiler/drag_breakdown/coupe_spoiler", coupe_spoiler.force, coupe_spoiler.elem);

if writeFlag.coupe_spoiler == 1
    dragLatexTable(coupe_spoiler.force, 'coupe_spoiler.txt');
end


%------------------------
%% COMPUTE RESULTS

% Impact of the roof spoiler on aerodynamic loads
spoiler_delta = struct;
    spoiler_delta.sedan = computeSpoiler(sedan_basic.force.overall_rel, sedan_spoiler.force.overall_rel);
    spoiler_delta.coupe = computeSpoiler(coupe_basic.force.overall_rel, coupe_spoiler.force.overall_rel);


% Position of the center of pressure in the different configuration
Cp_position = struct;
    Cp_position.sedan_basic   = computeCp(sedan_basic.data.all0, sedanArea_m2);
    Cp_position.coupe_basic   = computeCp(coupe_basic.data.all0, coupeArea_m2);
    Cp_position.sedan_spoiler = computeCp(sedan_spoiler.data.all0, sedanArea_m2);
    Cp_position.coupe_spoiler = computeCp(coupe_spoiler.data.all0, coupeArea_m2);



