function ctranspose_test()
% CTRANSPOSE_TEST   Complex transpose test
%
%   See also: TRANSPOSE_TEST

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

disp('Performing ctranspose_test ...')
outcome = {'failed','successful'};

r = [1; 2; 3; 4; 1];
n = [5 6; 7 8; 9 10; 11 12];
x = tt.rand(r, n);
x.cores{3} = 1i*x.cores{3}+x.cores{3};
xt = x';

xf = full(x);
xft = full(xt)';
success = all(xf(:) == xft(:));

disp(['-> transpose_test ', outcome{success+1}, '.'])
end
