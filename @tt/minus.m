function [c] = minus(a, b)
% MINUS   Subtraction of TT tensors
%
%   c = MINUS(a,b) Subtracts two TT tensors or a TT tensor and a scalar,
%   replicated to all elements.
%
%   See also: TIMES, MTIMES, PLUS

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

c = a + (-1)*b;
end