function generation_performance(prob_path, varargin)
% Creates generation-dependent metrics and writes them to
% inputs.prob_path/analysis

%% Input parameters
p = inputParser;
p.addRequired('prob_path');
p.addParameter('metrics', {'Coverage','HV','Epsilon','DeltaP'});
p.addParameter('yticks_values', [0. 0.25, 0.5,0.75, 1]);
p.addParameter('plot_replicates', true);
p.addParameter('base_dimensions',[]);
p.addParameter('base_dimensions_bar_combined',[]);
p.parse(prob_path, varargin{:})
inputs = p.Results;

if isempty(inputs.base_dimensions)
    width_base = 270;
    height_base = 270;
else
    width_base = inputs.base_dimensions(1);
    height_base = inputs.base_dimensions(2);
end

if isempty(inputs.base_dimensions_bar_combined)
    width_base_bc = width_base;
    height_base_bc = height_base;
else
    width_base_bc = inputs.base_dimensions_bar_combined(1);
    height_base_bc = inputs.base_dimensions_bar_combined(2);
end
metrics = inputs.metrics;
mnames = {'C','\mathit{HV}','\epsilon','\Delta_p'};
mnames = cellfun(@(x)(['$',x,'$']),mnames,'UniformOutput',false);
metric_names = containers.Map(metrics,mnames);


%% Load results
[results, algorithms, n_replicates] = load_results(inputs.prob_path);
bestPF  = find_PF(results);
refPoint = ones(1,size(bestPF,2));

%% Compute metrics (HV is slow)
fprintf('Computing metrics...')
for metric_ind = 1:length(metrics)
    metric_handle = str2func(metrics{metric_ind});
    fprintf('%s, ',metrics{metric_ind})
    for alg_ind = 1:length(algorithms)
        for rep_ind = 1:n_replicates
            populations = results.(algorithms{alg_ind})(rep_ind).populations;
            for interval_ind =1:length(populations)
                if any(strcmp(metrics{metric_ind},{'HV','HV_platemo'})) %Hypervolume uses reference point
                    score = metric_handle(populations(interval_ind).PF, refPoint);        
                elseif any(strcmp(metrics{metric_ind},{'PD','MD', 'Coverage'})) %these metrics assume maximization
                    score = metric_handle(populations(interval_ind).PF, bestPF);
                else  %The remaining metrics assume minimization
                    score = metric_handle(-populations(interval_ind).PF, -bestPF);
                end
                if isempty(score)
                    results.(algorithms{alg_ind})(rep_ind).(metrics{metric_ind})(interval_ind)= nan;
                else
                    results.(algorithms{alg_ind})(rep_ind).(metrics{metric_ind})(interval_ind)= score;
                end
            end
        end
    end
end
fprintf('...done\n')

%% Compute averages:
max_val = 0;
for metric_ind = 1:length(metrics)
    for alg_ind = 1:length(algorithms)
        % get score matrix
        n_samples = size(results.(algorithms{alg_ind})(rep_ind).populations,2); % Should be the same for all!
        scores = zeros(n_replicates,n_samples);
        for rep_ind = 1:n_replicates
            scores(rep_ind,:) = results.(algorithms{alg_ind})(rep_ind).(metrics{metric_ind});
        end
        stats.(algorithms{alg_ind}).(metrics{metric_ind}).mean = mean(scores,1);
        stats.(algorithms{alg_ind}).(metrics{metric_ind}).std = std(scores,[],1);
        if max(stats.(algorithms{alg_ind}).(metrics{metric_ind}).mean)  > max_val
            max_val = max(stats.(algorithms{alg_ind}).(metrics{metric_ind}).mean);
        end
    end
end

%% Generation line plot
nrows=1;
ncols=4;
width=ncols*width_base;
height=nrows*height_base;

colors = [sns_colors; sns_colors('deep')];

transparency = 0.2;

figure('visible','off','position',[0,0,width,height])

clear linealg
metric_ind=1;
for row_ind = 1:nrows
    for col_ind = 1:ncols
        subplot(nrows,ncols, (col_ind -1)*nrows + row_ind)
        hold on
        if metric_ind >length(metrics)
            break;
        end
        for alg_ind= 1:length(algorithms)
            % plot replicates
            for rep_ind = 1:n_replicates
                x = [results.(algorithms{alg_ind})(rep_ind).populations.total_gen];
                y = results.(algorithms{alg_ind})(rep_ind).(metrics{metric_ind});
                if inputs.plot_replicates
                    plot(x, y ,'Color',[colors(alg_ind,:),transparency]);
                end
            end
            % plot average
            linealg(alg_ind) = plot(x, stats.(algorithms{alg_ind}).(metrics{metric_ind}).mean ,'Color',colors(alg_ind,:),'LineWidth',1.3);
        end
        ylabel(metric_names(metrics{metric_ind}),'Interpreter','latex');
        ylim([0,max_val])
        yticks(inputs.yticks_values)
        hold off
        xlabel('Generations')
        set_fig_defaults
        axis square
        metric_ind = metric_ind+1;
        
    end
end

print(fullfile(inputs.prob_path,'analysis','generations-line'),'-dsvg','-painters','-r0')
legend(linealg, algorithms);

