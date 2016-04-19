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

d = size(n,1);
cores = cell(d, 1);
for i = 1:d
    cores{i} = ones(1, n(i,1), n(i,2), 1);
end
x = tt(cores);
end
