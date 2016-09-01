classdef tt
% TT   Tensor Train Matrix class/constructors
%   x = TT  returns an empty Tensor Train (of dimension 0).
%   x = TT(cores) creates a Tensor Train from a cell array of TT cores.
%   x = TT(A) compresses a full tensor A with a tolerance max(n*m)*eps(norm(A))
%   x = TT(A, tol) compresses a full tensor A with a tolerance tol.
%   x = TT(A, TruncOpts) compresses a full tensor A according to the
%       truncation options in the structure TruncOpts. See ROUND for
%       details.
%   x = TT(A, TruncOpts, n) compresses a full tensor A, reshaping it
%       according to the d x 2 array of mode sizes n
%
%   See also: TT.ROUND, TT.COMPRESS

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
    %x.R   TT ranks of the decomposition (Dependent property)
    %   r = x.R  Returns a (d+1) x 1 array of TT ranks. Outputs a warning
    %   if TT cores have inconsistent ranks.
    r

    %x.D   Number of cores of the decomposition (Dependent property)
    %   d = x.D  Returns the number of cores (1x1 integer).
    d

    %x.N   Mode sizes of the decomposition (Dependent property)
    %   n = x.N  Returns an array of the mode sizes of the decomposition (dx2xdd integer).
    n

    %x.dd   Number of mode indices per core (Public/private property)
    %   dd = x.DD  Returns the number of mode indices represented by each of the row and columns indices of each core (1x1 integer).
    dd

    %x.DFULL   Number of indices of row (and column) indices in the represented tensor
    %   dfull = x.DFULL  Returns the number of row (and column) indices in the represented tensor (1x1 integer).
    dfull

    %x.NFULL   Mode sizes of the represented tensor (Dependent property)
    %   nfull = x.NFULL  Returns the mode size of the represented tensor (dfullx2 integer).
    nfull
end    

properties( SetAccess = private, GetAccess = public )
    
    nn

    %x.FMT   Format of the decomposition (Public/private property)
    %   An array of integers of size dxdd; the values belong to
    %   (0:dfull); the set of positive values is (1:dfull); the positive
    %   values are distinct.
    %   Encodes the format of the decomposition, namely the way the mode
    %   indices of the decomposition are mapped into the indices of the
    %   represented tensor
    %
    fmt = [];
end

methods % for dependent props
    function [r] = get.r(x)
        if (isempty(x.cores))
            r=0;
            return;
        end
        % For each core, extract both ranks
        r = cellfun(@(x)size(x,1), x.cores);
        r2 = cellfun(@(x)size(x,4), x.cores);
        % Check the ranks for consistency
        if any(r(2:end) ~= r2(1:end-1))
            warning('Inconsistent TT ranks in the core storage');
        end
        % Assemble a complete array of ranks
        r = [r; r2(end)];
    end
    
    function [d] = get.d(x)
        % Number of cores of the decomposition
        d = size(x.cores, 1);
    end
    
    function [n] = get.n(x)
%TODO change to prod(x.nn,3)
        % Mode sizes of the decomposition
        if isempty(x.cores)
            n=[0 0]; % consistent with size([])
            return;
        end
        n = cellfun(@(x)size(x,2), x.cores);
        m = cellfun(@(x)size(x,3), x.cores);
        n = [n, m];
    end
    
    function [dd] = get.dd(x)
        % Number of mode indices per core
        dd = size(x.nn, 3);
    end
    
    function [dfull] = get.dfull(x)
        % Number of indices of row (and column) indices in the represented tensor
    end
    
    function [nfull] = get.nfull(x)
        % Mode sizes of the represented tensor
    end

end

% All other methods
methods (Access = public)
    % Constructors
    function tt = tt(varargin)
        % Allow to return an empty tt
        if (nargin == 0)
            tt.cores = [];
        end
        % Populate tt with a cell of cores
        if (nargin >= 1) && isa(varargin{1}, 'cell')
%TODO             check nn, fmt, check the cores for consistency
            tt.cores = varargin{1};
            if (nargin < 2)
                nn = [cellfun(@(x)size(x,2), tt.cores) cellfun(@(x)size(x,3), tt.cores)];
            else
                nn = varargin{2};
            end
            d = size(nn, 1);
            dd = size(nn, 3);
            if (nargin < 3)
                fmt = reshape(1:d*dd, [dd d])';
            else
                fmt = varargin{3};
            end
            tt.nn = nn;
            tt.fmt = fmt;
        end
        % Compress a full array
        if (nargin >= 1) && isa(varargin{1}, 'double')
            tt = tt.compress(varargin{:});
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
    % Norm
    res = norm(x);
    % Transpositions
    x = transpose(x);
    x = ctranspose(x);
    % Check for imaginary entries
    res = isreal(x);
    % Return real/imaginary parts
    y = real(x);
    y = imag(x);
    % Grumbling/extracting ordinary types
    [d,n,r,cores] = check_consistency(x);
    % TT-orth
    x = orthogonalize(x, idx);
    % Truncation to tolerance or exact target rank
    x = round(x, truncOpts);
    % Display
    disp(x, name);
    display(x);
    % Subtensor
    b = subtensor(a,istart,iend);
end

methods( Static, Access = public )
    % Create a tt with random entries distributed uniformly in [0,1]
    x = rand(r, n);
    % Create a tt with random entries distributed normally with zero mean
    % and unit variance
    x = randn(r, n);
    % Create a tt with all zeros as cores 
    x = zeros(r, n);
    % Create a tt with all ones as cores 
    x = ones(n);
    % Compress a full array into TT
    x = compress(A, opts, n);
end

end
