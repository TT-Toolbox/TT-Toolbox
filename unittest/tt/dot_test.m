function dot_test()
% DOT_TEST   dot product test
%
%   See also: PLUS_TEST

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

disp('Performing dot_test ...')
outcome = {'failed','successful'};
success = false(7,1);

r1 = [1; 2; 3; 4; 1];
r2 = [1; 3; 4; 5; 1];
n = [4 1; 5 1; 6 1; 7 1];
x = tt.rand(r1, n);
y = tt.rand(r2, n);


% test for strange inputs
try, dot(x, 1); catch ME, 
    if strcmp(ME.identifier,'tt:InputError') 
        success(1) = true; 
    end 
    disp(['------> dot_test 1 ', outcome{success(1)+1}, '.'])
end
try, dot(x, y, 1); catch ME, 
    if strcmp(ME.identifier,'tt:InputError') 
        success(2) = true; 
    end 
    disp(['------> dot_test 2 ', outcome{success(2)+1}, '.'])
end
try, dot(x, y, 'asdasd', 1); catch ME, 
    if strcmp(ME.identifier,'tt:InputError')
        success(3) = true;
    end 
    disp(['------> dot_test 3 ', outcome{success(3)+1}, '.'])
end
try, dot(x, y, 'lr', 10); catch ME, 
    if strcmp(ME.identifier,'tt:InputError')
        success(4) = true;
    end 
    disp(['------> dot_test 4 ', outcome{success(4)+1}, '.'])
end

% test the computation
xf = full(x);
yf = full(y);
res = dot(x,y);
success(5) = all(abs(res - dot(xf,yf)) < 1e-11);
disp(['------> dot_test 5 ', outcome{success(5)+1}, '.'])

% check for the case where outer ranks are not one
% (but they have to be the same)
r1 = [1; 2; 3; 4; 3];
r2 = [1; 3; 4; 5; 3];
x = tt.rand(r1, n);
y = tt.rand(r2, n);
xf = squeeze(full(x));
yf = squeeze(full(y));

res = dot(x,y);
res2 = xf.'*yf;

success(6) = all(norm(res(:) - res2(:)) < 1e-11);
disp(['------> dot_test 6 ', outcome{success(6)+1}, '.'])

r1 = [3; 2; 3; 4; 1];
r2 = [3; 3; 4; 5; 1];
x = tt.rand(r1, n);
y = tt.rand(r2, n);
xf = full(x);
yf = full(y);

res = dot(x,y);
res2 = xf*yf.';

success(7) = all(norm(res(:) - res2(:)) < 1e-11);
disp(['------> dot_test 7 ', outcome{success(7)+1}, '.'])

disp(['-> dot_test ', outcome{all(success)+1}, '.'])
end
