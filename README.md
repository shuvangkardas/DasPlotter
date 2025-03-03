# DasPlotter

DasPlotter is a MATLAB library for creating customizable, publication-quality plots from time-series datasets. It provides a flexible and intuitive interface for generating single or multiple subplots with various configuration options.

## Example Use Cases

1. **Generate Multiple Plots**: Provide a datamap and use `DasPlotter` to quickly create multiple plots with different combinations from your time series data.  
2. **Compare Datasets**: Pass two datasets from different experiments into `DasPlotter` to compare them visually.  
3. **Optimize Simulink Speed**: Comment out scopes in Simulink, log data to the workspace, and configure `DasPlotter` to generate plots after simulation.  
4. **Publication-Quality Figures**: Easily create and save high-quality figures as PNG files directly from experiment datasets.  
5. **And More**: Extend `DasPlotter` for various custom plotting needs.  


## Features

- Support for single and multiple subplot layouts
- Automatic or manual layout configuration
- Customizable plot appearance (line width, colors, titles, legends)
- Data point annotation capabilities
- Flexible output modes (display or save)
- Automatic grid layout optimization
- Support for multiple datasets with comprehensive legend control
- High-quality figure export with minimal whitespace
- Custom x-axis variable support (not limited to time)
- Common x-axis vector support across multiple datasets

## Project Structure

```
DasPlotter
│   README.md
│   install.m
│   uninstall.m
├───DasPlotter
│       DasPlotter.m
└───Examples
        create_dataset.m
        dp_example1.m
        dp_example2.m
        dp_example3.m
        dp_example4.m
        dp_example5.m
        dp_example6.m
        dp_example7.m
        
```

## Installation

There are two ways to install DasPlotter:

### Option 1: Using the Installation Script (Recommended)

1. Clone/download this repository:
```bash
git clone https://github.com/yourusername/DasPlotter.git
```

2. Run the installation script:
```matlab
run('install.m')
```

### Option 2: Manual Installation

1. Clone/download this repository
2. Add the DasPlotter folder to your MATLAB path:
```matlab
addpath('./DasPlotter/');
```

Note: If you use the installation script (Option 1), you don't need to manually add the path in your script everytime you are generating figures.

## Quick Start
1. Install the library 
2. Run the examples script from example folder
3. Follow the tutorial presented below for details


Here's a basic example to get you started:

```matlab
% Clear workspace and add DasPlotter to path
clc; close all; clear all;
addpath('./DasPlotter/');

% Create or load your dataset
dataset = create_dataset();

% Configure your datamap structure
datamap = struct();
datamap.time = 1;                % Specify time column
datamap.Voltage = {2, 3, 4};     % Plot columns 2,3,4 in one subplot
datamap.Current = {5, 6, 7};     % Plot columns 5,6,7 in another subplot

% Generate plots
DasPlotter(datamap, dataset);
```

### Example with Metadata Configuration

Here's an example showing how to customize the plot appearance using metadata:

```matlab
% Basic structure setup
datamap = struct();
datamap.time = 1;
datamap.Voltage = {2, 3, 4};
datamap.Current = {5, 6, 7};

% Configure plot metadata
datamap.meta.lineWidth = 1;                          % Set line width
datamap.meta.legend.Voltage = {'Va', 'Vb', 'Vc'};   % Labels for voltage traces
datamap.meta.legend.Current = {'Ia', 'Ib', 'Ic'};   % Labels for current traces

% Generate customized plots
DasPlotter(datamap, dataset);
```

## Dataset Format

The dataset should be a matrix or cell array where:
- Each row represents a time point
- Each column represents a different variable
- The first column is typically the time vector (or another independent variable)

Example dataset structure:
```
Column 1: time  - Time values
Column 2: Va    - Phase A voltage
Column 3: Vb    - Phase B voltage
Column 4: Vc    - Phase C voltage
Column 5: Ia    - Phase A current
Column 6: Ib    - Phase B current
Column 7: Ic    - Phase C current
Column 8: Pgen  - Generated power
```

## Configuration Options

The `datamap` structure supports extensive configuration through the `meta` field:

