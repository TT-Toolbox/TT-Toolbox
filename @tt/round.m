function x = round(x, opts)
% ROUND   Rounding procedure for TT tensor
%
%   y = ROUND(x, tol) approximates the TT tensor x by a tensor y with possibly
%   reduced ranks within the specified relative tolerance tol
%
%   y = ROUND(x, targetrank) approximates the TT tensor x by a tensor y with
%   specified target rank targetrank. 
%   targetrank is a (d+1)x1 array of integer numbers bigger than one. Note that
%   targetrank cannot be larger than x.r. 
%
%   y = ROUND(x, opts) allows a more fine-grained specification of the
%   truncation procedure. opts is a struct with the following fields:
%       opts.abstol     [double]        absolute tolerance for rank truncation
%       opts.reltol     [double]        relative tolerance for rank truncation
%       opts.maxrank    [integer]       every rank has to smaller than opts.maxrank
%       opts.rank       [(d+1)x1 array] Final target rank which is satisfied exactly
%                                       Note: cannot be used together with any
%                                       of the other three options.
%   See also: TT.orthogonalize, TT, TT.compress

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

[d,n,r,cores] = check_consistency(x);
% Check for opts:
%   -> single number: tolerance
%   -> vector: exact target rank
%   -> struct: opts structure
truncatetorank = false;
if (isscalar(opts)) && (isa(opts, 'double'))
    opts = struct('reltol',opts);
elseif isfloat(opts)
    opts = struct('rank', opts);
elseif isa(opts, 'struct') % that's ok
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
    if any(opts.rank > r)
        error('Rank truncation cannot increase the rank!')
    end
    truncatetorank = true;
end
if ~opts.abstol && ~opts.reltol && (opts.maxrank == inf) && ~truncatetorank
    error('Unknown struct in second argument. Specify at least one of the fields abstol, reltol or maxrank or specify a target rank using the field rank');
end
if (opts.abstol ~= false || opts.reltol ~= false) && truncatetorank
    error('Cannot have both tolerance-based rounding and exact target rank at the same time!')
end

% Divide tolerances by sqrt(d-1), otherwise the total error may be >tol
opts.abstol = opts.abstol/sqrt(d-1);
opts.reltol = opts.reltol/sqrt(d-1);

% Orthogonalize tensor either fully left- or right-orthogonal.
% We choose full left/right orthogonality based on which end is
% closer to the current point of orthogonality.
orth_pos = x.orth;
if ~orth_pos
    x = orthogonalize(x, d);
    orth_pos = d;
else
    if orth_pos < d/2 
        x = orthogonalize(x, 1);
        orth_pos = 1;
    else
        x = orthogonalize(x, d);
        orth_pos = d;
    end
end

% Orthogonalization may change cores and ranks, so get again
[d,n,r,cores] = check_consistency(x);
% Reshape cores to obtain column vector TT
cores = cellfun(@(x) reshape(x, [size(x,1), size(x,2)*size(x,3), size(x,4)]),...
            cores, 'UniformOutput', false);

if orth_pos == 1
    % Left-right sweep 
    for i = 1:d-1
        % SVD of left-unfolding
        leftunfold = reshape(cores{i}, [r(i)*n(i,1)*n(i,2), r(i+1)]);
        [U,S,V] = svd(leftunfold, 'econ');
        if ~truncatetorank
            % Tolerance-based truncation
            s = cut_singvals(diag(S), opts);
        else
            % Truncation to exact rank
            s = opts.rank(i+1);
        end
        U = U(:,1:s);
        V = V(:,1:s);
        S = S(1:s,1:s);
        % Truncated U is new ith core. Directly reshape to 4D array
        cores{i} = reshape( U, [r(i), n(i,1), n(i,2), s] );
        % Propagate non-orthogonality to (i+1)th core
        cores{i+1} = tensorprod( cores{i+1}, S*V', 1 );
        r(i+1) = s;
    end
    % Also reshape last core to 4D
    cores{d} = reshape( cores{d}, [r(d), n(d,1), n(d,2), r(d+1)] );
else
    % Right-left sweep 
    for i = d:-1:2
        % SVD of right-unfolding
        rightunfold = reshape(cores{i}, [r(i), n(i,1)*n(i,2)*r(i+1)]);
        [U,S,V] = svd(rightunfold, 'econ');
        if ~truncatetorank
            % Tolerance-based truncation
            s = cut_singvals(diag(S), opts);
        else
            % Truncation to exact rank
            s = opts.rank(i);
        end
        U = U(:,1:s);
        V = V(:,1:s);
        S = S(1:s,1:s);
        cores{i} = reshape(V', [s, n(i,1), n(i,2), r(i+1)]);
        % update (i-1)th core
        cores{i-1} = tensorprod(cores{i-1}, (U*S).', 3); 
        % Update the rank
        r(i) = s;
    end
    % Also reshape last core to 4D
    cores{1} = reshape(cores{1}, [r(1), n(1,1), n(1,2), r(2)]); 
end
x.cores = cores;
x.orth = d - orth_pos + 1;
end
