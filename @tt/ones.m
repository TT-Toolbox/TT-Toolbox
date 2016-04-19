function x = ones(n)
% ONES   Creates a TT tensor with all-ones cores
%   x = ONES(n) returns a tensor with mode sizes n such that each
%   core containes only 1s. The ranks of x are all 1.
%
%   See also: TT.randn, TT.rand, TT.zeros

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

if any(n(:) ~= round(real(n(:)))) || any(n(:) < 1) || (size(n,2) ~= 2)
    error('Size vector must be a dx2 matrix of integers > 0')
end

nn = num2cell(n, 2);
cores = cellfun(@(x) ones([1,x,1]), nn, 'UniformOutput', false);
x = tt(cores);
end
