function run_moea(c, dp, pn, use_parallel)
% Main function that runs multiple MOEAs.
% Write resuls to c.problem_path/raw_output
% Args:
%   c (struct): Comparison parameters.
%   dp (struct): Design parameters passed to ModCell2 (e.g. alpha, beta, objective type, etc).
%   pn (Class): Prodnet class from ModCell2
%   use_parallel (bool): If true, each MOEA is run with objective
%       evaluation performed in parallel, in this case the random number seed
%       is not fixed and consequently results may not be exactly reproducible.
%       Defautl is false.


%% Prepare input
c.output_path = fullfile(c.prob_path,'raw_output');
if ~exist('use_parallel','var')
    use_parallel = false;
end

algtable = readtable(c.alg_path);
algorithms = algtable.name(:);

pn.set_deletion_type('reactions');
de = MCdesign(pn);
de.ga_parameters.use_parallel		= use_parallel;
de.ga_parameters.stall_generations	= c.sampling_interval;
de.ga_parameters.progress_plot		= false;
de.ga_parameters.population_size    = c.population_size;


%% main loop
% paralellization (with parfor) of this loop makes some of the PlatEMO MOEA
% fail.
for i=1:length(algorithms)
    par_dummy(c,de,dp, algorithms, i)
end
end
function par_dummy(c, de, dp, algorithms,i)
de.ga_parameters.algorithm = algorithms{i};
fprintf('---- Algorithm: %s\n', de.ga_parameters.algorithm);

for rep_ind = 1:c.n_replicates
    fprintf('---- ---- Replicate: %d \n', rep_ind);
    rng(rep_ind) % fix rng state
    try
        start_point_info = [];
        total_max_generations = c.n_generations;
        total_max_time = 10000000;
        solve_max_gen = true;
        
        [mop_solution, run_time_min, populations] = de.solve_mop(...
            dp,start_point_info,total_max_generations,total_max_time, solve_max_gen);
        
        file_id = [algorithms{i},'_',num2str(rep_ind)];
        out.algorithm = algorithms{i};
        out.replicate = rep_ind;
        out.run_time_min = run_time_min;
        out.populations = populations;
        out.mop_solution = mop_solution;
        [~,~,~] = mkdir (c.output_path); % make dir in case it does not exist
        parsave(fullfile(c.output_path,file_id), out)
        fprintf('%s saved to ouput folder\n', file_id)
    catch ME
        fprintf('ITERATION FAILED, algorithm: %s, error message: \n %s',de.ga_parameters.algorithm,ME.message)
    end
end
end
function parsave(fname, out)
save(fname, 'out')
end
