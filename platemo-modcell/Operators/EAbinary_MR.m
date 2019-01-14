function Offspring = EAbinary_MR(Global,Parent)
% Adapted from PlatEMO's EAbinary to include module reaction(MR) constraints
% TODO:
%   * Where is crossover probability acting? 
%   * How to set mutation probability (proM) (defautl is 1/D)?
%   * The original function generates an offspring of the same size
%       as the number of parents! This is currently addressed by simply
%       running MCdesign.crossover_module_variable twice

%% General
    proM = Global.ParameterSet(1);
    Parent    = Parent([1:end,1:ceil(end/2)*2-end]);
    ParentDec = Parent.decs;
    [N,D]     = size(ParentDec);
    
    parents = 1:size(ParentDec,1); % indices of parents
    mutationRate = proM/D;
    %% One point crossover
    xoverKids1  = Global.mcdesign.crossover_module_variable(...
        parents,[],D,[],[],ParentDec);
    
    xoverKids2  = Global.mcdesign.crossover_module_variable(...
        1:size(ParentDec,1),[],D,[],[],ParentDec);
    OffspringDec = [xoverKids1; xoverKids2];

        
    %% Bitwise mutation to offspring
    mutationChildren = Global.mcdesign.mutationuniform_module(...
        parents,[],D,[],[],[],OffspringDec, mutationRate);
    
    Offspring = INDIVIDUAL(mutationChildren);
end