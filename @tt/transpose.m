function [x] = transpose(x)
% TRANSPOSE   Transpose
%
%   y = TRANSPOSE(x) Transposition of the TT matrix
%
%   See also: CTRANSPOSE

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

x.cores = cellfun(@(x)permute(x,[1,3,2,4]), x.cores, 'UniformOutput', false);

end