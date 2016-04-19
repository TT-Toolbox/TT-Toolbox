classdef tt
% TT   Tensor Train Matrix class/constructors
%   x = TT  returns an empty Tensor Train (of dimension 0).
%   x = TT(cores) creates a Tensor Train from a cell array of TT cores.
%   x = TT(A, tol) compresses a full tensor A with a tolerance tol.
%   x = TT(A, TruncOpts) compresses a full tensor A according to the
%       truncation options in the structure TruncOpts. See ROUND for
%       details.
%
%   See also: ROUND

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE


properties( SetAccess = public, GetAccess = public )
    %x.CORES   Core tensors (Public property)
    %   A d x 1 cell array of 4D tensors, each of dimension 
    %   r1 x n x m x r2. Warning: direct assignment x.cores = cores is
    %   allowed, but does not perform consistency check.
    cores      

    %x.ORTH   Non-orthogonality index (Public property)
    %   Denotes the position of a non-orthogonal TT core. 
    %   x.ORTH == 0 if x is not orthogonalized.
    %   Warning: direct assignment x.orth = orth is
    %   allowed, but does not perform consistency check.
    orth = 0;
end

% Dependent properties
properties( Dependent = true, SetAccess = private, GetAccess = public )
    %x.R   TT ranks (Dependent property)
    %   r = x.R  Returns a (d+1) x 1 array of TT ranks. Outputs a warning
    %   if TT cores have inconsistent ranks.
    r 

    %x.N   Mode sizes (Dependent property)
    %   n = x.N  Returns a d x 2 array of (internal) mode sizes.
    n 

    %x.D   Dimension (Dependent property)
    %   d = x.D  Returns the order of the TT tensor (1x1 integer).
    d 
end    

methods % for dependent props
    function [r] = get.r(x)
        % Here we need to extract both ranks and compare them to check for
        % consistency
        if (isempty(x.cores))
            r=0;
            return;
        end
        r = cellfun(@(x)size(x,1), x.cores);
        r2 = cellfun(@(x)size(x,4), x.cores);
        if any(r(2:end) ~= r2(1:end-1))
            warning('Inconsistent TT ranks in the core storage');
        end
        % Don't forget the last rank
        r = [r; r2(end)];
    end
    
    function [n] = get.n(x)
        % Extract the mode sizes
        if isempty(x.cores)
            n=[0 0]; % consistent with size([])
            return;
        end
        n = cellfun(@(x)size(x,2), x.cores);
        m = cellfun(@(x)size(x,3), x.cores);
        n = [n, m];
    end
    
    function [d] = get.d(x)
        % Dimension
        d = size(x.cores, 1);
    end
end

% All other methods
methods (Access = public)
    % Constructors
    function tt = tt(varargin)
        % Allow to return an empty tt
        if (nargin == 0)
            tt.cores = [];
            return;
        end
        % Populate tt with a cell of cores
        if (nargin == 1) && isa(varargin{1}, 'cell')
            tt.cores = varargin{1};
        end
    end
    
    %%%%%%%%% Other methods
    % Return the full size
    N = size(x);
    % Return a full matrix
    y = full(x);
    % Vectorize TT matrix to TT vector
    %y = vec(x);
    % Addition
    z = plus(x,y);
    x = uplus(x);
    % Subtraction
    z = minus(x,y);
    x = uminus(x);
    % Matrix product
    z = mtimes(x,y);
    % Hadamard product
    z = times(x,y);
    % Inner product
    z = dot(x,y,varargin);
    % Transpositions
    x = transpose(x);
    x = ctranspose(x);
    % Check for imaginary entries
    res = isreal(x);
    % Grumbling/extracting ordinary types
    [d,n,r,cores] = check_consistency(x);
    % TT-orth
    [x] = orthogonalize(x, idx);
    % Truncation
    [x] = round(x, TruncOpts);
    % Display
    disp(x, name);
    display(x);
    % Subtensor
    b = subtensor(a,istart,iend);
end

methods( Static, Access = public )
    % Create a tt with entries from uniform distribution
    x = rand(r, n);
    % Create a tt with entries from uniform distribution
    x = randn(r, n);
end

end
