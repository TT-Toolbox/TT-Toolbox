function res = norm(x)
% NORM   Returns the Frobenius norm of a TT tensor
%   res = NORM(x) returns the Frobenius norm of the TT tensor x.
%   Note that this calculation is particulary cheap if x is 
%   orthogonalized.
%
%   See also: DOT, ORTHOGONALIZE

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

[~,~,r,cores] = check_consistency(x);
if r(1) ~= 1 || r(end) ~= 1
    error('tt:DimensionMismatch', 'First and last ranks of the tensor must be 1')
end
if x.orth ~= 0
    res = norm(cores{x.orth}(:));
else
    x = orthogonalize(x,1);
    cores = x.cores;
    res = norm(cores{1}(:));
end
