function plot_timing(prob_path, style)
% Plot total run time of each algorithm

%%
[results, algorithms, n_replicates] = load_results(prob_path);

%% Compute averages:
means = nan(length(algorithms),1);
stds = nan(length(algorithms),1);
for alg_ind = 1:length(algorithms)
    means(alg_ind) = mean([results.(algorithms{alg_ind}).run_time_min]);
    stds(alg_ind) = std([results.(algorithms{alg_ind}).run_time_min]);
end

%% save raw data to file
writetable(table(algorithms, means, stds), fullfile(prob_path,'analysis','timing.csv'))

%% Figure
nrows=1;
ncols=1;
width=ncols*300;
height=nrows*300;
colors = [sns_colors; sns_colors('deep')];

figure('visible','off','position',[0,0,width,height+200]) % Extra width to prevenet x tick labels from being cut

y = means;
s = stds;
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
ylabel('Time (min)')
print(fullfile(prob_path,'analysis','timing'),'-dsvg','-painters','-r0')
end


