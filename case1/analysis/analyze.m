%%
clear;clc
root_dir = fileparts(which('compare-moea.m'));
% Load and prepare output for analysis
prob_name = 'case1';
prob_path = fullfile(root_dir, prob_name);

global FONT_NAME 
FONT_NAME = 'DejaVu Sans';
%%
generation_performance(prob_path, 'base_dimensions',[220,220],...
    'base_dimensions_bar_combined',[200,200]);
%%
plot_pf(prob_path, 'plot_type', 'n_d','base_dimensions',[150,200]);
plot_pf(prob_path, 'plot_type', '3_d','base_dimensions',[300,300]);
%%
save_PF(prob_path,'best');
save_PF(prob_path,'gamultiobj_1');