```matlab
datamap.meta = struct();
% Basic Display Options
datamap.meta.mode = 'show';          % 'show' or 'save'
datamap.meta.orientation = 'grid';    % 'grid' or 'vertical'
datamap.meta.lineWidth = 1;          % Line width for plots
datamap.meta.layout = [2, 2];        % Manual layout specification [rows, cols]

% Figure Size Control
datamap.meta.size.height = 2;        % Subplot height in inches
datamap.meta.size.width = 5;         % Subplot width in inches

% Axis Configuration
datamap.meta.ylim = struct();        % Y-axis limits per subplot
datamap.meta.ylabel = struct();      % Y-axis labels per subplot
datamap.meta.xlabel.name = 'Time';   % Custom x-axis label

% Legend Options
datamap.meta.legend = struct();      % Legend labels per subplot
datamap.meta.legend.orientation = 'vertical';  % Legend orientation
datamap.meta.legend.location = 'northeast';    % Legend position
datamap.meta.legend.fontSize = 9;             % Legend font size

% Data Annotation
datamap.meta.datatip = 0.05;         % Time point for data annotation

% Title Configuration
datamap.meta.title = struct();       % Title configuration
```

### Customizing Axis Labels and Units

```matlab
% Set y-axis labels (e.g., for units)
datamap.meta.ylabel.Voltage = 'pu';
datamap.meta.ylabel.Current = 'pu';
datamap.meta.ylabel.Pgen = 'pu';

% Set custom x-axis label
datamap.meta.xlabel.name = 'Time (seconds)';

% Set y-axis limits per subplot
datamap.meta.ylim.Voltage = [-2, 2];
datamap.meta.ylim.Current = [-1.5, 1.5];
datamap.meta.ylim.Pgen = [0, 1.5];
```

### Figure Size and Layout

```matlab
% Control subplot dimensions
datamap.meta.size.height = 2;    % Height in inches
datamap.meta.size.width = 5;     % Width in inches

% Specify subplot arrangement
datamap.meta.layout = [3, 1];    % 3 rows, 1 column
```

### Data Annotations

The `datatip` feature allows you to mark and annotate specific time points:

```matlab
% Add value annotations at t=0.05
datamap.meta.datatip = 0.05;  % Time point to annotate

% This will:
% 1. Add markers at the specified time
% 2. Display numerical values
% 3. Use consistent colors with plot lines
```

### Custom X-Axis Variable

You can use any column as the x-axis variable, not just time:

```matlab
% Use 'episode' as the x-axis instead of time
datamap.xaxis = 1;                          % Column with episode numbers
datamap.meta.xlabel.name = 'Episode';       % Custom x-axis label

% Plot data against the custom x-axis
datamap.Reward = {2};                       % Plot column 2 vs. episode
datamap.Loss = {3};                         % Plot column 3 vs. episode

% This is ideal for:
% - Reinforcement learning training progress
% - Iteration-based algorithms
% - Epoch-based training data
% - Any non-time independent variable
```

### Common X-Axis Vector

You can use a common x-axis vector across multiple datasets with different structures:

```matlab
% Create a common x-axis vector
episodes = 1:100;

% Set up datasets with different structures
datasets = {dataset1, dataset2};  % Cell array of different datasets

% Method 1: Pass the vector as third parameter (highest priority)
DasPlotter(datamap, datasets, episodes);

% Method 2: Include the vector in datamap.xaxis
datamap.xaxis = episodes;  % Direct vector instead of column index
DasPlotter(datamap, datasets);

% Method 3: Use a derived vector (e.g., convert episodes to hours)
training_hours = episodes * 0.5;  % Each episode takes 0.5 hours
datamap.meta.xlabel.name = 'Training Time (hours)';
DasPlotter(datamap, datasets, training_hours);
```

This approach is especially powerful for:
- Comparing results from different runs with the same x-reference
- Aligning datasets with different internal structures
- Converting between different units (e.g., episodes to time)
- Applying custom transformations to the x-axis

### Legend Configuration

For single dataset:
```matlab
% Basic legend labels
datamap.meta.legend.Voltage = {'Va', 'Vb', 'Vc'};
datamap.meta.legend.Current = {'Ia', 'Ib', 'Ic'};

% Legend appearance
datamap.meta.legend.orientation = 'vertical';     % 'horizontal' or 'vertical'
datamap.meta.legend.location = 'eastoutside';     % Position the legend outside to the right
datamap.meta.legend.fontSize = 9;                 % Set legend font size
```

Available legend locations include: 'northeast', 'northwest', 'southeast', 'southwest', 'north', 'south', 'east', 'west', 'northoutside', 'southoutside', 'eastoutside', 'westoutside', and 'best'.

### Working with Multiple Datasets

DasPlotter provides two approaches for handling legends with multiple datasets:

#### Method 1: Explicit Legend Entries

This method gives you complete control by explicitly naming each trace:

