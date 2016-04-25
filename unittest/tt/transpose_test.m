function transpose_test()
% TRANSPOSE_TEST   Transpose test
%
%   See also: CTRANSPOSE_TEST

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

disp('Performing transpose_test ...')
outcome = {'failed','successful'};

r = [1; 2; 3; 4; 1];
n = [5 6; 7 8; 9 10; 11 12];
x = tt.rand(r, n);
xt = transpose(x);

xf = full(x);
xft = full(xt).';
success = all(xf(:) == xft(:));

disp(['-> transpose_test ', outcome{success+1}, '.'])
end
