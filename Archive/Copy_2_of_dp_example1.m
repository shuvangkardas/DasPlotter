clc; close all; clear all;

addpath('./DasPlotter/'); % Add the library folder to include DasPlotter


%% Prepare a dataset
time = 0:1/20E3:0.1;
f = 60;
w = 2*pi*f;
Vm = 1;   % Voltage amplitude
Im = 2/3; % Current amplitude

%voltage signal
Va = Vm*sin(w*time);
Vb = Vm*sin(w*time-2*pi/3);
Vc = Vm*sin(w*time+2*pi/3);

% current signal
Ia = Im*sin(w*time);
Ib = Im*sin(w*time-2*pi/3);
Ic = Im*sin(w*time+2*pi/3);

%real power 
pa = Va .* Ia; % Instantaneous power for phase a
pb = Vb .* Ib; % Instantaneous power for phase b
pc = Vc .* Ic; % Instantaneous power for phase c
Pgen = pa + pb + pc; % Total instantaneous power

% prepare the dataset
dataset = [time', Va', Vb', Vc', Ia', Ib', Ic', Pgen'];

% Create datamap structure
datamap = struct();
datamap.time = 1;
datamap.Voltage = {2, 3, 4};
datamap.Current = {5, 6, 7};
% datamap.Pgen = {8};
% datamap.meta.mode = 'show';
% datamap.meta.orientation = 'grid';
% datamap.meta.lineWidth = 1;
% datamap.meta.legend.sine = {'Sine Wave'};
% datamap.meta.legend.cosine = {'Cosine Wave'};

% Call DasPlotter
DasPlotter(datamap, dataset);