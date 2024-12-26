function DasPlotter(datamap, dataset)
    % DasPlotter - Creates plots from dataset according to datamap specifications
    % Parameters:
    %   datamap - Structure containing plotting configuration and data mappings
    %   dataset - Cell array or matrix of the actual data

    % Initialize metadata structure with default values if not provided
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
    
    % Count number of plots needed (excluding time and meta fields)
    keys = fieldnames(datamap);
    num_plots = numel(keys) - 2;  % Subtract 2 to exclude 'time' and 'meta'
    
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
    if strcmp(meta.mode, 'save')
        fig_width = 5 * num_cols;
        fig_height = 2 * num_rows;
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
        
        % Handle cell array values (multiple lines per plot)
        if iscell(value)
            for j = 1:numel(value)
                for k = 1:numel(dataset)
                    % Set legend name if provided in meta.legend
                    if isfield(meta.legend, key) && numel(meta.legend.(key)) >= j
                        legend_name = meta.legend.(key){j};
                        legend_provided = true;
                    else
                        legend_name = '';
                    end
                    
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
                        colorIndex = mod(j-1, size(colorOrder, 1)) + 1;
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
        else
            % Handle single value (one line per plot)
            for k = 1:numel(dataset)
                % Set legend name if provided in meta.legend
                if isfield(meta.legend, key)
                    legend_name = meta.legend.(key){1};
                    legend_provided = true;
                else
                    legend_name = '';
                end
                
                % Plot the data
                current_data = dataset{k}(:, value);
                plot(time_array, current_data, 'LineWidth', meta.lineWidth, ...
                    'DisplayName', legend_name);
                hold on;
                
                % Add value annotation if meta.datatip provided
                if ~isempty(meta.datatip)
                    [~, idx] = min(abs(time_array - meta.datatip));
                    val = current_data(idx);
                    
                    % Get color safely
                    colorOrder = get(gca, 'ColorOrder');
                    colorIndex = mod(k-1, size(colorOrder, 1)) + 1;
                    currentColor = colorOrder(colorIndex, :);
                    
                    % Add marker and text without legend entry
                    plot(meta.datatip, val, 'o', 'MarkerSize', 6, ...
                        'MarkerFaceColor', currentColor, 'HandleVisibility', 'off');
                    text(meta.datatip, val + 0.05, sprintf('%.2f', val), ...
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

            legend('show', 'Location', 'northeast', 'FontSize', 8, ...
                'Orientation', meta.legend.orientation);
        else
            legend('hide');
        end
        
        grid on;
        plot_index = plot_index + 1;
    end
    
    % Adjust final figure layout
    if strcmp(meta.mode, 'save')
        set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, fig_width, fig_height]);
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
%         mat_filepath = fullfile('./', [base_filename '.mat']);
        print(fig, png_filepath, '-dpng', '-r300');
        fprintf('Saved plot as: %s\n', png_filepath);
%         fprintf('Saved dataset as: %s\n', mat_filepath);
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