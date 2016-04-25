function [y] = subtensor(x,istart,iend)
% SUBTENSOR   part of a tensor train
%
%   y = SUBTENSOR(x,istart,iend) returns TT cores of a from istart to iend
%   (inclusive)
%
%   See also: DOT

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

[d,~,~,y]=check_consistency(y);
if ~isscalar(istart) || round(real(istart)) ~= istart || istart < 1 || istart > d
    error('tt:InputError', 'Second argument must be a valid index between 1,...,x.d')
end
if ~isscalar(iend) || round(real(iend)) ~= iend || iend < 1 || iend > d
    error('tt:InputError', 'Third argument must be a valid index between 1,...,x.d')
end
y = y(istart:iend);
y = tt(y);

end