print(fullfile(inputs.prob_path,'analysis','generations-line-legend'),'-dsvg','-painters','-r0')

%% Bar plot of last generation
nrows=1;
ncols=4; 
width=ncols*width_base;
height=nrows*height_base;
figure('visible','off','position',[0,0,width,height+200]) % Extra height to prevenet x tick labels from being cut

plot_ind = 1;
for metr_ind = 1:length(metrics)
    subplot(nrows,ncols, plot_ind)
    meane = nan(length(algorithms),1);
    stde = nan(length(algorithms),1);
    for alg_ind = 1:length(algorithms)
        meane(alg_ind,1) = stats.(algorithms{alg_ind}).(metrics{metr_ind}).mean(end);
        stde(alg_ind,1) = stats.(algorithms{alg_ind}).(metrics{metr_ind}).std(end);
    end
    ylabel(metric_names(metrics{metr_ind}),'Interpreter','latex');
    
    y = meane;                  %The data.
    s = stde;                   %The standard deviation.
    aHand = gca;
    hold(aHand, 'on')
    for i = 1:numel(y)
        bar(i, y(i), 'parent', aHand, 'facecolor', colors(i,:));
    end
    set(gca, 'XTick', 1:numel(y), ...
        'XTickLabel', algorithms,...
        'XTickLabelRotation',90)
    errorbar(y,s,'k', 'linestyle', 'none');
    axis square
    
    % Make sure high stdev metrics start on 0
    %yl = ylim;
    %ylim([0, yl(2)]);
    ylim([0,max_val])
    yticks(inputs.yticks_values)
    
    set_fig_defaults
    plot_ind = plot_ind +1;
end

print(fullfile(inputs.prob_path,'analysis','metrics-final'),'-dsvg','-painters','-r0')

%% Bar plot of last generation combined into one
width=2*width_base_bc;
height=1*height_base_bc;
figure('visible','off','position',[0,0,width,height+200]) % Extra height to prevenet x tick labels from being cut

t_mean = [];
t_std = [];
for metr_ind = 1:length(metrics)
    meane = nan(length(algorithms),1);
    stde = nan(length(algorithms),1);
    for alg_ind = 1:length(algorithms)
        meane(alg_ind,1) = stats.(algorithms{alg_ind}).(metrics{metr_ind}).mean(end);
        stde(alg_ind,1) = stats.(algorithms{alg_ind}).(metrics{metr_ind}).std(end);
    end
    t_mean = [t_mean, meane];
    t_std = [t_std, stde];
end

ax = axes;
h = bar(t_mean,'BarWidth',1);

for i =1:length(metrics)
    set(h(i),'FaceColor',colors(i,:))
end
ax.YGrid = 'on';
ax.GridLineStyle = '-';

xticklabels(ax, algorithms);
if width_base_bc < 350
xtickangle(90)
else
    xtickangle(45)
end

ylabel ('Metric value');

lg = legend(mnames, 'Interpreter', 'latex', 'AutoUpdate','off');

lg.Location = 'BestOutside';
lg.Orientation = 'Horizontal';

% Finding the number of groups and the number of bars in each group
ngroups = size(t_mean, 1);
nbars = size(t_mean, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
hold on;
% Set the position of each error bar in the centre of the main bar
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, t_mean(:,i), t_std(:,i), 'k', 'linestyle', 'none');
end

hold off
box off
%axis square
ylim([0,max_val])
yticks(inputs.yticks_values)
set_figure_defaults

print(fullfile(inputs.prob_path,'analysis','metrics-final-combined'),'-dsvg','-painters','-r0')

%% Generation line plot by algorithm
nrows=3;
ncols=4;
width=ncols*width_base;
height=nrows*height_base;

colors = sns_colors();
transparency = 0.2;

figure('visible','off','position',[0,0,width,height])
clear linealg
alg_ind = 1;
for row_ind = 1:nrows
    for col_ind = 1:ncols
        subplot(nrows,ncols, alg_ind)
        hold on
        if alg_ind >length(algorithms)
            break;
        end
        for metric_ind = 1:length(metrics)
            for rep_ind = 1:n_replicates
                x = [results.(algorithms{alg_ind})(rep_ind).populations.total_gen];
                y = results.(algorithms{alg_ind})(rep_ind).(metrics{metric_ind});
                if inputs.plot_replicates
                    plot(x, y ,'Color',[colors(metric_ind,:),transparency]);
                end
            end
            % plot average
            y = stats.(algorithms{alg_ind}).(metrics{metric_ind}).mean;
            linealg(metric_ind) = plot(x, y, 'Color',colors(metric_ind,:),'LineWidth',1.8);
        end
        ylim([0,max_val])
        yticks(inputs.yticks_values)
        title(algorithms{alg_ind}, 'FontWeight', 'Normal')

        hold off
        %ylabel('Metric value')
        %xlabel('Generations')
        set_fig_defaults
        axis square
        alg_ind = alg_ind + 1;
    end
end

legend(linealg, mnames, 'Interpreter', 'latex');

print(fullfile(inputs.prob_path,'analysis','generations-line-legend-by-gen'),'-dsvg','-painters','-r0')

end


