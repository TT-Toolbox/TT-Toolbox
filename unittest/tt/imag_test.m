function imag_test()
% IMAG_TEST   imag test
%
%   See also: REAL_TEST

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

disp('Performing imag_test ...')
outcome = {'failed','successful'};

r = [1; 3; 4; 5; 1];
n = [3 4; 4 5; 5 6; 6 7];
x = tt.rand(r, n);
y = tt.rand(r, n);
for i=1:4
    x.cores{i} = x.cores{i} + 1i*y.cores{i};
end
xf = full(x);
xf_im = imag(xf);

x_im = imag(x);
x_imf = full(x_im);

success = norm( xf_im(:) - x_imf(:) ) < 1e-11;

disp(['-> imag_test ', outcome{success+1}, '.'])
end
