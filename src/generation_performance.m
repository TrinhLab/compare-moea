function generation_performance(prob_path, metrics, plot_replicates)
% Creates generation-dependent metrics and writes them to
% prob_path/analysis

if ~exist('metrics','var')
    metrics = {'Coverage','HV','Epsilon','DeltaP'};
end
mnames = {'C','\mathit{HV}','\epsilon','\Delta_p'};
mnames = cellfun(@(x)(['$',x,'$']),mnames,'UniformOutput',false);

metric_names = containers.Map(metrics,mnames);

if ~exist('plot_replicates','var')
    plot_replicates = true;
end
%%
[results, algorithms, n_replicates] = load_results(prob_path);

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
                if strcmp(metrics{metric_ind},'HV')
                    score = metric_handle(populations(interval_ind).PF, refPoint);
                    
                elseif any(strcmp(metrics{metric_ind},{'PD','MD', 'Coverage'})) %these metrics assume maximization
                    %Coverage???
                    score = metric_handle(populations(interval_ind).PF, bestPF);
                else
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
    end
end

%% Generation line plot
nrows=1;
ncols=4;
width=ncols*300;
height=nrows*300;

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
                if plot_replicates
                    plot(x, y ,'Color',[colors(alg_ind,:),transparency]);
                end
            end
            % plot average
            linealg(alg_ind) = plot(x, stats.(algorithms{alg_ind}).(metrics{metric_ind}).mean ,'Color',colors(alg_ind,:),'LineWidth',1.3);
        end
        ylabel(metric_names(metrics{metric_ind}),'Interpreter','latex');
        
        hold off
        xlabel('Generations')
        set_fig_defaults
        axis square
        metric_ind = metric_ind+1;
        
    end
end

print(fullfile(prob_path,'analysis','generations-line'),'-dsvg','-painters','-r0')
legend(linealg, algorithms);

print(fullfile(prob_path,'analysis','generations-line-legend'),'-dsvg','-painters','-r0')

%% Bar plot of last generation
%figure;

figure('visible','off','position',[0,0,width,height+200]) % Extra width to prevenet x tick labels from being cut

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
    yl = ylim;
    ylim([0, yl(2)]);
    
    set_fig_defaults
    plot_ind = plot_ind +1;
end

print(fullfile(prob_path,'analysis','metrics-final'),'-dsvg','-painters','-r0')

end


