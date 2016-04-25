function full_test()
% FULL_TEST   full test
%
%   See also: ROUND_TEST

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

disp('Performing full_test ...')
outcome = {'failed','successful'};

r1 = [1; 2; 3; 4; 1];
n = [4 1; 5 1; 6 1; 7 1];
x = tt.rand(r1, n);
cores = x.cores;

xf = full(x);
xf = reshape( xf, n(:,1)');

%check a few entries of the tensor
ind = [1 2 3 4; 4 2 3 3; 1 4 2 6];
for i = 1:size(ind,1)
    val_f(i) = xf(ind(i,1),ind(i,2),ind(i,3),ind(i,4));
    val(i) = squeeze(cores{1}(:,ind(i,1),:)).' * squeeze(cores{2}(:,ind(i,2),:)) ...
            * squeeze(cores{3}(:,ind(i,3),:)) * squeeze(cores{4}(:,ind(i,4),:));
end
success = norm(val_f - val) < 1e-15;

disp(['-> full_test ', outcome{success+1}, '.'])
end
