function [c]=dot(a,b,varargin)
% DOT   inner product
%
%   c = DOT(a,b) Inner product of two TT vectors (matrices are considered
%   as nm x 1 vectors)
%
%   See also: MTIMES, TIMES, PLUS, MINUS

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

[d,na,ra,a] = check_consistency(a);
[d2,nb,rb,b] = check_consistency(b);
if ( d~= d2 )
    error('Dimensions of a and b differ');
end
if any(prod(na,2) ~= prod(nb,2))
    error('Mode sizes of a and b are inconsistent');
end

% Merge modes
a = cellfun(@(x)reshape(x, size(x,1)*size(x,2)*size(x,3), size(x,4)), a, 'UniformOutput', false);
b = cellfun(@(x)reshape(x, size(x,1), size(x,2)*size(x,3)*size(x,4)), b, 'UniformOutput', false);

% c will be of size ra x rb
c = 1;
for i = 1:d
    c = c*b{i};
    c = reshape(c, ra(i)*na(i,1)*na(i,2), rb(i+1));
    c = a{i}'*c;
end

end