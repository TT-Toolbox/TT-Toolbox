function [x] = tensorkron(varargin)
% TENSORKRON   "Vertical" Kronecker product of TTs
%
%   x = TENSORKRON(a,b,c,...) Standard kron product of TT matrices,
%   the resulting tensor has the dimension equal to the sum of dimensions
%   of multipliers.
%
%   Note: the dimensions are concatenated in the little-endian way, in
%   contrast to the classical Kronecker product, that is
%   full(tensorkron(a,b)) == kron(full(b), full(a))
%
%   See also: BLOCKKRON

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

if isa(varargin{1}, 'tt')
    [~,~,rx,x] = check_consistency(varargin{1});
    for i = 2:nargin
        if isa(varargin{i}, 'tt')
            [~,~,ry,y] = check_consistency(varargin{i});
            if ry(1) ~= rx(end)
                error('tt:DimensionMismatch','First rank of input %d differs from last rank of input %d', i, i-1);
            end
            x_new = [x; y];
            x = x_new;
            rx_new = [rx; ry(2:end)];
            rx = rx_new;
        else
            error('tt:InputError', 'All inputs to tensorkron should be tt')
        end
    end
else
    error('tt:InputError', 'All inputs to tensorkron should be tt')
end

x = tt(x);
end