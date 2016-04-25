function norm_test()
% NORM_TEST   Norm test
%
%   See also: DOT_TEST

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

disp('Performing norm_test ...')
outcome = {'failed','successful'};
success = false(2,1);

% Try with tensor which has boundary ranks unequal to 1
r1 = [2; 2; 3; 4; 3];
n = [4 5; 5 6; 6 7; 7 6];
x = tt.rand(r1, n);
try, norm(x); catch ME, 
    if strcmp(ME.identifier,'tt:DimensionMismatch')
        success(1) = true; 
    end 
    disp(['------> norm_test 1 ', outcome{success(1)+1}, '.'])
end

% test computation
r1 = [1; 2; 3; 4; 1];
n = [4 5; 5 6; 6 7; 7 6];
x = tt.rand(r1, n);

res = norm(x);
res2 = sqrt(abs(dot(x,x)));

success(2) = all(abs(res - res2) < 1e-11);
disp(['------> norm_test 2 ', outcome{success(2)+1}, '.'])
disp(['-> dot_test ', outcome{all(success)+1}, '.'])
end
