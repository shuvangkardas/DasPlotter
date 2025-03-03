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

%% Purpose: This example demonstrates using a common x-axis vector across multiple datasets
% The DasPlotter function now supports:
% 1. Direct x-axis vector passed as third parameter (highest priority)
% 2. datamap.xaxis as a column index or vector (medium priority)
% 3. datamap.time as a column index or vector (lowest priority)

%% Create multiple datasets with different structures but a common episode reference
% Create a common episode vector for both datasets
episodes = 1:100;

% First dataset: standard training progress
dataset1 = create_training_dataset(episodes, 'standard');
% Second dataset: improved algorithm with different structure
dataset2 = create_training_dataset(episodes, 'improved');

fprintf('Created two datasets with different internal structures\n');
fprintf('Dataset1: %d rows x %d columns (standard training)\n', size(dataset1, 1), size(dataset1, 2));
fprintf('Dataset2: %d rows x %d columns (improved training)\n', size(dataset2, 1), size(dataset2, 2));

%% Method 1: Using common episode vector as third parameter
fprintf('\n===== Method 1: Using common episode vector as third parameter =====\n');

% Combine datasets into a cell array
datasets = {dataset1, dataset2};

% Configure datamap
datamap1 = struct();
% Note: Different column indices in each dataset for the same metrics
datamap1.Reward = {2, 3};   % Column 2 in dataset1, column 3 in dataset2
datamap1.Loss = {3, 4};     % Column 3 in dataset1, column 4 in dataset2

% Configure metadata
datamap1.meta.lineWidth = 2;
datamap1.meta.legend.useDatasetPrefix = true;
datamap1.meta.legend.datasetNames = {'Standard', 'Improved'};
datamap1.meta.legend.Reward = {'Reward'};
datamap1.meta.legend.Loss = {'Loss'};
datamap1.meta.xlabel.name = 'Training Episode';
datamap1.meta.ylabel.Reward = 'Average Reward';
datamap1.meta.ylabel.Loss = 'Loss Value';
datamap1.meta.title.Reward = 'Reward Comparison';
datamap1.meta.title.Loss = 'Loss Comparison';

% Call DasPlotter with the common episode vector as third parameter
fprintf('Plotting both datasets against the common episode vector\n');
DasPlotter(datamap1, datasets, episodes);

%% Method 2: Using datamap.xaxis as a vector
fprintf('\n===== Method 2: Using datamap.xaxis as a vector =====\n');

% Configure a new datamap
datamap2 = struct();
% Provide the episode vector directly in the datamap
datamap2.xaxis = episodes;
datamap2.Reward = {2, 3};   % Same columns as before
datamap2.Loss = {3, 4};

% Similar metadata configuration 
datamap2.meta.lineWidth = 2;
datamap2.meta.legend.useDatasetPrefix = true;
datamap2.meta.legend.datasetNames = {'Standard', 'Improved'};
datamap2.meta.legend.Reward = {'Reward'};
datamap2.meta.legend.Loss = {'Loss'};
datamap2.meta.xlabel.name = 'Training Episode';
datamap2.meta.ylabel.Reward = 'Average Reward';
datamap2.meta.ylabel.Loss = 'Loss Value';
datamap2.meta.title.Reward = 'Reward Comparison (using datamap.xaxis)';
datamap2.meta.title.Loss = 'Loss Comparison (using datamap.xaxis)';

% Call DasPlotter without third parameter - it will use datamap.xaxis
fprintf('Plotting both datasets using datamap.xaxis vector\n');
DasPlotter(datamap2, datasets);

%% Method 3: Custom third vector that differs from both datasets
fprintf('\n===== Method 3: Custom third vector that differs from original data =====\n');

% Create a custom x-axis with non-integer values (e.g., training hours instead of episodes)
training_hours = episodes * 0.5;  % Each episode takes 0.5 hours

% Configure a new datamap
datamap3 = struct();
datamap3.Reward = {2, 3};   
datamap3.Loss = {3, 4};

% Update metadata to reflect the new x-axis meaning
datamap3.meta.lineWidth = 2;
datamap3.meta.legend.useDatasetPrefix = true;
datamap3.meta.legend.datasetNames = {'Standard', 'Improved'};
datamap3.meta.legend.Reward = {'Reward'};
datamap3.meta.legend.Loss = {'Loss'};
datamap3.meta.xlabel.name = 'Training Time (hours)';
datamap3.meta.ylabel.Reward = 'Average Reward';
datamap3.meta.ylabel.Loss = 'Loss Value';
datamap3.meta.title.Reward = 'Reward vs. Training Time';
datamap3.meta.title.Loss = 'Loss vs. Training Time';

% Call DasPlotter with the training hours vector
fprintf('Plotting both datasets against training hours\n');
DasPlotter(datamap3, datasets, training_hours);

%% Helper function to create training datasets with different structures
function dataset = create_training_dataset(episodes, algorithm_type)
    % Create a dataset that simulates training progress
    num_episodes = length(episodes);
    
    % Initialize the dataset based on algorithm type
    if strcmp(algorithm_type, 'standard')
        % Standard algorithm (3 columns: episode, reward, loss)
        dataset = zeros(num_episodes, 3);
        
        % Column 1: Copy the episode numbers
        dataset(:,1) = episodes';
        
        % Column 2: Rewards that increase with some noise
        base_reward = 20 * (1 - exp(-0.03 * episodes));
        noise = 5 * randn(1, num_episodes);
        dataset(:,2) = base_reward' + noise';
        
        % Column 3: Loss that decreases over time
        dataset(:,3) = 1 * exp(-0.02 * episodes)' + 0.1 + 0.05 * randn(num_episodes, 1);
        
    elseif strcmp(algorithm_type, 'improved')
        % Improved algorithm (5 columns: episode, timestamp, epsilon, reward, loss)
        dataset = zeros(num_episodes, 5);
        
        % Column 1: Episode numbers
        dataset(:,1) = episodes';
        
        % Column 2: Timestamp (in minutes since start)
        dataset(:,2) = (episodes * 5)';  % 5 minutes per episode
        
        % Column 3: Reward (better performance than standard)
        base_reward = 25 * (1 - exp(-0.04 * episodes));
        noise = 4 * randn(1, num_episodes);
        dataset(:,3) = base_reward' + noise';
        
        % Column 4: Loss (faster convergence)
        dataset(:,4) = 0.8 * exp(-0.03 * episodes)' + 0.08 + 0.04 * randn(num_episodes, 1);
        
        % Column 5: Epsilon (exploration rate)
        epsilon = ones(1, num_episodes);
        decay_start = 10;
        decay_end = 70;
        for i = decay_start:decay_end
            epsilon(i) = 1.0 - (i - decay_start) * 0.95 / (decay_end - decay_start);
        end
        epsilon(decay_end+1:end) = 0.05;
        dataset(:,5) = epsilon';
    else
        error('Unknown algorithm type: %s', algorithm_type);
    end
end 