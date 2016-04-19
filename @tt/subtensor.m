function [b] = subtensor(a,istart,iend)
% SUBTENSOR   part of a tensor train
%
%   b = SUBTENSOR(a,istart,iend) returns TT cores of a from istart to iend
%   (inclusive)
%
%   See also: DOT

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

[d,~,~,b]=check_consistency(a);
if (istart<1) || (istart>d) || (iend<1) || (iend>d)
    error('istart and iend should be in a range from 1 to d');
end
b = b(istart:iend);
b = tt(b);

end