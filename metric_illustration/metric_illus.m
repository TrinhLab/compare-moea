clear;clc
root_dir = fileparts(which('compare-moea.m'));
% Choose a very simple 2D PF to show how metrics work

pf1 = [0 0; 0 0];
pf2 = [0.4 0;  0.2 0.2; 0 0.4];
pf3 = [0.6 0; 0.4,0.4; 0 0.8];

gen(1).pf = pf1;
gen(2).pf = pf2;
gen(3).pf = pf3;
% Best PF
pf_best = [1 0.8; 0.8 1];
gen(4).pf = pf_best;

%%
width=300;
height=300*2;
figure('visible','off','position',[0,0,width,height])

%% Plots PFs
%width=300;
%height=300;
%figure('visible','off','position',[0,0,width,height])
subplot(2,1,1)
colors = sns_colors;
hold on
plot(pf1(:,1),pf1(:,2),'--o','MarkerSize',5,'MarkerFaceColor',colors(1,:),'Color',colors(1,:),'LineWidth',2)
plot(pf2(:,1),pf2(:,2),'--o','MarkerSize',5,'MarkerFaceColor',colors(2,:),'Color',colors(2,:),'LineWidth',2)
plot(pf3(:,1),pf3(:,2),'--o','MarkerSize',5,'MarkerFaceColor',colors(3,:),'Color',colors(3,:),'LineWidth',2)
plot(pf_best(:,1),pf_best(:,2),'--o','MarkerSize',5,'MarkerFaceColor',colors(4,:),'Color',colors(4,:),'LineWidth',2)
hold off
xlim([0,1]);
ylim([0,1]);
xticks([0:0.2:1])
yticks([0:0.2:1])

axis square
xlabel('Objective 1')
ylabel('Objective 2')
grid on
set_fig_defaults;
legend({'Generation 1', 'Generation 2', 'Generation 3', 'Generation 4/True PF'})
%print(fullfile(root_dir,'metric_illustration','pf'),'-dsvg','-painters','-r0')

%% Plt gen-metrics
subplot(2,1,2)

metrics = {'Coverage','HV','Epsilon',...
    'GD','IGD','DeltaP',...
    'DM'};
score_gen = nan(length(gen),1);

hold on

for metric_ind = 1:length(metrics)
    metric_handle = str2func(metrics{metric_ind});
    for gen_ind = 1:length(gen)
    if strcmp(metrics{metric_ind},'HV')
        score_gen(gen_ind) = metric_handle(gen(gen_ind).pf,...
            ones(1,size(gen(gen_ind).pf,2)));
    elseif any(strcmp(metrics{metric_ind},{'PD','MD', 'Coverage'})) %these metrics assume maximization
        score_gen(gen_ind) = metric_handle(gen(gen_ind).pf, pf_best);
    else
        score_gen(gen_ind) = metric_handle(-gen(gen_ind).pf, -pf_best);
    end
    end
    plot(score_gen,'LineWidth',2, 'Color',colors(metric_ind,:))
end
hold off

legend(metrics)
xticks(1:length(gen))
set_fig_defaults;
axis square
xlabel('Generations')
ylabel('Score')
grid on
%print(fullfile(root_dir,'metric_illustration','metrics'),'-dsvg','-painters','-r0')
print(fullfile(root_dir,'metric_illustration','fig'),'-dsvg','-painters','-r0')
