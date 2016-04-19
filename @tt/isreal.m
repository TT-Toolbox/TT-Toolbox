function res = isreal(x)
% ISREAL   Checks if the cores of the TT tensor have complex entries
%   res = ISREAL(x) returns true if none of the cores of the TT tensor
%   has complex entries.
%
%   See also: CTRANSPOSE

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

[~,~,~,cores] = check_consistency(x);
res = all(cellfun(@(y) isreal(y), x);
end
