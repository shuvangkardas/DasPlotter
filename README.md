# DasPlotter

DasPlotter is a MATLAB library for creating customizable, publication-quality plots from time-series datasets. It provides a flexible and intuitive interface for generating single or multiple subplots with various configuration options.

## Features

- Support for single and multiple subplot layouts
- Automatic or manual layout configuration
- Customizable plot appearance (line width, colors, titles, legends)
- Data point annotation capabilities
- Flexible output modes (display or save)
- Automatic grid layout optimization
- Support for multiple datasets

## Project Structure

```
DasPlotter/
├── DasPlotter/
│   ├── DasPlotter.m        # Main plotting function
│   └── DasPlotter.asv      # MATLAB autosave file
├── Function/
│   └── create_dataset.m    # Helper function for dataset creation
├── Script/
│   ├── install.m           # Installation script
│   └── dp_example[1-5].m   # Example scripts
└── README.md
```

## Installation

There are two ways to install DasPlotter:

### Option 1: Using the Installation Script (Recommended)

1. Clone this repository:
```bash
git clone https://github.com/yourusername/DasPlotter.git
```

2. Run the installation script:
```matlab
run('install.m')
```

### Option 2: Manual Installation

1. Clone this repository
2. Add the DasPlotter folder to your MATLAB path:
```matlab
addpath('./DasPlotter/');
```

Note: If you use the installation script (Option 1), you don't need to manually add the path in your scripts.

## Quick Start

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
- The first column is typically the time vector

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

% Legend Options
datamap.meta.legend = struct();      % Legend labels per subplot
datamap.meta.legend.orientation = 'vertical';  % Legend orientation

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

### Legend Configuration

```matlab
datamap.meta.legend.Voltage = {'Va', 'Vb', 'Vc'};
datamap.meta.legend.Current = {'Ia', 'Ib', 'Ic'};
datamap.meta.legend.orientation = 'horizontal';  % or 'vertical'
```

### Title Configuration

```matlab
datamap.meta.title.Voltage = 'Three Phase Voltages';
datamap.meta.title.Current = 'Three Phase Currents';
```

## Advanced Usage

### Full Configuration Example

Here's a comprehensive example showing multiple advanced features:

```matlab
% Basic structure setup
datamap = struct();
datamap.time = 1;
datamap.Voltage = {2, 3, 4};
datamap.Current = {5, 6, 7};
datamap.Pgen = {8};             % Single column plot

% Configure plot metadata
datamap.meta.lineWidth = 1;
datamap.meta.layout = [3, 1];   % Vertical layout with 3 rows

% Configure legends for each subplot
datamap.meta.legend.Voltage = {'Va', 'Vb', 'Vc'};
datamap.meta.legend.Current = {'Ia', 'Ib', 'Ic'};

% Set y-axis limits for each subplot
datamap.meta.ylim.Voltage = [-1.5, 1.5];
datamap.meta.ylim.Current = [-1.5, 1.5];
datamap.meta.ylim.Pgen = [0, 1.2];

% Configure save options
datamap.title = 'AC_Power';     % Base filename for saved plot
datamap.meta.mode = 'save';     % Save plot instead of displaying

% Generate and save plots
DasPlotter(datamap, dataset);
```

### Output Modes

DasPlotter supports two output modes:
- `show`: Display plots in MATLAB figure window (default)
- `save`: Save plots as PNG and MAT files with timestamp

When using save mode:
- Files are saved in the current directory
- Filename format: `{title}_{timestamp}.png`
- Resolution: 300 DPI
- Figure dimensions are automatically optimized for publication

### Layout Control

The layout can be controlled in several ways:
1. Automatic grid layout (default)
2. Vertical layout (`meta.orientation = 'vertical'`)
3. Manual layout specification (`meta.layout = [rows, cols]`)

For optimal visualization:
- Grid layout works best for 2-4 subplots
- Vertical layout is recommended for 3+ related plots
- Manual layout gives full control over arrangement

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Your Name - shuvangkarcdas[at]gmail.com
Project Link: https://github.com/shuvangkardas/DasPlotter