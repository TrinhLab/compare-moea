%% run
clear;clc
root_dir = fileparts(which('compare-moea.m'));
warning('off','all')
diary('run.log')

% load prodnet
prob_name = 'case3';
pn = getfield(load(fullfile(root_dir,'case2','prodnet.mat')), 'prodnet');
pn.problem_name = prob_name;
pn.problem_path = fullfile(root_dir,prob_name);
pn.set_deletion_type('reactions');

% Comparison parameters
c.prob_path = fullfile(root_dir, prob_name);
c.alg_path = fullfile(root_dir,'src','algorithms.csv');
c.n_generations = 200;
c.sampling_interval = 10;
c.population_size = 100*10;
c.n_replicates = 3;

% Design parameters
dp.objective     = 'wGCP';
dp.max_deletions = 3;
dp.max_module    = 0 .* ones(pn.n_prod,1);

run_moea(c, dp, pn)

% Clean intermediate files
rmdir(fullfile(root_dir, prob_name, 'output'), 's')

diary off

% Re-enable all warnings
warning('on','all')
warning('query','all')