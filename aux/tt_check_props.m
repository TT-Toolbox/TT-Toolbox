function tt_check_props(obj,ref)
% TT_CHECK_PROPS
%
%   TT_CHECK_PROPS(obj,ref) accepts two structures, each consisting of at
%   least one the following set of possible fields:
%   full, cores, orth, nn, fmt, r, d, n, dd.
%   The function checks the fields provided in obj for
%   consistency with each other and with the fields provided in ref.
%   Specifically, the function goes through the fields of obj successively
%   once, in a particular order, For every field, it checks the value
%   against all fields of ref for consistency; in case of success, the
%   field is copied from obj into ref.

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE


% isfield(obj, 'd');    



end