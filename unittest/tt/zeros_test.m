function zeros_test()
% ZEROS_TEST   zeros test
%
%   See also: RAND_TEST, RANDN_TEST, ONES_TEST

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

disp('Performing zeros_test ...')
outcome = {'failed','successful'};
success = false(4,1);

% test for strange inputs
try, tt.zeros([123,12;13,12], 1); catch ME, 
    if strcmp(ME.identifier,'tt:InputError') 
        success(1) = true; 
    end 
    disp(['------> rand_test 1 ', outcome{success(1)+1}, '.'])
end

try, tt.zeros([1;2;3;1], [4,5,2]); catch ME, 
    if strcmp(ME.identifier,'tt:InputError') 
        success(2) = true; 
    end 
    disp(['------> rand_test 2 ', outcome{success(2)+1}, '.'])
end
try, tt.zeros([1;2;3;1], [4,1;5,1]); catch ME, 
    if strcmp(ME.identifier,'tt:DimensionMismatch')
        success(3) = true; 
    end 
    disp(['------> rand_test 3 ', outcome{success(3)+1}, '.'])
end

% test for functionality
r = [1; 2; 3; 4; 1];
n = [5 6; 7 8; 9 10; 11 12];
x = tt.zeros(r, n);
if all(x.r == r) && all(x.n(:) == n(:))
    success(4) = true; 
end

disp(['-> zeros_test ', outcome{all(success)+1}, '.'])
end
