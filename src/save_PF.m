function save_PF(prob_path, type)
% Saves the pareto front
% The type argument determine which one should be saved the options are
% 'best' or the <algorihm-name>_<replicate> e.g. gamultiobj_1, in which case the
% last one will be saved.

results = load_results(prob_path);
pn = getfield(  load(fullfile(prob_path,'prodnet.mat')), 'prodnet');

if strcmp(type,'best')
bestPF  = find_PF(results);
T = array2table(bestPF,'VariableNames',pn.prod_id);
writetable(T, fullfile(prob_path,'analysis','bestPF.csv'));
else
    strs = split('gamultiobj_1','_');
    algorithm = strs{1};
    replicate = str2num(strs{2});
    PF = results.(algorithm)(replicate).populations(end).PF;
    T = array2table(PF,'VariableNames',pn.prod_id);
    writetable(T, fullfile(prob_path,'analysis',[type,'_PF.csv']));
end
end