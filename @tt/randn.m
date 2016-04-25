function x = randn(r, n)
% RANDN   Creates a random TT tensor
%   x = RANDN(r, n) returns a tensor with ranks r and mode sizes n such that each
%   core has entries sampled from the standard normal distribution.
%
%   See also: TT.rand, TT.zeros, TT.ones

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

if any(r(:) ~= round(real(r(:)))) || any(r(:) < 1) || length(r) ~= numel(r)
    error('tt:InputError', 'Rank vector must be a vector of integers > 0')
end
if any(n(:) ~= round(real(n(:)))) || any(n(:) < 1) || (size(n,2) ~= 2)
    error('tt:InputError', 'Size vector must be a dx2 matrix of integers > 0')
end
if size(n,1)+1 ~= length(r)
    error('tt:DimensionMismatch', 'Incompatible sizes of rank vector and mode sizes')
end

d = size(n,1);
cores = cell(d, 1);
for i = 1:d
    cores{i} = randn(r(i), n(i,1), n(i,2), r(i+1));
end
x = tt(cores);
end
