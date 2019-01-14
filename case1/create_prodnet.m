tic
clear; clc;
parent_path = fileparts(which('compare-moea.m'));
input_info.problem_path = fullfile(parent_path,'case1'); 
prodnet = Prodnet(input_info); 
prodnet.problem_path = []; % Avoid forgetting to set this
prodnet.save('prodnet');
toc