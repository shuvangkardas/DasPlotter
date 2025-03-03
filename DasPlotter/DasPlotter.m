% Library Name: DasPlotter
% Author: Shuvangkar Das
% LinkedIn: https://www.linkedin.com/in/shuvangkardas
% Year: 2024
% Description:  library for creating customizable,
% publication-quality plots from time-series datasets


function DasPlotter(datamap, dataset, varargin)
    % DasPlotter - Creates plots from dataset according to datamap specifications
    % Parameters:
    %   datamap  - Structure containing plotting configuration and data mappings
    %   dataset  - Cell array or matrix of the actual data
    %   varargin - Optional parameter:
    %              - x_axis_vector: Direct vector to use as x-axis (highest priority)
    %              - OR x_axis_col: Column index to use as x-axis (if numeric scalar)

    % Initialize metadata structure with default values if not provided
    disp("DasPlotter V0.1.8");
    if ~isfield(datamap, 'meta')
        datamap.meta = struct();
    end

    meta = datamap.meta;
    
    % Set default plotting parameters
    if ~isfield(meta, 'mode')
        meta.mode = 'show';
    end
    if ~isfield(meta, 'orientation')
        meta.orientation = 'grid';
    end
    if ~isfield(meta, 'lineWidth')
        meta.lineWidth = 1;
    end
    if ~isfield(meta, 'legend')
        meta.legend = struct();
    end
    if ~isfield(meta, 'title')
        meta.title = struct();
    end
    if ~isfield(meta, 'ylim')
        meta.ylim = struct();
    end

    if ~isfield(meta, 'datatip')
        meta.datatip = []; % No annotation datatip not provided
    end
    
    % Ensure dataset is a cell array for consistent handling
    if ~iscell(dataset)
        dataset = {dataset};
    end
    
    % STEP 1: Determine the x-axis values and label based on priority sequence
    % - 1st: Direct vector passed as 3rd parameter (highest priority)
    % - 2nd: datamap.xaxis field (medium priority)
    % - 3rd: datamap.time field (lowest priority)
    
    % Default initialization
    x_values = [];
    x_label = 'Time'; % Default label
    
    % Get sample dataset to determine dimensions
    sample_dataset = dataset{1};
    num_rows = size(sample_dataset, 1);
    
    % Priority 1: Check for direct x-axis vector in varargin
    if nargin > 2 && ~isempty(varargin{1})
        % Check if it's a vector (not a scalar index)
        if numel(varargin{1}) > 1 || ~isnumeric(varargin{1}) || ~isscalar(varargin{1})
            % User provided actual x-axis vector
            x_values = varargin{1};
            
            % Validate length
            if length(x_values) ~= num_rows
                error('X-axis vector length (%d) must match dataset row count (%d)', length(x_values), num_rows);
            end
            
            % Use custom label if provided
            if isfield(meta, 'xlabel') && isfield(meta.xlabel, 'name')
                x_label = meta.xlabel.name;
            else
                x_label = 'Custom X-Axis'; % Default for custom vector
            end
            
            % We found our x-axis, so we're done with this step
        elseif isnumeric(varargin{1}) && isscalar(varargin{1})
            % User provided a column index (backward compatibility)
            x_col_idx = varargin{1};
            x_values = sample_dataset(:, x_col_idx);
            
            % Use custom label if provided
            if isfield(meta, 'xlabel') && isfield(meta.xlabel, 'name')
                x_label = meta.xlabel.name;
            else
                x_label = 'Custom X-Axis'; % Default for custom index
            end
        end
    end
    
    % Priority 2: If x_values still empty, check for datamap.xaxis
    if isempty(x_values) && isfield(datamap, 'xaxis')
        if isnumeric(datamap.xaxis) && isscalar(datamap.xaxis)
            % User specified an index in datamap.xaxis
            x_col_idx = datamap.xaxis;
            x_values = sample_dataset(:, x_col_idx);
            
            % Get x-axis label if provided
            if isfield(meta, 'xlabel') && isfield(meta.xlabel, 'name')
                x_label = meta.xlabel.name;
            else
                x_label = 'Episode'; % Default for xaxis
            end
        elseif numel(datamap.xaxis) > 1
            % User provided actual vector in datamap.xaxis
            x_values = datamap.xaxis;
            
            % Validate length
            if length(x_values) ~= num_rows
                error('X-axis vector in datamap.xaxis (length %d) must match dataset row count (%d)', length(x_values), num_rows);
            end
            
            % Get x-axis label if provided
            if isfield(meta, 'xlabel') && isfield(meta.xlabel, 'name')
                x_label = meta.xlabel.name;
            else
                x_label = 'Episode'; % Default for xaxis vector
            end
        end
    end
    
    % Priority 3: If x_values still empty, use datamap.time
    if isempty(x_values) && isfield(datamap, 'time')
        if isnumeric(datamap.time) && isscalar(datamap.time)
            % Traditional index usage
            x_col_idx = datamap.time;
            x_values = sample_dataset(:, x_col_idx);
        elseif numel(datamap.time) > 1
            % User provided vector in datamap.time
            x_values = datamap.time;
            
            % Validate length
            if length(x_values) ~= num_rows
                error('X-axis vector in datamap.time (length %d) must match dataset row count (%d)', length(x_values), num_rows);
            end
        end
        
        % Get custom x-axis label or use default 'Time'
        if isfield(meta, 'xlabel') && isfield(meta.xlabel, 'name')
            x_label = meta.xlabel.name;
        else
            x_label = 'Time'; % Default time label
        end
    end
    
    % If we still don't have valid x_values, throw an error
    if isempty(x_values)
        error('No valid x-axis specified. Please provide an x-axis through function parameter, datamap.xaxis, or datamap.time.');
    end
    
    % Convert all datamap non-cell values to cell arrays for consistent handling
    keys = fieldnames(datamap);
    for i = 1:numel(keys)
        key = keys{i};
        if ~strcmp(key, 'xaxis') && ~strcmp(key, 'time') && ~strcmp(key, 'meta') && ~strcmp(key, 'title')
            if ~iscell(datamap.(key))
                datamap.(key) = {datamap.(key)};
            end
        end
    end
    
    % Count number of plots needed (excluding x-axis fields, meta, and title fields)
    exclude_fields = false(size(keys));
    for i = 1:numel(keys)
        exclude_fields(i) = strcmp(keys{i}, 'xaxis') || strcmp(keys{i}, 'time') || strcmp(keys{i}, 'meta') || strcmp(keys{i}, 'title');
    end
    num_plots = sum(~exclude_fields);
    
    % Determine plot layout
    if isfield(meta, 'layout')
        num_rows = meta.layout(1);
        num_cols = meta.layout(2);
    elseif strcmp(meta.orientation, 'vertical')
        num_rows = num_plots;
        num_cols = 1;
    else
        [num_rows, num_cols] = determinePlotLayout(num_plots);
    end
    
    % Create figure with appropriate dimensions
    if isfield(meta, 'size') && isfield(meta.size, 'width') && isfield(meta.size, 'height')
        fig_width = meta.size.width * num_cols;
        fig_height = meta.size.height * num_rows;
    else
        fig_width = 5 * num_cols;
        fig_height = 2 * num_rows;
    end
    
    if strcmp(meta.mode, 'save')
        fig = figure('Units', 'inches', 'Position', [0, 0, fig_width, fig_height]);
    else
        fig = figure('Position', [100, 100, 300*num_cols, 250*num_rows]);
    end
    
    % Create individual plots
    plot_index = 1;
    for i = 1:numel(keys)
        key = keys{i};
        if strcmp(key, 'xaxis') || strcmp(key, 'time') || strcmp(key, 'meta') || strcmp(key, 'title')
            continue;
        end
        
        subplot(num_rows, num_cols, plot_index);
        value = datamap.(key);
        legend_provided = false;
        
        % Get total number of legend entries needed
        total_lines = 0;
        % First, verify which datasets and columns can be plotted
        valid_datasets = cell(1, numel(dataset));
        valid_columns = cell(1, numel(dataset));
        
        for k = 1:numel(dataset)
            valid_columns{k} = zeros(1, numel(value));
            dataset_cols = size(dataset{k}, 2);
            
            for j = 1:numel(value)
                % Check if the column index is valid for this dataset
                col_idx = value{j};
                if col_idx <= dataset_cols
                    valid_columns{k}(j) = 1;
                    total_lines = total_lines + 1;
                else
                    fprintf('Warning: Column %d requested but dataset %d only has %d columns. Skipping this plot.\n', ...
                        col_idx, k, dataset_cols);
                    valid_columns{k}(j) = 0;
                end
            end
        end
        
        % Initialize legend entries
        legend_entries = cell(1, total_lines);
        legend_idx = 1;
        
        % Plot only valid dataset columns
        for k = 1:numel(dataset)
            dataset_cols = size(dataset{k}, 2);
            
            for j = 1:numel(value)
                col_idx = value{j};
                
                % Skip if this column isn't valid for this dataset
                if valid_columns{k}(j) == 0
                    continue;
                end
                
                % Determine legend name based on available information
                if isfield(meta.legend, key)
                    % Check if we have dataset-specific legend setup
                    if isfield(meta.legend, 'useDatasetPrefix') && meta.legend.useDatasetPrefix
                        % Format: "Dataset1 Va, Dataset2 Va, ..."
                        if isfield(meta.legend, 'datasetNames') && numel(meta.legend.datasetNames) >= k
                            dataset_prefix = meta.legend.datasetNames{k};
                        else
                            dataset_prefix = sprintf('Dataset %d', k);
                        end
                        
                        if numel(meta.legend.(key)) >= j
                            var_name = meta.legend.(key){j};
                            legend_name = sprintf('%s %s', dataset_prefix, var_name);
                        else
                            legend_name = sprintf('%s Var %d', dataset_prefix, j);
                        end
                    else
                        % Handle multiple datasets with explicit legend entries
                        entry_idx = 0;
                        % Calculate the correct entry index by counting all valid columns up to this point
                        for prev_k = 1:k-1
                            entry_idx = entry_idx + sum(valid_columns{prev_k});
                        end
                        entry_idx = entry_idx + sum(valid_columns{k}(1:j));
                        
                        if numel(meta.legend.(key)) >= entry_idx
                            legend_name = meta.legend.(key){entry_idx};
                        elseif numel(meta.legend.(key)) >= j
                            % Fall back to variable names if dataset names aren't provided
                            legend_name = meta.legend.(key){j};
                        else
                            legend_name = sprintf('Var %d (Set %d)', j, k);
                        end
                    end
                    legend_provided = true;
                else
                    % No legend provided, create a default
                    legend_name = sprintf('Var %d (Set %d)', j, k);
                end
                
                % Store the legend entry for later use
                legend_entries{legend_idx} = legend_name;
                legend_idx = legend_idx + 1;
                
                % Plot the data
                current_data = dataset{k}(:, col_idx);
                plot(x_values, current_data, 'LineWidth', meta.lineWidth, ...
                    'DisplayName', legend_name);
                hold on;
                
                % Add value annotation if meta.datatip provided
                if ~isempty(meta.datatip)
                    [~, idx] = min(abs(x_values - meta.datatip));
                    val = current_data(idx);
                    
                    % Get color safely
                    colorOrder = get(gca, 'ColorOrder');
                    colorIndex = mod(legend_idx-2, size(colorOrder, 1)) + 1;
                    currentColor = colorOrder(colorIndex, :);
                    
                    % Add marker and text without legend entry
                    plot(meta.datatip, val, 'o', 'MarkerSize', 6, ...
                        'MarkerFaceColor', currentColor, 'HandleVisibility', 'off');
                    text(meta.datatip, val + 0.1, sprintf('%.2f', val), ...
                        'VerticalAlignment', 'bottom', ...
                        'HorizontalAlignment', 'left', ...
                        'FontSize', 8);
                end
            end
        end
        
        % If no valid data was plotted for this subplot, print a warning and continue
        if legend_idx == 1
            warning('No valid data to plot for subplot "%s". Check your column indices.', key);
            title(sprintf('%s (No valid data)', key), 'FontSize', 8);
            plot_index = plot_index + 1;
            continue;
        end
        
        % Configure plot appearance
        if isfield(meta.ylim, key)
            ylim(meta.ylim.(key));
        end
        
        if isfield(meta.title, key)
            title(meta.title.(key), 'FontSize', 8);
        else
            title(key, 'FontSize', 8);
        end
        
        % Set x-axis label with the configurable label
        xlabel(x_label, 'FontSize', 8);
        
        if isfield(meta, 'ylabel') && isfield(meta.ylabel, key)
            ylabel(meta.ylabel.(key), 'FontSize', 8);
        end
        
        set(gca, 'FontSize', 8);
        
        % Show legend only if provided in meta.legend
        if legend_provided
            % Get legend orientation, default to horizontal if not specified
            if ~isfield(meta.legend, 'orientation')
                meta.legend.orientation = 'horizontal';
            end
            
            % Get legend location, default to northeast if not specified
            if ~isfield(meta.legend, 'location')
                legend_location = 'northeast';
            else
                legend_location = meta.legend.location;
            end
            
            % Get legend font size, default to 8 if not specified
            if ~isfield(meta.legend, 'fontSize')
                legend_font_size = 8;
            else
                legend_font_size = meta.legend.fontSize;
            end

            % Only include legend entries that were actually used
            legend_entries = legend_entries(1:legend_idx-1);
            legend('show', 'Location', legend_location, 'FontSize', legend_font_size, ...
                'Orientation', meta.legend.orientation);
        else
            legend('hide');
        end
        
        grid on;
        plot_index = plot_index + 1;
    end
    
    % Adjust final figure layout
    if strcmp(meta.mode, 'save')
        % Update figure properties for better export
        set(fig, 'PaperPositionMode', 'auto');
        set(fig, 'InvertHardcopy', 'off');
        
        % Tight layout to minimize whitespace
        set(fig, 'Units', 'inches');
        fig_pos = get(fig, 'Position');
        set(fig, 'PaperUnits', 'inches');
        set(fig, 'PaperSize', [fig_pos(3) fig_pos(4)]);
    else
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
    end
    
    % Handle figure output
    if strcmp(meta.mode, 'show')
        % Just display the figure
    elseif strcmp(meta.mode, 'save')
        % Generate filename with meta.datatip
        meta.datatip_str = datestr(now, 'yyyy_mm_dd_HH_MM_SS');
        if ~isfield(datamap, 'title')
            base_filename = sprintf('plot_%s', meta.datatip_str);
        else
            base_filename = sprintf('%s_%s', strrep(datamap.title, ' ', '_'), meta.datatip_str);
        end
        
        % Save files
        png_filepath = fullfile('./', [base_filename '.png']);
        
        % Use exportgraphics instead of print for better output with less whitespace
        exportgraphics(fig, png_filepath, 'Resolution', 300, 'BackgroundColor', 'white', 'ContentType', 'image');
        fprintf('Saved plot as: %s\n', png_filepath);
    else
        error('Invalid mode. Use ''show'' or ''save''.');
    end
end

function [num_rows, num_cols] = determinePlotLayout(num_plots)
    % Calculate optimal layout for subplot arrangement
    num_cols = ceil(sqrt(num_plots));
    num_rows = ceil(num_plots / num_cols);
    
    % Adjust for better visual layout
    if num_rows == 1 && num_cols > 3
        num_rows = 2;
        num_cols = ceil(num_plots / num_rows);
    end
    
    % Handle large numbers of plots
    if num_plots > 20
        num_cols = min(num_cols, 5);
        num_rows = ceil(num_plots / num_plots);
    end
end