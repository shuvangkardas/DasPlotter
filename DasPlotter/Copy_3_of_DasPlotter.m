% Library Name: DasPlotter
% Author: Shuvangkar Das
% LinkedIn: https://www.linkedin.com/in/shuvangkardas
% Year: 2024
% Description:  library for creating customizable,
% publication-quality plots from time-series datasets


function DasPlotter(datamap, dataset)
    % DasPlotter - Creates plots from dataset according to datamap specifications
    % Parameters:
    %   datamap - Structure containing plotting configuration and data mappings
    %   dataset - Cell array or matrix of the actual data

    % Initialize metadata structure with default values if not provided
    disp("DasPlotter V0.1.4");
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
    
    % Convert all datamap non-cell values to cell arrays for consistent handling
    keys = fieldnames(datamap);
    for i = 1:numel(keys)
        key = keys{i};
        if ~strcmp(key, 'time') && ~strcmp(key, 'meta') && ~strcmp(key, 'title')
            if ~iscell(datamap.(key))
                datamap.(key) = {datamap.(key)};
            end
        end
    end
    
    % Count number of plots needed (excluding time and meta fields)
    num_plots = numel(keys) - sum(strcmp(keys, 'time') | strcmp(keys, 'meta') | strcmp(keys, 'title'));
    
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
    
    % Extract time array from dataset
    time_array = dataset{1}(:, datamap.time);
    
    % Create individual plots
    plot_index = 1;
    for i = 1:numel(keys)
        key = keys{i};
        if strcmp(key, 'time') || strcmp(key, 'meta') || strcmp(key, 'title')
            continue;
        end
        
        subplot(num_rows, num_cols, plot_index);
        value = datamap.(key);
        legend_provided = false;
        
        % Get total number of legend entries needed (datasets × variables)
        total_lines = numel(value) * numel(dataset);
        legend_entries = cell(1, total_lines);
        legend_idx = 1;
        
        % Improved legend handling for multiple datasets
        for k = 1:numel(dataset)
            for j = 1:numel(value)
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
                        entry_idx = (k-1)*numel(value) + j;
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
                current_data = dataset{k}(:, value{j});
                plot(time_array, current_data, 'LineWidth', meta.lineWidth, ...
                    'DisplayName', legend_name);
                hold on;
                
                % Add value annotation if meta.datatip provided
                if ~isempty(meta.datatip)
                    [~, idx] = min(abs(time_array - meta.datatip));
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
        
        % Configure plot appearance
        if isfield(meta.ylim, key)
            ylim(meta.ylim.(key));
        end
        
        if isfield(meta.title, key)
            title(meta.title.(key), 'FontSize', 8);
        else
            title(key, 'FontSize', 8);
        end
        
        xlabel('Time', 'FontSize', 8);
        
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