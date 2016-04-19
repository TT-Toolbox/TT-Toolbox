function [c] = dot(a,b,varargin)
% DOT   inner product
%
%   c = DOT(a,b) Inner product of two TT vectors (matrices are considered
%   as nm x 1 vectors)
%   c = DOT(a,b,dir,upto) Partial inner product over the cores from 1 to
%   upto if dir=='LR' and from d to upto (inclusive) if dir=='RL'
%
%   See also: MTIMES, TIMES, PLUS, MINUS, SUBTENSOR

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE


if numel(varargin)>=2
    % We have a partial dot product
    dir = varargin{1};
    upto = varargin{2};
    if ~isa(upto, 'double')
        error('The block index upto should be numeric');
    end
    
    if strcmpi(dir, 'lr')
        a = subtensor(a,1,upto);
        b = subtensor(b,1,upto);
    elseif strcmpi(dir,'rl')
        a = subtensor(a,upto,a.d);
        b = subtensor(b,upto,b.d);
    else
        error('dir should be either "lr" or "rl"');
    end
    
    c = dot(a,b);
    return;
end

[d,na,ra,a] = check_consistency(a);
[d2,nb,rb,b] = check_consistency(b);
if ( d~= d2 )
    error('Dimensions of a and b differ');
end
if any(prod(na,2) ~= prod(nb,2))
    error('Mode sizes of a and b are inconsistent');
end

if (ra(1)*rb(1) > 1) && (ra(d+1)*rb(d+1) > 1)
    % All border ranks are >1, dot product is inefficient anyway, use *
    warning('Both border ranks are not ones, using mtimes');
    % Merge modes
    a = cellfun(@(x)reshape(x, size(x,1), size(x,2)*size(x,3), 1, size(x,4)), a, 'UniformOutput', false);
    a = tt(a);
    b = cellfun(@(x)reshape(x, size(x,1), size(x,2)*size(x,3), 1, size(x,4)), b, 'UniformOutput', false);
    b = tt(b);
    
    c = squeeze(full(a'*b));
    return;
end

% Merge modes
a = cellfun(@(x)reshape(x, size(x,1)*size(x,2)*size(x,3), size(x,4)), a, 'UniformOutput', false);
b = cellfun(@(x)reshape(x, size(x,1), size(x,2)*size(x,3)*size(x,4)), b, 'UniformOutput', false);

c = 1; % c will be of size ra x rb

if ra(1)*rb(1) == 1
    % It's more efficient to multiply from the first block
    for i = 1:d
        c = c*b{i};
        c = reshape(c, ra(i)*na(i,1)*na(i,2), rb(i+1));
        c = a{i}'*c;
    end
elseif ra(d+1)*rb(d+1) == 1
    % It's more efficient to multiply from the last block
    for i = d:-1:1
        c = conj(a{i})*c;
        c = reshape(c, ra(i), na(i,1)*na(i,2)*rb(i+1));
        c = c*b{i}.';
    end    
end;

end