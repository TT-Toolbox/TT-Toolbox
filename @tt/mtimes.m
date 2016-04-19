function [c]=mtimes(a,b,varargin)
% MTIMES   Matrix product
%
%   c = MTIMES(a,b) Matrix product of two TT matrices, or 
%       a product of a TT with a double matrix. 
%
%   See also: TIMES, PLUS, MINUS

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE


% tt*scalar
if isa(a,'tt') && isa(b,'double')
    c = a;
    c.cores{c.d} = tensorprod(c.cores{c.d}, b.', 4);
end

% scalar*tt
if isa(a,'double') && isa(b,'tt')
    c = b;
    c.cores{1} = tensorprod(c.cores{1}, a, 1);
end


% Matrix product
if isa(a,'tt') && isa(b,'tt')
    [d,na,ra,a] = check_consistency(a);
    [d2,nb,rb,b] = check_consistency(b);
    if ( d~= d2 )
        error('Dimensions of a and b differ');
    end
    if any(na(:,2) ~= nb(:,1))
        error('Mode sizes of a and b are inconsistent');
    end
    
    % Make nb the first mode in b
    c = cellfun(@(x)matricize(x, 2), b, 'UniformOutput', false);
    
    for i = 1:d
        c{i} = tensorprod(a{i}, c{i}.', 3);
        
        % Now the dimensions are ra1 x na x rb1*mb*rb2 x ra2
        % Permute into rb1*ra1 x na x mb x rb2*ra2
        c{i} = reshape(c{i}, ra(i), na(i,1), rb(i), nb(i,2)*rb(i+1)*ra(i+1));
        c{i} = permute(c{i}, [3,1,2,4]);
        c{i} = reshape(c{i}, rb(i)*ra(i), na(i,1), nb(i,2), rb(i+1)*ra(i+1));
    end
    
    c = tt(c);
end

end