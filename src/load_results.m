function [results, algorithms, n_replicates] = load_results(problem_path)
% Loads raw data for analysis
output_path =  fullfile(problem_path,'raw_output');
files = what(output_path);
file_ids = files.mat;
for i =1: length(file_ids)
    file_name = file_ids{i};
    file_name = file_name(1:end-4);
    out = getfield(load(fullfile(output_path,file_name)), 'out');
 
    results.(out.algorithm)(out.replicate).run_time_min = out.run_time_min;
    results.(out.algorithm)(out.replicate).populations  = out.populations(1:end-2); % last one is duplicate and end-2 passes the generatiton target by + sampling interval
end
algorithms = fields(results);
n_replicates = length(results.(algorithms{1}));
end
