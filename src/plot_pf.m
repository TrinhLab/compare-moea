function plot_pf(prob_path,varargin)
% Plots pareto fronts for a 3d problem

% fixed param
rep_ind =1; % Replicate to plot % Do not plot replicates since it is TMI

% modifiable param
p = inputParser;
p.addRequired('prob_path');
p.addParameter('row_by_col', [3,4]);
p.addParameter('n_clusters', 10);
p.addParameter('prodnet_path', []);
p.addParameter('plot_type',[]);
p.addParameter('base_dimensions',[]);
p.parse(prob_path, varargin{:})
inputs = p.Results;

if isempty(inputs.base_dimensions)
    width_base = 270;
    height_base = 270;
else
    width_base = inputs.base_dimensions(1);
    height_base = inputs.base_dimensions(2);
end


if isempty(inputs.prodnet_path)
    prodnet_path = fullfile(inputs.prob_path,'prodnet.mat');
else
    prodnet_path = inputs.prodnet_path;
end

%%
[results, algorithms, n_replicates] = load_results(inputs.prob_path);
%ncols= n_replicates; % One col per replicate
%nrows= length(algorithms); % One row per algorithm

pn = getfield(load(prodnet_path), 'prodnet');

n_obj = size(results.(algorithms{1})(1).populations(1).PF, 2);
bestPF  = find_PF(results);

if isempty(inputs.plot_type)
    if n_obj == 3
        plot_type = '3_d';
    else
        plot_type = 'n_d';
    end
else
    plot_type = inputs.plot_type;
end

%%
switch plot_type
    case '3_d'
        nrows = inputs.row_by_col(1);
        ncols = inputs.row_by_col(2);
        width = ncols*width_base;
        height = nrows*height_base;
        figure('visible','off','position',[0,0,width,height])
        colors = [sns_colors; sns_colors('deep')];
        
        plot_ind = 1;
        for row_ind = 1:nrows
            for col_ind = 1:ncols
                if plot_ind > length(algorithms)
                    break
                end
                subplot(nrows,ncols, plot_ind)
                PF = results.(algorithms{plot_ind})(rep_ind).populations(end).PF;
                scatter3(PF(:,1),PF(:,2),PF(:,3), 'MarkerEdgeColor','k','MarkerFaceColor',colors(plot_ind,:))
                
                xlabel(pn.prod_name{1})
                ylabel(pn.prod_name{2})
                zlabel(pn.prod_name{3})
                % set(get(gca,'xlabel'),'rotation',30)
                % set(get(gca,'ylabel'),'rotation',-30)
                xlim([0,1])
                ylim([0,1])
                zlim([0,1])
                title(algorithms{plot_ind}, 'FontWeight', 'Normal')
                
                axis square
                set_fig_defaults;
                plot_ind = plot_ind + 1;
            end
        end
        
    case 'n_d'
        % settings
        PF = bestPF;
        objective_name = pn.prod_name;
        
        [~, sort_ind] = sort(mean(PF,1),'descend');
        
        PF = PF(:, sort_ind);
        objective_name = objective_name(sort_ind);
        
        % A 2 dimensional representation of the pareto front, representative
        % solutions are determined through k-medoids clustering.
        
        if inputs.n_clusters > size(PF,1)
            inputs.n_clusters = size(PF,1);
            fprintf('Number of clusters set to number of rows\n')
        end
        % Find clusters
        [IDX,C,SUMD,~,midx] = kmedoids(PF,inputs.n_clusters,'Replicates',20);
        
        % Create a structure that for each centroid has index of centroid and
        % indices of other point in cluster:
        [clusInd]   = unique(IDX,'stable');
        clusters    = [];
        for i = 1:length(clusInd)
            pointsInCluster         = find(IDX == clusInd(i));
            clusters(i).centroidInd = intersect(midx,pointsInCluster);
            clusters(i).otherPoints = setdiff(pointsInCluster,midx);
        end
        
        maxObj  = max(PF,[],1);
        nobj    = 1:size(PF,2);
        
        c   = sns_colors();
        ind = uint8(linspace(1,size(c,1),length(clusters)));
        c   = c(ind,:);
        
        % plot
        % Match dimensions of bar plot
        width = 1.8*width_base;
        height = 1*height_base + 40;
        figure('visible','off','position',[0,0,width,height])
        
        hold on
        
        %First plot medoids and add legend, then include others:
        for i = 1:inputs.n_clusters
            curColor        = c(i,:);
            tsol            = PF(clusters(i).centroidInd,:);
            transparency    = 1;
            pspec           = [curColor, transparency];
            plot(nobj,tsol,'Color',pspec,'LineWidth',1.5);
            scatter(nobj, tsol, 30, 'MarkerEdgeColor',curColor.*0.8, 'MarkerFaceColor', curColor);
        end
        
        for i = 1:inputs.n_clusters
            curColor = c(i,:);
            for j =1:length(clusters(i).otherPoints)
                tsol            = PF(clusters(i).otherPoints(j),:);
                transparency    = 0.4;
                pspec           = [curColor,transparency];
                plot(nobj,tsol,'--','Color',pspec,'LineWidth',1);
            end
        end
        hold off
            
        xticks(1:length(objective_name));
        xticklabels(objective_name);
        xtickangle(90)
        ylabel('Objective function value')
        xlim([0.5,length(objective_name)+0.5])
        ylim([0,1])
        yticks([0, 0.25, 0.5, 0.75, 1])
        set_fig_defaults();
end

print(fullfile(inputs.prob_path,'analysis',['pf_',plot_type]),'-dsvg','-painters','-r0')
end

