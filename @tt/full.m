function [y] = full(x)
% FULL   Expands a TT tensor into a full matrix of size prod(x.n)
%
%   y = FULL(x) Returns the full double matrix.
%       Be carefull with large tensors! This procedure can exhaust the
%       memory.
%
%   See also: TT

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE


[d,n,r,cores] = check_consistency(x);

% Reshape all cores to a r1 x n*m*r2 form
cores = cellfun(@(x)reshape(x, size(x,1), []), cores, 'UniformOutput', false);

% Init y with the first core
y = reshape(cores{1}, [], r(2));
% A sequence of multiplications
for i = 2:d
    y = y*cores{i};
    y = reshape(y, [], r(i+1));
end

% Now y has the size r(1)*n1*m1*n2*m2*...*r(d+1)
% Permute into the form r(1) x N x M x r(d+1)
sizes = reshape(n', 1, []);
sizes = [r(1), sizes, r(d+1)];
order = [1, (2:2:2*d), (3:2:2*d+1), 2*d+2];
y = reshape(y, sizes);
y = permute(y, order);
y = reshape(y, r(1), prod(n(:,1)), prod(n(:,2)), r(d+1));

% Squeeze out the unitary boundary rank for compatibility
if (r(1) == 1)
    y = reshape(y, prod(n(:,1)), prod(n(:,2)), r(d+1));
end;

end