function [c]=mpower(a,b)
% MPOWER   Matrix power
%
%   c = MPOWER(a,b) Raises a TT matrix a to an integer power b
%
%   See also: MTIMES, TIMES, PLUS, MINUS, MPOWER

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

if isa(a,'tt') && isscalar(b) && (round(b) == b) && (b >= 0)
    c = tt.ones(a.n);
    for i = 1:b
        c = c*a;
    end
else
    error('tt:InputError', 'a must be TT and b must be an integer>=0');
end

end