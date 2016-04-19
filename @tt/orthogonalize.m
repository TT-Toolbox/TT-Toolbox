function x = orthogonalize(x, mu)
% ORTHOGONALIZE   Orthogonalize the internal representation of a TT tensor.
%
%   y = ORTHOGONALIZE(x, mu) mu-orthogonalizes the TT tensor x such that
%   its cores U(1)...U(mu-1) are left- and U(mu+1)...U(d) are right-orthogonal.
%   The non-orthogonality of x is then contained in its mu-th core U(mu).
%

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

[d,n,r,cores] = check_consistency(x);
orth_pos = x.orth;

if ~isscalar(mu)
    error('Second argument must be a scalar value')
else
    if round(real(mu)) ~= mu || mu < 1 || mu > d
        error('Second argument must be a valid index between 1,...x.d')
    end
end

start_pos = 1;
end_pos = d;
if mu == orth_pos
    % Tensor is already mu-orthogonal
    return;
elseif orth_pos < mu
    % First cores up to orthpos-1 are already left-orth. Use this information!
    start_pos = max(orth_pos, 1);
elseif orth_pos > mu;
    % Last cores down to orthpos+1 are already right-orth. Use this information!
    end_pos = min(orth_pos, d);
end

% Reshape cores to obtain column vector TT
cores = cellfun(@(x) reshape(x, [size(x,1), size(x,2)*size(x,3), size(x,4)]),...
            cores, 'UniformOutput', false);
N = prod(n, 2);

newrank_left = r(1);
newrank_right = r(end);
% Left orthogonalize up to position mu (from left)
for i = start_pos:mu-1
    % QR of left-unfolding
    leftunfold = reshape(cores{i}, [r(i)*N(i), r(i+1)]);
    [Q,R] = qr(leftunfold, 0);
    newrank_left = size(Q,2);
    % ith core is now left-orth (and reshaped to 4D-array):
    cores{i} = reshape(Q, [r(i), n(i,1), n(i,2), newrank_left]);
    % update (i+1)th core
    cores{i+1} = tensorprod(cores{i+1}, R, 1); 
    % Update the rank
    r(i+1) = newrank_left;
end

% Right orthogonalization till position mu (from right)
for i = end_pos:-1:mu+1
    % QR of (transposed) right-unfolding
    rightunfold_T = reshape(cores{i}, [r(i), N(i)*r(i+1)]).';
    [Q,R] = qr(rightunfold_T, 0);
    newrank_right = size(Q,2);
    % ith core is now right-orth (and reshaped to 4D-array):
    cores{i} = reshape(Q.', [newrank_right, n(i,1), n(i,2), r(i+1)]);
    % update (i-1)th core
    cores{i-1} = tensorprod(cores{i-1}, R, 3); 
    % Update the rank
    r(i) = newrank_right;
end

cores{mu} = reshape(cores{mu}, [newrank_left, n(mu,1), n(mu,2), newrank_right]); 

x.cores = cores;
x.orth = mu;

end
