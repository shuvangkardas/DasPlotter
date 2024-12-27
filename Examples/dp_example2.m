% Library Name: DasPlotter
% Author: Shuvangkar Das
% LinkedIn: https://www.linkedin.com/in/shuvangkardas
% Year: 2024
% Description:  library for creating customizable,
% publication-quality plots from time-series datasets

clc; close all; clear all;

% Add the library folder to include DasPlotter
% if you not prefer installing dasplotter
% addpath('./DasPlotter/'); 

dataset = create_dataset();
% The dataset matrix has the following columns:
% Column 1: time  -> Time values
% Column 2: Va    -> Phase A voltage
% Column 3: Vb    -> Phase B voltage
% Column 4: Vc    -> Phase C voltage
% Column 5: Ia    -> Phase A current
% Column 6: Ib    -> Phase B current
% Column 7: Ic    -> Phase C current
% Column 8: Pgen  -> Generated power


% datamap strucute maps out the dataset matrix in 
% a structure format. 
% remember to put 'time' element in the strucute
datamap = struct();
datamap.time = 1;
datamap.Voltage = {2, 3, 4};
datamap.Current = {5, 6, 7};

% Plot metedata
datamap.meta.lineWidth = 1;
datamap.meta.legend.Voltage = {'Va', 'Vb', 'Vc'};
datamap.meta.legend.Current = {'Ia', 'Ib', 'Ic'};

% Call DasPlotter
DasPlotter(datamap, dataset);