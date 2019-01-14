function Score = HV(PopObj,RefPoint)
% <metric> <max>
% See the directory compare-moea/hv for implementation details


Score = Hypervolume_MEX(PopObj,RefPoint);