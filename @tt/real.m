function y = real(x)
% REAL   Returns the real part of a TT tensor
%
%   y = REAL(x) calculates the real part of the TT tensor x.
%   The resulting TT tensor y can have twice the rank of the original
%   tensor x.
%
%   See also: IMAG, ISREAL

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

% shortcut if no core of x contains any complex entries --> cannot be complex
if isreal(x)
    y = x;
    return;
end

[d,n,r,cores] = check_consistency(x);

% Put mode sizes together (see also plus function)
reshapefun = @(y) reshape(y,size(y,1), size(y,2)*size(y,3)*size(y,4));
Re = cellfun(@(y) real(reshapefun(y)), cores, 'UniformOutput', false);
Im = cellfun(@(y) imag(reshapefun(y)), cores, 'UniformOutput', false);

% First core -- horz. concat
Re{1} = [Re{1}, Im{1}];
Re{1} = reshape(Re{1}, r(1), n(1,1), n(1,2), 2*r(2));

% Inner cores -- Block matrix
for i = 2:d-1
    Re{i} = [Re{i}, Im{i}; -Im{i}, Re{i}];
    Re{i} = reshape(Re{i}, 2*r(i), n(i,1), n(i,2), 2*r(i+1));
end
% Last core -- vert. concat
Re{d} = [Re{d}; -Im{d}];
Re{d} = reshape(Re{d}, 2*r(d), n(d,1), n(d,2), r(d+1));

y = tt(Re);

end
