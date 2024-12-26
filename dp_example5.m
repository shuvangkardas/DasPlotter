clc; close all; clear all;

% Add the library folder to include DasPlotter
% If you install it using install.m file, 
% you don't need to add path
addpath('./DasPlotter/'); 

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
datamap.Pgen = {8};

%% Plot metedata
datamap.meta.lineWidth = 1;
datamap.meta.layout = [3 ,1];
datamap.meta.legend.orientation = 'vertical'; 

% set subplot height width
datamap.meta.size.height = 2; 
datamap.meta.size.width = 5

% y axis title for each subplots
datamap.meta.ylabel.Voltage = 'pu';
datamap.meta.ylabel.Current = 'pu';
datamap.meta.ylabel.Pgen = 'pu';

% subplt-wise legend
datamap.meta.legend.Voltage = {'Va', 'Vb', 'Vc'};
datamap.meta.legend.Current = {'Ia', 'Ib', 'Ic'};

%subplot-wise ylimt
datamap.meta.ylim.Voltage = [-2, 2];
datamap.meta.ylim.Current = [-1.5, 1.5];
datamap.meta.ylim.Pgen = [0, 1.5];

%data tip time to print on plot
datamap.meta.datatip = 0.05; 

% 'show' - jut plot | 'save' - plot and save in png
datamap.title = 'AC_Power';
% datamap.meta.mode = 'save';
% Call DasPlotter
DasPlotter(datamap, dataset);