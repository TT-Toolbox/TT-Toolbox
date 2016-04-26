function B = matricize(A, idx)
% MATRICIZE   Matricize Matlab array. 
%   B = MATRICIZE(A, idx) matricizes the Matlab array A along the 
%   specified mode idx, 
%   Note that matricizations along the first and last mode are essentially free,
%   while the other modes require permutations of the array (expensive).
%
%   See also TENSORIZE, TENSORPROD, UNFOLD.
    
%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

d = size(A);
ndim = length(d);
% pad with 1 as Matlab likes to remove singleton dimensions
if ndim < idx
    d = [d, ones(1, idx-ndim)];
    ndim = length(d);
end

switch idx
    case 1
        B = reshape(A, [d(1), prod(d(2:end))]);
    case ndim;
        B = reshape(A, [prod(d(1:end-1)), d(end)]).';
    otherwise
        remainder = [1:idx-1, idx+1:ndim];
        res = permute(A, [idx, remainder]); 
        B = reshape(res, [d(idx), prod(d(remainder))]);
end

end
