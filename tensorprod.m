function B = tensorprod(A, X, idx)
% TENSORPROD   Tensor-times-Matrix product. 
%   B = TENSORPROD(A, X, idx) performs the product between the
%   tensor A and matrix X along the mode idx. 
%
%   TENTATIVE VERSION
%
%   See also MATRICIZE, TENSORIZE, UNFOLD.
    
%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

sz = size(A);
ndim = length(sz);
% pad with 1 as Matlab likes to remove singleton dimensions
if ndim < idx
    sz = [sz, ones(1, idx-ndim)];
end

res = X * matricize(A, idx);

sz(idx) = size(res, 1);

B = tensorize(res, idx, sz);

end
