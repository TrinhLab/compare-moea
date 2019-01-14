function Ie = Epsilon(PopObj,PF)
% <metric> <min>
% Binary epsilon-dominance indicator, additive version as reported in: 
% J. Knowles, L. Thiele, and E. Zitzler, "A Tutorial on the Performance Assessment of Stochastic Multiobjective Optimizers, " Computer Engineering and Networks Laboratory (TIK), ETH Zurich, Switzerland, 214, Feb. 2006, revised version. and Zitzler, Eckart, et al. "Performance assessment of multiobjective optimizers: An analysis and review." IEEE Transactions on evolutionary computation 7.2 (2003): 117-132.
%
% Notes:
%   - If PF corresponds to the true PF the indicator is unary.
%   - Additive indicator is used instead of multiplicative for the cases
%       where 0 objectives left the multiplicative version undefined.
%   - Assume minimization

if isempty(PopObj) || isempty(PF)
    Ie = nan; 
else
    row_eps = zeros(size(PopObj,1),1);
    for i = 1:size(PF,1)
        row_eps(i) = min(max( PopObj - repmat(PF(i,:), size(PopObj,1),1) ,[], 2 ));
    end
    
    Ie = max(row_eps);
end