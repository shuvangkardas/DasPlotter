% Library Name: DasPlotter
% Author: Shuvangkar Das
% LinkedIn: https://www.linkedin.com/in/shuvangkardas
% Year: 2024
% Description:  library for creating customizable,
% publication-quality plots from time-series datasets

clc; close all; clear all;

% Add the library folder to include DasPlotter
% If you install it using install.m file, 
% you don't need to add path
% addpath('./DasPlotter/'); 

%% Create first dataset (normal load condition)
dataset1 = create_dataset1();
% The dataset matrix has the following columns:
% Column 1: time  -> Time values
% Column 2: Va    -> Phase A voltage
% Column 3: Vb    -> Phase B voltage
% Column 4: Vc    -> Phase C voltage
% Column 5: Ia    -> Phase A current
% Column 6: Ib    -> Phase B current
% Column 7: Ic    -> Phase C current
% Column 8: Pgen  -> Generated power

%% Create second dataset (faulty condition)
dataset2 = create_dataset2();
% The dataset2 matrix has the same structure as dataset1
% but with different values to simulate a fault condition

%% Create a cell array of datasets to pass to DasPlotter
datasets = {dataset1, dataset2};

%% Configure datamap structure
% datamap structure maps out the dataset matrix in 
% a structure format. 
% remember to put 'time' element in the structure
datamap = struct();
datamap.time = 1;
datamap.Voltage = {2, 3, 4};
datamap.Current = {5, 6, 7};
datamap.Pgen = {8};

%% Plot metadata
datamap.meta.lineWidth = 1.5;
datamap.meta.layout = [3, 1];

% Set subplot height width
datamap.meta.size.height = 2.5; 
datamap.meta.size.width = 6;

% y axis title for each subplots
datamap.meta.ylabel.Voltage = 'Voltage (pu)';
datamap.meta.ylabel.Current = 'Current (pu)';
datamap.meta.ylabel.Pgen = 'Power (pu)';

%% Legend configuration
% Legend content - OPTION 1: Explicit entries for each dataset
datamap.meta.legend.Voltage = {'Normal Va', 'Normal Vb', 'Normal Vc', 'Fault Va', 'Fault Vb', 'Fault Vc'};
datamap.meta.legend.Current = {'Normal Ia', 'Normal Ib', 'Normal Ic', 'Fault Ia', 'Fault Ib', 'Fault Ic'};
datamap.meta.legend.Pgen = {'Normal Power', 'Fault Power'};

% Legend content - OPTION 2: Using dataset prefixes (commented out)
% % Define variable names (without dataset prefix)
% datamap.meta.legend.Voltage = {'Va', 'Vb', 'Vc'};
% datamap.meta.legend.Current = {'Ia', 'Ib', 'Ic'};
% datamap.meta.legend.Pgen = {'Power'};
% % Enable dataset prefixes and define dataset names
% datamap.meta.legend.useDatasetPrefix = true;
% datamap.meta.legend.datasetNames = {'Normal', 'Fault'};

% Legend appearance
datamap.meta.legend.orientation = 'vertical';     % 'horizontal' or 'vertical'
datamap.meta.legend.location = 'eastoutside';     % 'northeast', 'southwest', 'eastoutside', etc.
datamap.meta.legend.fontSize = 9;                 % Legend font size

% Subplot-wise ylimit
datamap.meta.ylim.Voltage = [-2, 2];
datamap.meta.ylim.Current = [-2, 2];
datamap.meta.ylim.Pgen = [0, 2];

% Data tip time to print on plot
datamap.meta.datatip = 0.05; 

% Set plot title and save mode
datamap.title = 'Normal_vs_Fault_Condition';
datamap.meta.mode = 'save';

% Call DasPlotter with both datasets
DasPlotter(datamap, datasets);

%% Helper function to create first dataset (normal condition)
function dataset = create_dataset1()
    %% Prepare a dataset
    time = 0:1/20E3:0.1;
    f = 60;
    w = 2*pi*f;
    Vm = 1;      % Voltage amplitude
    Im = 2/3;    % Current amplitude

    % Voltage signal
    Va = Vm*sin(w*time);
    Vb = Vm*sin(w*time-2*pi/3);
    Vc = Vm*sin(w*time+2*pi/3);

    % Current signal
    Ia = Im*sin(w*time);
    Ib = Im*sin(w*time-2*pi/3);
    Ic = Im*sin(w*time+2*pi/3);

    % Real power 
    pa = Va .* Ia; % Instantaneous power for phase a
    pb = Vb .* Ib; % Instantaneous power for phase b
    pc = Vc .* Ic; % Instantaneous power for phase c
    Pgen = pa + pb + pc; % Total instantaneous power

    % Create dataset array
    dataset = [time', Va', Vb', Vc', Ia', Ib', Ic', Pgen'];
end

%% Helper function to create second dataset (fault condition)
function dataset = create_dataset2()
    %% Prepare a dataset
    time = 0:1/20E3:0.1;
    f = 60;
    w = 2*pi*f;
    Vm = 1;      % Voltage amplitude
    Im = 1.2;    % Higher current amplitude during fault (1.8x normal)
    
    % Add a fault at 0.04s 
    fault_start = 0.04;
    fault_duration = 0.02;
    fault_idx = (time >= fault_start) & (time < (fault_start + fault_duration));
    
    % Voltage signal
    Va = Vm*sin(w*time);
    Vb = Vm*sin(w*time-2*pi/3);
    Vc = Vm*sin(w*time+2*pi/3);
    
    % Apply voltage sag on phase A during fault
    Va(fault_idx) = 0.6 * Va(fault_idx);
    
    % Current signals with increased magnitude during fault
    Ia = Im*sin(w*time);
    Ib = Im*sin(w*time-2*pi/3);
    Ic = Im*sin(w*time+2*pi/3);
    
    % Increase current in phase A during fault
    Ia(fault_idx) = 1.5 * Ia(fault_idx);
    
    % Real power 
    pa = Va .* Ia; % Instantaneous power for phase a
    pb = Vb .* Ib; % Instantaneous power for phase b
    pc = Vc .* Ic; % Instantaneous power for phase c
    Pgen = pa + pb + pc; % Total instantaneous power
    
    % Create dataset array
    dataset = [time', Va', Vb', Vc', Ia', Ib', Ic', Pgen'];
end 