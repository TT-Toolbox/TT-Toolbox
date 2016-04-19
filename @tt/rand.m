function x = rand(r, n)
% RAND   Creates a random TT tensor
%   x = RAND(r, n) returns a tensor with ranks r and mode sizes n such that each
%   core has entries sampled uniformly from [0,1].
%
%   See also: TT.randn, TT.zeros, TT.ones

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

if any(r(:) ~= round(real(r(:)))) || any(r(:) < 1) || (min(size(r)) ~= 1)
    error('Rank vector must be a vector of integers > 0')
end
if any(n(:) ~= round(real(n(:)))) || any(n(:) < 1) || (size(n,2) ~= 2)
    error('Size vector must be a dx2 matrix of integers > 0')
end
if size(n,1)+1 ~= length(r)
    error('Incompatible sizes of rank vector and mode sizes')
end

d = size(n,1);
cores = cell(d, 1);
for i = 1:d
    cores{i} = rand(r(i), n(i,1), n(i,2), r(i+1));
end
x = tt(cores);
end
