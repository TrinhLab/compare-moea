%%
clear;clc
root_dir = fileparts(which('compare-moea.m'));

% Load and prepare output for analysis
prob_name = 'case2';
prob_path = fullfile(root_dir, prob_name);

%%
generation_performance(prob_path);
plot_pf(prob_path); % only the first 3 objectives will be ploted.
