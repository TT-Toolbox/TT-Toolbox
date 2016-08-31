function x = zeros(r, n, fmt)
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

% Check r
if ~isnumeric(r)
    error('tt:InputError', 'Rank vector must be a numeric array')
end
r = double(r);
if any(r(:) ~= round(real(r(:)))) || any(r(:) < 1) || length(r) ~= numel(r)
    error('tt:InputError', 'Rank vector must be a vector of positive integers')
end

% Check n
if ~isnumeric(n)
    error('tt:InputError', 'Size array must be a numeric array')
end
n = double(n);

if any(n(:) ~= round(real(n(:)))) || any(n(:) < 1) || size(n,2) ~= 2
    error('tt:InputError', 'Size array must be composed of positive integers and have size 2 along the second dimension')
end

% Intepret n
if (nargin < 3)
    % No format was specified
    % n will be treated as the mode size of the decomposition to be
    % constructed
    d = size(n,1);
	D = size(n,3);
    % Check n
    if numel(n)~=d*2*D
        error('tt:InputError', 'Size array is expected to have size [d 2 D], where, for the decomposition to be constructed, d is the number of cores and D is the number of row and column dimensions in each core')
    end
    % Set default format
    fmt = reshape(1:d*D,[D d])';
else
    % A format is specified
    % n will be treated as the mode size of the tensor to be constructed;
    % the mode size of the decomposition to be constructed is defined by n
    % and fmt
    nfull=n;
    dfull = size(nfull,1);
    % Check n
    if numel(nfull) ~= dfull*2
        error('tt:InputError', 'Size array is expected to be a two-column matrix')
    end
    % Check fmt
    if ~isnumeric(fmt)
        error('tt:InputError', 'Format array must be a numeric array')
    end
    fmt = double(fmt);
    d = size(fmt,1);
    D = size(fmt,2);
    if numel(fmt)~=d*D
        error('tt:InputError', 'Format array is expected to be a matrix')
    end
    dimfull_ind = unique([0; fmt(:)]);
    if any(fmt(:) ~= round(real(fmt(:)))) || any(fmt(:) < 0) || any(fmt(:) > dfull) || ~isequal(dimfull_ind,(0:dfull)')
        error('tt:InputError', 'Let, for the tensor to be constructed, dfull be the total number of row dimensions (=the total number of row dimensions). Let, for the decomposition to be constructed, d be the number of cores and D be the number of row and column dimensions in each core. Format array is expected to have size [d D] and to consist of nonnegative integers, exactly dfull of them being positive. The positive values should be distinct and belong to the set (1:dfull)')
    end
    % Set n
    n = ones([d 2 D]);
    for k = 1:d
        for K = 1:D
            if fmt(k,K) == 0
                continue
            end
            n(k,:,K)=nfull(fmt(k,K),:);
        end
    end
end

% Check r and n for compatibility
if numel(r) ~= d+1
    error('tt:DimensionMismatch', 'Rank vector has size incompatible with the number of cores specified by the other input arguments')
end
% Merge the subdimensions
n=prod(n,3);
% Generate cores
cores = cell(d, 1);
for i = 1:d
    cores{i} = zeros(r(i), n(i,1), n(i,2), r(i+1));
end
x = tt(cores);
x.fmt = fmt;
end
