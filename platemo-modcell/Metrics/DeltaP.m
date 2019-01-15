function Score = DeltaP(PopObj,PF)
% <metric> <min>
% Averaged Hausdorff distance
% Sergio Garcia: Correct definition to compute the norm with p=2 instead of means.

%------------------------------- Reference --------------------------------
% O. Schutze, X. Esquivel, A. Lara, and C. A. Coello Coello, Using the
% averaged Hausdorff distance as a performance measure in evolutionary
% multiobjective optimization, IEEE Transactions on Evolutionary
% Computation, 2012, 16(4): 504-522.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    Score = max(IGD(PopObj,PF),GD(PopObj,PF));
end
