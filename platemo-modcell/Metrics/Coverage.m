function Score = Coverage(PopObj,PF)
% <metric> <min>
% Coverage
% SG NOTES:
%   - The metric assumes maximization not minimization as originally
%   indicated.
%   - The definition of Zitzler 1999 compares divides by the cardinality of
%   the second set not the first. So the Coverage indicates the fraction of
%   points being "covered" in the true PF. Originally this function defined
%   the coverage as the fraction of point in PopObj that are also present
%   in PF. 
%
%------------------------------- Reference --------------------------------
% E. Zitzler and L. Thiele, Multiobjective evolutionary algorithms: A
% comparative case study and the strength Pareto approach, IEEE
% Transactions on Evolutionary Computation, 1999, 3(4): 257-271.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    Domi = false(1,size(PopObj,1));
    for i = 1 : size(PF,1)
        Domi(sum(repmat(PF(i,:),size(PopObj,1),1)-PopObj<=0,2)==size(PopObj,2)) = true;
    end
    %Score = sum(Domi) / size(PopObj,1);
    Score = sum(Domi) / size(PF,1);
end