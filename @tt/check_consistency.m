function [d,n,r,cores] = check_consistency(x)
% CHECK_CONSISTENCY   Checks the consistency of TT cores. 
%   [d,n,r,cores] = CHECK_CONSISTENCY(x) checks the consistency of the TT
%   storage and returns d,n,r and cores if the storage was consistent.
%   Otherwise throws an error.
%
%   See also: TT

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

cores = x.cores;
% Check for an empty tt
if isempty(cores)
    d = size(x.cores, 1);
    n = [0 0];
    r = 0;
    return;
end
if any(cellfun(@(x)ndims(x), cores) > 4)
    error('tt:DimensionMismatch','Some TT cores have ndims>4');
end

r = cellfun(@(x)size(x,1), cores);
r2 = cellfun(@(x)size(x,4), cores);
if any(r(2:end) ~= r2(1:end-1))
    error('tt:DimensionMismatch','Inconsistent TT ranks in the core storage');
end
r = [r; r2(end)];

n = x.n;
d = x.d;

end
