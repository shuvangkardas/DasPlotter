

% Get current script directory
rootPath = fileparts(mfilename('fullpath'));

% Add paths with DasPlotter subdirectory structure
addpath(fullfile(rootPath, 'DasPlotter'));
addpath(genpath(fullfile(rootPath, 'Function')));
addpath(genpath(fullfile(rootPath, 'Script')));

% Save path
try
    savepath;
    fprintf('Installation successful!\n');
catch
    warning('Could not save path permanently. Run as administrator.');
    fprintf('Paths added for current session only.\n');
end