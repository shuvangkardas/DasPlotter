% Library Name: DasPlotter
% Author: Shuvangkar Das
% LinkedIn: https://www.linkedin.com/in/shuvangkardas
% Year: 2024
% Description:  library for creating customizable,
% publication-quality plots from time-series datasets

% Get current script directory
rootPath = fileparts(mfilename('fullpath'));

% Add paths with DasPlotter subdirectory structure
addpath(fullfile(rootPath, 'DasPlotter'));
addpath(genpath(fullfile(rootPath, 'Function')));
addpath(genpath(fullfile(rootPath, 'Script')));

% Save path
try
    savepath;
    fprintf('DasPlotter Installation successful!\n');
catch
    warning('Could not save path permanently. Run as administrator.');
    fprintf('Paths added for current session only.\n');
end