```matlab
% Create cell array of datasets
datasets = {dataset1, dataset2};

% Create explicit legend entries for each trace in each dataset
datamap.meta.legend.Voltage = {'Normal Va', 'Normal Vb', 'Normal Vc', 'Fault Va', 'Fault Vb', 'Fault Vc'};
datamap.meta.legend.Current = {'Normal Ia', 'Normal Ib', 'Normal Ic', 'Fault Ia', 'Fault Ib', 'Fault Ic'};

% Call DasPlotter with both datasets
DasPlotter(datamap, datasets);
```

#### Method 2: Using Dataset Prefixes

This method automatically combines dataset names and variable names:

```matlab
% Create cell array of datasets
datasets = {dataset1, dataset2};

% Define variable names (without dataset prefix)
datamap.meta.legend.Voltage = {'Va', 'Vb', 'Vc'};
datamap.meta.legend.Current = {'Ia', 'Ib', 'Ic'};

% Enable dataset prefixes and define dataset names
datamap.meta.legend.useDatasetPrefix = true;
datamap.meta.legend.datasetNames = {'Normal', 'Fault'};

% This creates legends like: "Normal Va", "Fault Va", etc.
DasPlotter(datamap, datasets);
```

Choose Method 1 for complete control or Method 2 for a more scalable approach with many datasets.

### Title Configuration

```matlab
datamap.meta.title.Voltage = 'Three Phase Voltages';
datamap.meta.title.Current = 'Three Phase Currents';
```


## Use Cases

### 1. Efficient Time-Series Data Visualization
Perfect for analyzing multiple aspects of time-series data without repetitive plotting code:
```matlab
% Plot voltage and current
datamap1 = struct();
datamap1.time = 1;
datamap1.Voltage = {2, 3, 4};
datamap1.Current = {5, 6, 7};
DasPlotter(datamap1, dataset);

% Plot power and efficiency from same dataset
datamap2 = struct();
datamap2.time = 1;
datamap2.Power = {8};
datamap2.Efficiency = {9};
DasPlotter(datamap2, dataset);
```

### 2. Experimental Data Comparison
Easily compare results from multiple experiments:
```matlab
% Load two experimental datasets
dataset1 = experiment1_data;
dataset2 = experiment2_data;

% Combine datasets
datasets = {dataset1, dataset2};

% Configure plots
datamap = struct();
datamap.time = 1;
datamap.Voltage = {2, 3, 4};
datamap.Current = {5, 6, 7};

% Set up legends to distinguish between datasets
datamap.meta.legend.useDatasetPrefix = true;
datamap.meta.legend.datasetNames = {'Experiment 1', 'Experiment 2'};
datamap.meta.legend.Voltage = {'Va', 'Vb', 'Vc'};
datamap.meta.legend.Current = {'Ia', 'Ib', 'Ic'};

% Generate comparison plots
DasPlotter(datamap, datasets);
```

### 3. Reinforcement Learning Training Visualization
Use a custom x-axis to visualize training progress across episodes:
```matlab
% Configure plots with episode as x-axis
datamap = struct();
datamap.xaxis = 1;               % Use episode numbers as x-axis
datamap.Reward = {2};            % Plot rewards
datamap.Loss = {3};              % Plot training loss

% Configure custom axis labels
datamap.meta.xlabel.name = 'Training Episode';
datamap.meta.ylabel.Reward = 'Average Reward';
datamap.meta.ylabel.Loss = 'Loss Value';

% Generate plots
DasPlotter(datamap, training_data);
```

### 4. Training Algorithm Comparison
Compare multiple training runs using a common episode vector:
```matlab
% Common episode vector
episodes = 1:100;

% Datasets from different algorithm runs
datasets = {standard_run, improved_run};

% Configure comparison plots
datamap = struct();
datamap.Reward = {2, 3};  % Different column indices in each dataset
datamap.Loss = {3, 4};    % for the same metrics

% Set up legends to distinguish between algorithms
datamap.meta.legend.useDatasetPrefix = true;
datamap.meta.legend.datasetNames = {'Standard', 'Improved'};

% Use common episode vector for x-axis
DasPlotter(datamap, datasets, episodes);
```

### 5. Simulink Performance Optimization
Improve Simulink simulation speed by:
1. Removing scopes from the model
2. Logging data to workspace in aray format. let's say you set the name 'dataset'
3. Using DasPlotter for post-simulation visualization
```matlab
% After Simulink simulation completes
datamap.time = 1; % simulink, save the time in first index
datamap.Results = {2, 3, 4};  % Column indices from simout
datamap.meta.mode = 'show';
DasPlotter(datamap, out.dataset);
```

### 6. Publication-Quality Figures
Generate professional plots ready for publication:
```