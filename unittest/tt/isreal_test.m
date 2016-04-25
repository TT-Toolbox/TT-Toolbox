function isreal_test()
% ISREAL_TEST   isreal test
%
%   See also: REAL_TEST, IMAG_TEST

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

disp('Performing isreal_test ...')
outcome = {'failed','successful'};

r = [1; 2; 3; 4; 1];
n = [5 6; 7 8; 9 10; 11 12];
x = tt.rand(r, n);
x.cores{3} = 3i*x.cores{3};

success = ~isreal(x);

disp(['-> isreal_test ', outcome{success+1}, '.'])
end
