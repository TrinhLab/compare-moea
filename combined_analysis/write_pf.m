function write_pf(bestPF, prod_id, filename)
% Writes PF arary in a way that resembles the modcell result analysis
% output format 
ids = cellfun(@(x)([x,'(objective)']), prod_id, 'UniformOutput', false);
headers = {'Solution index', 'Deletion_id', ids{:}};

del_ids = cell(size(bestPF,1),1);
sol_idx = num2cell([1:size(bestPF,1)]');
data = [sol_idx, del_ids, num2cell(bestPF)];
write_csv(filename,[headers; data]);
end