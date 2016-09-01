function x = zeros(varargin)
% ZEROS   Creates a TT tensor with all-zero cores
%   x = ZEROS(r, n) returns a tensor with ranks r and mode sizes n such that each
%   core containes only zeros. Note that the specified rank only corresponds to
%   the sizes of the cores, not the real TT rank of x.
%
%   See also: TT.randn, TT.rand, TT.ones

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

r = varargin{1};
% Check r
if ~isnumeric(r)
    error('tt:InputError', 'Rank vector must be a numeric array')
end
r = double(r);
if any(r(:) ~= round(real(r(:)))) || any(r(:) < 1) || length(r) ~= numel(r)
    error('tt:InputError', 'Rank vector must be a vector of positive integers')
end

% Intepret the input
if (nargin < 3)
    % No format was specified
    % the second argument will be treated as the mode size n of the
    % decomposition to be constructed
    nn = varargin{2};
    % Check nn
    if ~isnumeric(nn)
        error('tt:InputError', 'Size array must be a numeric array')
    end
    nn = double(nn);
    d = size(nn, 1);
	dd = size(nn, 3);
    if any(nn(:) ~= round(real(nn(:)))) || any(nn(:) < 1) || size(nn, 2) ~= 2 || numel(nn) ~= d*2*dd
        error('tt:InputError', 'Size array is expected to have size [d 2 dd], where, for the decomposition to be constructed, d is the number of cores and dd is the number of row and column dimensions in each core, and to be composed of positive integers')
    end
else
    % The third argument is given, so it is treated as a format of the
    % decomposition to be constructed
    % The second argument will be treated as the mode size nfull of the
    % tensor to be constructed;
    % the mode size n of the decomposition to be constructed is defined by
    % nfull and fmt
    nfull = varargin{2};
    fmt = varargin{3};
    dfull = size(nfull, 1);
    d = size(fmt, 1);
    dd = size(fmt, 2);
    % Check nfull
    if ~isnumeric(nfull)
        error('tt:InputError', 'Size array must be a numeric array')
    end
    nfull = double(nfull);
    if any(nfull(:) ~= round(real(nfull(:)))) || any(nfull(:) < 1) || size(nfull, 2) ~= 2 || numel(nfull) ~= dfull*2
        error('tt:InputError', 'Size array must be a two-column matrix composed of positive integers')
    end
   % Check fmt
    if ~isnumeric(fmt)
        error('tt:InputError', 'Format array must be a numeric array')
    end
    fmt = double(fmt);
    if numel(fmt)~=d*dd
        error('tt:InputError', 'Format array is expected to be a matrix')
    end
    dimfull_ind = unique([0; fmt(:)]);
    if any(fmt(:) ~= round(real(fmt(:)))) || any(fmt(:) < 0) || any(fmt(:) > dfull) || ~isequal(dimfull_ind,(0:dfull)')
        error('tt:InputError', 'Format array is expected to have size [d dd]; the values should belong to (0:dfull); the set of positive values should be (1:dfull); the positive values should be distinct')
    end
    % Set nn
    nn = ones(d, 2, dd);
    for k = 1:d
        for kk = 1:dd
            if fmt(k,kk) == 0
                continue
            end
            nn(k,:,kk)=nfull(fmt(k,kk),:);
        end
    end
end

% Check r and n for compatibility
if numel(r) ~= d+1
    error('tt:DimensionMismatch', 'Rank vector has size incompatible with the number of cores specified by the other input arguments')
end
% Set n
n=prod(nn, 3);
% Generate cores
cores = cell(d, 1);
for i = 1:d
    cores{i} = zeros(r(i), n(i,1), n(i,2), r(i+1));
end

if (nargin < 3)
    x = tt(cores, nn);
else
    x = tt(cores, nn, fmt);
end

end
