function PF  = find_PF(results, tol)
% Finds the best approximation of the pareto front for a given problem
if nargin < 2
    tol = 1e-4;
end
algorithms = fields(results);
n_replicates = size(results.(algorithms{1}),2);
all_pops = [];
for alg_ind = 1:length(algorithms)
    for rep_ind = 1:n_replicates
            try
                last_PF = results.(algorithms{alg_ind})(rep_ind).populations(end).PF;
            catch ME
                fprintf('Bad population, algorithm: %s \t rep: %d \t error message: \n %s\n',...
                    algorithms{alg_ind},rep_ind,ME.message)
            end
        all_pops = [all_pops;last_PF];
    end
end
upop = uniquetol(all_pops,tol,'ByRows',true);
frontind = NDSort(-abs(upop),1);
PF = upop(frontind ==1,:);
end
