function [N] = size(x)
% SIZE   Returns the size of the full matrix stored in TT format
%   [N] = SIZE(x) returns a 1x2 array of full column and row sizes of a TT
%   matrix.
%
%   See also: TT, TT.r, TT.n, TT.d

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

N = prod(x.n, 1);
end