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

%% Create a custom dataset with episodes instead of time
% In this example, we'll simulate training data from reinforcement learning
% where we use 'episode' on the x-axis instead of time
dataset = create_episode_dataset();
% The dataset matrix has the following columns:
% Column 1: episode -> Episode numbers
% Column 2: reward   -> Average reward per episode
% Column 3: loss     -> Loss value per episode
% Column 4: epsilon  -> Exploration rate (epsilon) per episode

%% Configure datamap structure
% Note that we use 'xaxis' instead of 'time' to specify our x-axis variable
datamap = struct();
datamap.xaxis = 1;              % Use column 1 (episode) as x-axis
datamap.Reward = {2};           % Plot column 2 (reward) in subplot 1
datamap.Loss = {3};             % Plot column 3 (loss) in subplot 2
datamap.Epsilon = {4};          % Plot column 4 (epsilon) in subplot 3

%% Plot metadata
datamap.meta.lineWidth = 2;     % Use thicker lines for better visibility
datamap.meta.layout = [3, 1];   % 3 rows, 1 column layout

% Configure custom x-axis label
datamap.meta.xlabel.name = 'Training Episode';  % Custom x-axis label

% Set subplot height width
datamap.meta.size.height = 2; 
datamap.meta.size.width = 6;

% y-axis labels for each subplot
datamap.meta.ylabel.Reward = 'Average Reward';
datamap.meta.ylabel.Loss = 'Loss Value';
datamap.meta.ylabel.Epsilon = 'Exploration Rate';

% Configure legend
datamap.meta.legend.Reward = {'Reward'};
datamap.meta.legend.Loss = {'Training Loss'};
datamap.meta.legend.Epsilon = {'Epsilon'};
datamap.meta.legend.location = 'northeast';
datamap.meta.legend.fontSize = 9;

% Set y-axis limits for each subplot
datamap.meta.ylim.Reward = [0, 120];
datamap.meta.ylim.Loss = [0, 1.2];
datamap.meta.ylim.Epsilon = [0, 1.1];

% Set a data tip at episode 80
datamap.meta.datatip = 80;

% Set plot title and save mode
datamap.title = 'RL_Training_Progress';
datamap.meta.mode = 'show';

% Call DasPlotter with the dataset
DasPlotter(datamap, dataset);

%% Helper function to create an episode-based dataset
function dataset = create_episode_dataset()
    % Simulate 100 episodes of training
    num_episodes = 100;
    
    % Generate episode numbers (1 to 100)
    episodes = 1:num_episodes;
    
    % Simulate reward that improves over time with some noise
    base_reward = 20 * (1 - exp(-0.03 * episodes));
    noise = 5 * randn(1, num_episodes);
    reward = base_reward + noise;
    reward = max(0, reward);  % Keep rewards non-negative
    
    % Add a dramatic improvement in the middle
    reward(50:end) = reward(50:end) + 40;
    
    % Simulate loss that decreases over time with some noise
    loss = 1 * exp(-0.02 * episodes) + 0.1 + 0.05 * randn(1, num_episodes);
    loss = max(0.05, loss);  % Keep loss positive
    
    % Add a sudden drop in loss at episode 50
    loss(50:end) = loss(50:end) * 0.7;
    
    % Simulate epsilon (exploration rate) decay
    epsilon = ones(1, num_episodes);
    decay_start = 10;
    decay_end = 80;
    decay_episodes = decay_end - decay_start;
    
    % Linear decay from 1.0 to 0.1
    for i = decay_start:decay_end
        epsilon(i) = 1.0 - (i - decay_start) * 0.9 / decay_episodes;
    end
    
    % Minimum epsilon of 0.1 after decay
    epsilon(decay_end+1:end) = 0.1;
    
    % Combine all data into the dataset matrix
    dataset = [episodes', reward', loss', epsilon'];
end 