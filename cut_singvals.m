function s = cut_singvals(singvals, opts)
% CUT_SINGVALS  Cut singular values according to supplied opts
%
%   s = CUT_SINGVALS(singvals, opts) cuts the singular values according to
%   a Frobenius norm threshold passed in the structure opts, either absolute
%   (if opts.abstol is present), or relative (for opts.reltol)

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE


s_abs = inf;
s_rel = inf;

sum_s = cumsum(singvals(end:-1:1).^2);
sum_s = sum_s(end:-1:1);
% sum_s are the squared norms of errors. sum_s(1) is the squared norm of
% the whole singvals

if opts.abstol    
    s_abs = find(sum_s<=opts.abstol^2, 1);
    s_abs = min([s_abs, numel(sum_s)]); % A short way to deal with possible empty s_abs
end
if opts.reltol
    s_rel = find(sum_s<=opts.reltol^2*sum_s(1), 1);
    s_rel = min([s_rel, numel(sum_s)]);
end
s = min([s_abs, s_rel, opts.maxrank, length(singvals)]);
end

