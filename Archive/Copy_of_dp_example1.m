clc; close all; clear all;

addpath('./DasPlotter/'); % Add the library folder to include DasPlotter


%% 1. Define Parameters

% Angular frequency (rad/s)
f = 50;                % Frequency in Hz (e.g., 50 Hz)
w = 2*pi*f;            % Angular frequency

% Phase angle difference between voltage and current (degrees)
phi_deg = 0;           % Change this value as needed
phi = deg2rad(phi_deg);% Convert phase angle to radians

% Voltage and Current Amplitudes (peak values)
Vm = 1;                % Voltage amplitude
Im = 1;                % Current amplitude

%% 2. Create Time Vector

T = 1/f;               % Period of the waveform
t = linspace(0, 2*T, 1000); % Time vector spanning two periods

%% 3. Define Voltage and Current Waveforms

% Voltages for three phases (a, b, c)
Va = Vm * sin(w*t);
Vb = Vm * sin(w*t - 2*pi/3);
Vc = Vm * sin(w*t + 2*pi/3);

% Currents for three phases with phase difference phi
Ia = Im * sin(w*t - phi);
Ib = Im * sin(w*t - 2*pi/3 - phi);
Ic = Im * sin(w*t + 2*pi/3 - phi);

%% 4. Calculate Instantaneous Power for Each Phase

pa = Va .* Ia; % Instantaneous power for phase a
pb = Vb .* Ib; % Instantaneous power for phase b
pc = Vc .* Ic; % Instantaneous power for phase c

%% 5. Calculate Total Instantaneous Power

pt = pa + pb + pc; % Total instantaneous power

%% 6. Calculate Real and Reactive Power

% Real Power (Average Power)
P = mean(pt);

% Reactive Power
% For sinusoidal balanced three-phase systems:
% Q = (3/2) * Vm * Im * sin(phi)
Q = (3/2) * Vm * Im * sin(phi)

dataset = [t', Va', Vb', Vc', Ia', Ib', Ic', pt'];

% Create datamap structure
datamap = struct();
datamap.time = 1;
datamap.Voltage = {2, 3, 4};
datamap.Current = {5, 6, 7};
datamap.Pgen = {8};
% datamap.meta.mode = 'show';
% datamap.meta.orientation = 'grid';
% datamap.meta.lineWidth = 1;
% datamap.meta.legend.sine = {'Sine Wave'};
% datamap.meta.legend.cosine = {'Cosine Wave'};

% Call DasPlotter
DasPlotter(datamap, dataset);