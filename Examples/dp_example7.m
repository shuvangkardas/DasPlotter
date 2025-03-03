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

%% Example 7: Simple Example with Custom Episode Vector

% Create a common episode vector for both datasets (1 to 100)
episodes = 1:100;

% Create two datasets with the same column structure
dataset1 = create_algorithm_dataset('Algorithm A');
dataset2 = create_algorithm_dataset('Algorithm B');

% Combine datasets into a cell array for plotting
datasets = {dataset1, dataset2};

% Define datamap structure for plotting
datamap = struct();

% Configure which columns to plot
datamap.Reward = {2, 2}; % Column 2 in both datasets
datamap.Loss = {3, 3};   % Column 3 in both datasets

% Configure metadata for plotting
datamap.meta.lineWidth = 2;
datamap.meta.layout = [2, 1]; % 2 rows, 1 column
datamap.meta.legend.orientation = 'horizontal';
datamap.meta.legend.useDatasetPrefix = true;
datamap.meta.legend.datasetNames = {'Algorithm A', 'Algorithm B'};

% Define axis labels and titles
datamap.meta.xlabel.name = 'Training Episode';
datamap.meta.ylabel.Reward = 'Reward Value';
datamap.meta.ylabel.Loss = 'Loss Value';

% Configure legend for each subplot
datamap.meta.legend.Reward = {'Reward'};
datamap.meta.legend.Loss = {'Loss'};

% Set subplot y-axis limits
datamap.meta.ylim.Reward = [0, 110];
datamap.meta.ylim.Loss = [0, 1.1];

% Add a data tip to highlight a particular episode
datamap.meta.datatip = 75;

% Set plot title and mode
datamap.title = 'Training Progress Comparison';
datamap.meta.mode = 'show';

% Call DasPlotter with episodes as the third parameter
DasPlotter(datamap, datasets, episodes);

%% Helper function to create dataset
function dataset = create_algorithm_dataset(algorithm_type)
    % Create a dataset with 100 rows and 3 columns:
    % Column 1: Episode number
    % Column 2: Reward values 
    % Column 3: Loss values
    
    % Initialize empty dataset
    dataset = zeros(100, 3);
    
    % Column 1: Episode numbers (1 to 100)
    dataset(:, 1) = 1:100;
    
    % Generate different patterns based on algorithm type
    if strcmp(algorithm_type, 'Algorithm A')
        % Column 2: Reward (linear growth with noise)
        dataset(:, 2) = linspace(20, 90, 100) + 5*randn(1, 100);
        
        % Column 3: Loss (exponential decay with noise)
        dataset(:, 3) = exp(-linspace(0, 3, 100)) + 0.1*randn(1, 100);
    else % Algorithm B
        % Column 2: Reward (faster initial growth, then plateau)
        dataset(:, 2) = 100 ./ (1 + exp(-0.1 * (dataset(:, 1) - 50)')) + 3*randn(1, 100);
        
        % Column 3: Loss (faster decay)
        dataset(:, 3) = 0.8 * exp(-linspace(0, 4, 100)) + 0.05*randn(1, 100);
    end
    
    % Ensure rewards stay positive
    dataset(:, 2) = max(dataset(:, 2), 0);
    
    % Ensure loss values stay positive
    dataset(:, 3) = max(dataset(:, 3), 0);
end 