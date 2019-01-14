function varargout = modcell(Operation,Global,input)
% Modcell problem in platemo 
% Sergio Garcia

switch Operation
    case 'init'
        
        Global.N = Global.mcdesign.ga_parameters.population_size;
        Global.M = Global.mcdesign.ga_parameters.n_objectives;
        Global.D = Global.mcdesign.ga_parameters.n_variables;
        
        if Global.mcdesign.use_module_variable
            Global.operator = @EAbinary_MR;
        else
            Global.operator = @EAbinary;
        end
        
        PopDec = Global.mcdesign.ga_parameters.initial_population;
        
        varargout = {PopDec};
    case 'value'
        %PopDec = input;
        n_individuals = size(input,1);% Global.N; %size(input,1);
        %n_individuals_true = size(input,1); % Some algorithms pass input of incosistent size
        PopObj = zeros(n_individuals, Global.M);
        
        obj_fun_handle = @(x)-calc_penalty_obj_fun(Global.mcdesign,x);  % All methods minimize

        if Global.mcdesign.ga_parameters.use_parallel
            parfor i =1:n_individuals
                PopObj(i,:) = obj_fun_handle(input(i,:));
            end
        else
            for i =1:n_individuals
                PopObj(i,:) = obj_fun_handle(input(i,:));
            end
        end
        
        PopCon = [];
        varargout = {input,PopObj,PopCon};
    case 'PF'
        f = -ones(Global.N,1); %This is actually an upperbound for the pareto front.
        varargout = {f};
    case 'draw'
        %cla; Draw(input*P');
        n_clusters = 10;
        Result_analysis.draw_pf_2d(-input,n_clusters,Global.mcdesign.prodnet.prod_id);
end
end