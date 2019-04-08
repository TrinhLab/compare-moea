%%
clear;clc
root_dir = fileparts(which('compare-moea.m'));

% Load and prepare output for analysis
prob_name = 'case2';
prob_path = fullfile(root_dir, prob_name);

global FONT_NAME 
FONT_NAME = 'DejaVu Sans';
%%
%generation_performance(prob_path);
generation_performance(prob_path,'plot_replicates', false, 'base_dimensions_bar_combined',[560,270]);
plot_pf(prob_path);
plot_timing(prob_path);