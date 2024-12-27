% Library Name: DasPlotter
% Author: Shuvangkar Das
% LinkedIn: https://www.linkedin.com/in/shuvangkardas
% Year: 2024
% Description:  library for creating customizable,
% publication-quality plots from time-series datasets


% Get current script directory
rootPath = fileparts(mfilename('fullpath'));

% Remove paths
rmpath(fullfile(rootPath, 'DasPlotter'));
rmpath(fullfile(rootPath, 'Function'));
rmpath(fullfile(rootPath, 'Script'));

% Save path
try
    savepath;
    fprintf('DasPlotter uninstalled successfully!\n');
catch
    warning('Could not save path permanently. Run as administrator.');
    fprintf('Paths removed for current session only.\n');
end

% Clear functions from memory
clear functions