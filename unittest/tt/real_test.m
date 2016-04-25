function image_test()
% REAL_TEST   real test
%
%   See also: IMAG_TEST

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

disp('Performing real_test ...')
outcome = {'failed','successful'};

r = [1; 3; 4; 5; 1];
n = [3 4; 4 5; 5 6; 6 7];
x = tt.rand(r, n);
y = tt.rand(r, n);
for i=1:4
    x.cores{i} = x.cores{i} + 1i*y.cores{i};
end
xf = full(x);
xf_re = real(xf);

x_re = real(x);
x_ref = full(x_re);

success = norm( xf_re(:) - x_ref(:) ) < 1e-11;

disp(['-> real_test ', outcome{success+1}, '.'])
end
