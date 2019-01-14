function plot_pf(prob_path,row_by_col)
% Plots pareto fronts for a 3d problem
% Do not plot replicates since it is TMI

if ~exist('row_by_col','var')
    row_by_col=[4,3];
end
%%
[results, algorithms, n_replicates] = load_results(prob_path);
%ncols= n_replicates; % One col per replicate
%nrows= length(algorithms); % One row per algorithm

pn = getfield(  load(fullfile(prob_path,'prodnet.mat')), 'prodnet');

rep_ind =1;
%%
nrows = row_by_col(1);
ncols = row_by_col(2);
width=ncols*300;
height=nrows*300;
%figure('Renderer', 'painters', 'Position', [10 10 900 600])
figure('visible','off','position',[0,0,width,height])
colors = linspecer(length(algorithms));

plot_ind = 1;
for row_ind = 1:nrows
    for col_ind = 1:ncols
        if plot_ind >length(algorithms)
            break
        end
        subplot(nrows,ncols, plot_ind)
        PF = results.(algorithms{plot_ind})(rep_ind).populations(end).PF;
        scatter3(PF(:,1),PF(:,2),PF(:,3), 'MarkerEdgeColor','k','MarkerFaceColor',colors(plot_ind,:))

        xlabel(pn.prod_name{1})
        ylabel(pn.prod_name{2})
        zlabel(pn.prod_name{3})
        set(get(gca,'xlabel'),'rotation',30)
        set(get(gca,'ylabel'),'rotation',-30 )
        xlim([0,1])
        ylim([0,1])
        zlim([0,1])
        %title([algorithms{row_ind},'-rep',num2str(col_ind)])
        title(algorithms{plot_ind})
        axis square
        set_fig_defaults;
        plot_ind = plot_ind + 1;
    end
end
print(fullfile(prob_path,'analysis','pf'),'-dsvg','-painters','-r0')
