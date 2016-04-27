function [x] = blockkron(varargin)
% BLOCKKRON   "Horizontal" Kronecker product of TTs
%
%   x = BLOCKKRON(a,b,c,...) Block-by-block kron product of TT matrices,
%   the resulting tensor has the same dimension as all multipliers, and the
%   mode sizes equal to a product of mode sizes of multipliers.
%
%   Note: this operation multiplies TT ranks as well.
%   Note2: the kron product of blocks a{i}, b{i} is taken little-endian.
%
%   See also: TENSORKRON

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

if isa(varargin{1}, 'tt')
    [dx,nx,rx,x] = check_consistency(varargin{1});
    for i = 2:nargin
        if isa(varargin{i}, 'tt')
            [dy,ny,ry,y] = check_consistency(varargin{i});
            if dx ~= dy
                error('tt:DimensionMismatch','Dimension of input %d mismatches', i);
            end
            % Implement the block-by-block kron here
            x = cellfun(@(x)reshape(x, [], 1), x, 'UniformOutput', false);
            y = cellfun(@(x)reshape(x, 1, []), y, 'UniformOutput', false);
            for j = 1:dx
                x{j} = x{j}*y{j};
                x{j} = reshape(x{j}, rx(j), nx(j,1), nx(j,2), rx(j+1), ry(j), ny(j,1), ny(j,2), ry(j+1));
                x{j} = permute(x{j}, [1 5 2 6 3 7 4 8]);
                x{j} = reshape(x{j}, rx(j)*ry(j), nx(j,1)*ny(j,1), nx(j,2)*ny(j,2), rx(j+1)*ry(j+1));
            end
            % Update the sizes
            rx = rx.*ry;
            nx = nx.*ny;
        else
            error('tt:InputError', 'All inputs to blockkron should be tt')
        end
    end
else
    error('tt:InputError', 'All inputs to blockkron should be tt')
end

x = tt(x);
end