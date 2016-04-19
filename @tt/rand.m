function x = rand(r, n)
% RAND   Creates a random TT tensor
%   x = RAND(r, n) returns a tensor with ranks r and mode sizes n such that each
%   core has entries sampled uniformly from [0,1].
%
%   See also: TT.randn

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

d = size(n,1);
cores = cell(d, 1);
for i = 1:d
    cores{i} = rand(r(i), n(i,1), n(i,2), r(i+1));
end
x = tt(cores);
end
