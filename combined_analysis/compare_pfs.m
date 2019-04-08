%% settings 
clear;clc
root_dir = fileparts(which('compare-moea.m'));
global FONT_NAME 
FONT_NAME = 'DejaVu Sans';

%% Load pareto fronts
bestPF2  = find_PF(load_results(fullfile(root_dir,'case2')));
bestPF3  = find_PF(load_results(fullfile(root_dir,'case3')));

%% Round to 3 decimal digits
n_digits = 3;
bestPF2_t = unique(round(bestPF2, n_digits), 'rows');
bestPF3_t = unique(round(bestPF3, n_digits), 'rows');
fprintf('|PF2|: %d\n',size(bestPF2_t,1))
fprintf('|PF3|: %d\n',size(bestPF3_t,1))

%% Calculate jaccard
[C,ia,ib] = intersect(bestPF2_t, bestPF3_t,'rows');
j = size(C,1) / (size(bestPF2_t,1) + size(bestPF3_t,1) - size(C,1));
fprintf('Jaccard for %d decimals rounding: %2.2f\n', n_digits, j)

%% Write pareto fornts
pn = getfield(load(fullfile(root_dir,'case2','prodnet.mat')), 'prodnet');
write_pf(bestPF2_t, pn.prod_id, 'pf2.csv')
write_pf(bestPF3_t, pn.prod_id, 'pf3.csv')

%%
id = pn.prod_id;
name = pn.prod_name;
writetable(table(id,name),'id2name.csv');