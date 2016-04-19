function [x] = ctranspose(x)
% CTRANSPOSE   Complex transpose
%
%   y = CTRANSPOSE(x) Hermitian conjugation of the TT matrix
%
%   See also: TRANSPOSE

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE


x.cores = cellfun(@(x)conj(permute(x,[1,3,2,4])), x.cores, 'UniformOutput', false);

end