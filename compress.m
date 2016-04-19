function [x] = compress(A, opts, n)
% COMPRESS   Compress full data into a TT tensor
%
%   x = COMPRESS(A, tol) approximates a full array A by a tt x with a
%   relative truncation tolerance tol. Any tt tensor is stored as a tt
%   matrix, hence the first half of dimensions of A are considered as the
%   rows of this matrix, the second half of dimensions becomes the columns
%
%   x = COMPRESS(A, targetrank) approximates a full array A by a tt tensor x with
%   specified target rank targetrank. 
%   targetrank is a (d+1)x1 array of integer numbers bigger than one. Note that
%   targetrank cannot be larger than x.r. 
%
%   x = COMPRESS(A, opts) allows a more fine-grained specification of the
%   truncation procedure. opts is a struct with the following fields:
%       opts.abstol     [double]        absolute tolerance for rank truncation
%       opts.reltol     [double]        relative tolerance for rank truncation
%       opts.maxrank    [integer]       every rank has to smaller than opts.maxrank
%       opts.rank       [(d+1)x1 array] Final target rank which is satisfied exactly
%                                       Note: cannot be used together with any
%                                       of the other three options.
%
%   x = COMPRESS(A, opts, n) reshapes A to the mode sizes given in a d x 2
%   array n, then proceeds as previously described.
%
%   x = COMPRESS(A) uses the absolute tolerance eps(norm(A,'fro'))
%   (consistent with ordinary SVD-based rank and pinv commands)

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE


% Check if the mode sizes are given
if (nargin > 2) && (~isempty(n))
    A = reshape(A, n(:)');
end

% Determine mode sizes from A. This is nasty since Matlab swallows all
% tail singletons...
n = size(A);
% ... in particular, if ndims is odd, we have to add "1" explicitly
if mod(numel(n), 2) == 1
    n = [n, 1];
end
d = numel(n)/2;
n = reshape(n, d, 2);
A = ipermute(A, [1:2:2*d-1, 2:2:2*d]);
% Now A has dimensions n1,m1,n2,m2,...

% Check for opts:
%   -> single number: tolerance
%   -> vector: exact target rank
%   -> struct: opts structure
if (nargin < 2) || (isempty(opts))
    opts = struct('abstol', eps(norm(A(:))));
end
truncatetorank = false;
if (isscalar(opts)) && (isa(opts, 'double'))
    opts = struct('reltol',opts);
elseif isfloat(opts)
    opts = struct('rank', opts);
elseif isa(opts, 'struct')
else
    error('Error in second argument. Specify either a scalar (rel. tol), a rank vector or a struct')
end
if ~isfield(opts, 'abstol'),    opts.abstol  = false;   end
if ~isfield(opts, 'reltol'),    opts.reltol  = false;   end
if ~isfield(opts, 'maxrank'),   opts.maxrank = inf;     end
if isfield(opts, 'rank')
    if size(opts.rank) ~= size(r)
        error('Error in option struct: opts.rank is not of size(x.r)') 
    end
    if any(opts.rank ~= round(real(opts.rank))) || any(opts.rank < 1) 
        error('Rank vector must be an integer vector with all values bigger or equal than one')
    end
    truncatetorank = true;
end
if ~opts.abstol && ~opts.reltol && (opts.maxrank == inf) && ~truncatetorank
    error('Unknown struct in second argument. Specify at least one of the fields abstol, reltol or maxrank or specify a target rank using the field rank');
end
if (opts.abstol ~= false || opts.reltol ~= false) && truncatetorank
    error('Cannot have both tolerance-based rounding and exact target rank at the same time!')
end

% Finally, start compression
x = cell(d, 1);
s_prev = 1; % the previous rank, r(i)
for i = 1:d-1
    A = reshape(A, s_prev*n(i,1)*n(i,2), []);
    [U,S,V] = svd(A, 'econ');
    % Truncate according to either strategy
    if ~truncatetorank
        % Tolerance-based truncation
        s = cut_singvals(diag(S), opts);
    else
        % Truncation to exact rank
        s = opts.rank(i+1);
        if (s>min(size(A)))
            error('Rank truncation cannot increase the rank!')
        end
    end
    
    U = U(:,1:s);
    V = V(:,1:s);
    S = S(1:s,1:s);
    x{i} = reshape(U, s_prev, n(i,1), n(i,2), s);
    A = S*V'; % the size is s*remaining_ns
    s_prev = s;
end
x{d} = reshape(A, s_prev, n(d,1), n(d,2), 1);
x = tt(x);
x.orth = d;

end