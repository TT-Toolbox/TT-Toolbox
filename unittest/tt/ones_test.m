function ones_test()
% ONES_TEST   ones test
%
%   See also: RANDN_TEST, RAND_TEST, ZEROS_TEST

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

disp('Performing ones_test ...')
outcome = {'failed','successful'};
success = false(2,1);

% test for strange inputs
try, tt.ones([123,-1;13,12]); catch ME, 
    if strcmp(ME.identifier,'tt:InputError') 
        success(1) = true; 
    end 
    disp(['------> rand_test 1 ', outcome{success(1)+1}, '.'])
end

% test for functionality
n = [5 6; 7 8; 9 10; 11 12];
x = tt.ones(n);
if all(x.r == ones(5,1)) && all(x.n(:) == n(:))
    success(2) = true; 
end

disp(['-> ones_test ', outcome{all(success)+1}, '.'])
end
