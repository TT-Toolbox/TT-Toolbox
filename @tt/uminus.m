function [x] = uminus(x)
% UMINUS   Unary negation of a TT tensor
%
%   See also: TIMES, MTIMES, PLUS, MINUS

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

x = (-1)*x;
end