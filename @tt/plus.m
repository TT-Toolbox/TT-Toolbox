function [c] = plus(a, b)
% PLUS   Addition of TT tensors
%
%   c = PLUS(a,b) Sums two TT tensors or a TT tensor and a scalar,
%   replicated to all elements.
%
%   See also: TIMES, MTIMES, MINUS

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE


% tt+scalar = tt+scalar*ones
if isa(a,'tt') && isa(b,'double')
    if numel(b) ~= 1
        error('b should be scalar')
    end
    c = a + b*tt.ones(a.n);
end

% scalar+tt = tt+scalar*ones
if isa(a,'double') && isa(b,'tt')
    if numel(a) ~= 1
        error('a should be scalar')
    end
    c = a*tt.ones(b.n) + b;
end

% tt+tt
if isa(a,'tt') && isa(b,'tt')
    [d,na,ra,a] = check_consistency(a);
    [d2,nb,rb,b] = check_consistency(b);
    if ( d~= d2 )
        error('Dimensions of a and b differ');
    end
    if any(na ~= nb)
        error('Mode sizes of a and b are inconsistent');
    end
    if (ra(1) ~= rb(1)) || (ra(d+1) ~= rb(d+1))
        error('Border ranks of a and b differ');
    end
    
    % Put mode sizes together
    c = cellfun(@(x)reshape(x, size(x,1), size(x,2)*size(x,3)*size(x,4)), a, 'UniformOutput', false);
    b = cellfun(@(x)reshape(x, size(x,1), size(x,2)*size(x,3)*size(x,4)), b, 'UniformOutput', false);
    
    % First core -- horz concat
    c{1} = [c{1}, b{1}];
    c{1} = reshape(c{1}, ra(1), na(1,1), na(1,2), ra(2) + rb(2));
    % Inner cores -- diag concat
    for i = 2:d-1
        c{i} = blkdiag(c{i}, b{i});
        c{i} = reshape(c{i}, ra(i) + rb(i), na(i,1), na(i,2), ra(i+1) + rb(i+1));
    end
    % Last core -- vert concat
    c{d} = [c{d}; b{d}];
    c{d} = reshape(c{d}, ra(d) + rb(d), na(d,1), na(d,2), ra(d+1));
    
    c = tt(c);
end

end
