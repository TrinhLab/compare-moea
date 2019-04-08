%%
clear;clc
root_dir = fileparts(which('compare-moea.m'));
global FONT_NAME 
FONT_NAME = 'DejaVu Sans';

time2 = readtable(fullfile(root_dir,'case2','analysis','timing.csv'));
time3 = readtable(fullfile(root_dir,'case3','analysis','timing.csv'));

%%
t_mean = [time2.means, time3.means];
t_std = [time2.stds, time3.stds];

nrows=1;
ncols=1;
width=ncols*500;
height=nrows*250;
colors = sns_colors();

figure('visible','off','position',[0,0,width,height+200]) % Extra width to prevenet x tick labels from being cut

% Creating axes and the bar graph
ax = axes;
h = bar(t_mean,'BarWidth',1);

% Set color for each bar face
set(h(1),'FaceColor',colors(1,:))
set(h(2),'FaceColor',colors(2,:))

% Properties of the bar graph as required
ax.YGrid = 'on';
ax.GridLineStyle = '-';


%xticks(ax, time2.algorithms);
% Naming each of the bar groups
%xticklabels(ax,{ 'Case 2', 'Case 3'});
xticklabels(ax, time2.algorithms);
xtickangle(45)

% X and Y labels
%xlabel ('\alpha');
ylabel ('Run time (min)');

% Creating a legend and placing it outside the bar plot
lg = legend('Case 2','Case 3','AutoUpdate','off');
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
set(gca, 'YScale', 'log')
box off
%axis square
set_fig_defaults
print(fullfile(root_dir,'combined_analysis','timing'),'-dsvg','-painters','-r0')
