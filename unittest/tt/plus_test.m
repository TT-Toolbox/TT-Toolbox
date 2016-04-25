function plus_test()
% PLUS_TEST   Addition test
%
%   See also: PLUS_TEST

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

disp('Performing plus_test ...')
outcome = {'failed','successful'};
success = false(2,1);

r1 = [1; 2; 3; 4; 1];
r2 = [1; 3; 4; 5; 1];
n = [4 5; 5 6; 6 7; 7 6];
x1 = tt.rand(r1, n);
x2 = tt.rand(r2, n);

y = x1 + x2;

x1px2 = full(x1) + full(x2);
yf = full(y);
success(1) = all(norm(x1px2(:) - yf(:)) < 1e-11);
disp(['------> plus_test 1 ', outcome{success(1)+1}, '.'])

% check for the case where outer ranks are not one
% (but they have to be the same)
r1 = [3; 2; 3; 4; 2];
r2 = [3; 3; 4; 5; 2];
x1 = tt.rand(r1, n);
x2 = tt.rand(r2, n);

y = x1 + x2;

x1px2 = full(x1) + full(x2);
yf = full(y);
success(2) = all(norm(x1px2(:) - yf(:)) < 1e-11);
disp(['------> plus_test 2 ', outcome{success(2)+1}, '.'])
disp(['-> plus_test ', outcome{all(success)+1}, '.'])
end
