function [c]=times(a,b,varargin)
% TIMES   Pointwise product
%
%   c = TIMES(a,b) Pointwise product of two TT matrices, or 
%       a TT with a scalar
%
%   See also: MTIMES, PLUS, MINUS

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE


% tt*scalar
if isa(a,'double') && isa(b,'tt')
    if numel(a) ~= 1
        error('a should be scalar');
    end
    % Now it's safe to call mtimes
    c = a*b;
    return;
end
if isa(a,'tt') && isa(b,'double')
    if numel(b) ~= 1
        error('b should be scalar');
    end
    % Now it's safe to call mtimes
    c = a*b;
    return;
end


% Hadamard product
if isa(a,'tt') && isa(b,'tt')
    [d,na,ra,a] = check_consistency(a);
    [d2,nb,rb,b] = check_consistency(b);
    if ( d~= d2 )
        error('Dimensions of a and b differ');
    end
    if any(na ~= nb)
        error('Mode sizes of a and b are inconsistent');
    end
    
    c = cellfun(@(x)reshape(x, size(x,1), []), b, 'UniformOutput', false);
    a = cellfun(@(x)reshape(x, [], size(x,4)), a, 'UniformOutput', false);
    
    for i = 1:d
        % Replicate b to match the multiplied ranks
        c{i} = repmat(c{i}, ra(i), ra(i+1)); % size rb1*ra1 x N*rb2*ra2
        c{i} = reshape(c{i}, rb(i)*ra(i), na(i,1), na(i,2), rb(i+1)*ra(i+1));
        
        % Replicate a. More nasty since it's little-endian now
        a{i} = a{i}.';
        a{i} = reshape(a{i}, 1, []);
        a{i} = repmat(a{i}, rb(i+1), 1); % size rb2 x ra2*ra1*N
        a{i} = reshape(a{i}, rb(i+1)*ra(i+1), ra(i)*na(i,1)*na(i,2));
        a{i} = a{i}.';
        a{i} = reshape(a{i}, 1, []);
        a{i} = repmat(a{i}, rb(i), 1); % size rb1 x ra1*N*rb2*ra2
        a{i} = reshape(a{i}, rb(i)*ra(i), na(i,1), na(i,2), rb(i+1)*ra(i+1));
        
        c{i} = c{i}.*a{i};
    end
    
    c = tt(c);
end

end