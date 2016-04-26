function B = tensorize( A, idx, sz )
% TENSORIZE Tensorize matrix (inverse matricization).
%   B = TENSORIZE(A, idx, sz) (re-)tensorizes the matrix A along the 
%   specified mode idx into a tensor B of size sz.
%   Tensorize is inverse matricization, that is, 
%       X == tensorize( matricize(X, idx), idx, size(X)) for all modes idx.
%
%   Note that tensorizations along the first and last mode are essentially free,
%   while the other modes require permutations of the array (expensive).
%
%   See also MATRICIZE, TENSORPROD, UNFOLD.
    
%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

ndim = length(sz);
% pad with 1 as Matlab likes to remove singleton dimensions
if ndim < idx
    sz = [sz, ones(1, idx-ndim)];
    ndim = length(sz);
end

switch idx
    case 1
        B = reshape( A, sz );
    case ndim 
        B = reshape( transpose(A), sz );
    otherwise
        remainder = [1:idx-1, idx+1:ndim];
        res = reshape( A, [sz(idx), sz(remainder)] );
        B = ipermute( res, [idx, remainder]); 
end

end
