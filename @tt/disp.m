function disp(x, name)
% DISP   Display the tensor train as a tensor network
%
%   See also: DISPLAY

%   TT-Toolbox
%   Copyright: TT-Toolbox team, 2016
%   http://github.com/TT-Toolbox/TT-Toolbox
%   BSD 2-clause license, see LICENSE

if (nargin < 2 || ~ischar(name))
  name = inputname(1);
end

[d,n,r,~] = check_consistency(x);
orth = x.orth;
if orth == 0
    head = [name, ' is a non-orth. ']; 
else
    head = [name, ' is a ', num2str(orth), '-orth. '];
end

sz = size(x);

if all(n(:,2) == 1)
    % column vector case
    disp([head, num2str(sz(1)) 'x' num2str(sz(2)), ...
                ' TT column vector of order ', num2str(d), ...
                ' with inner modes (', num2str(n(:,1).'), '),']);
    disp(['ranks (', num2str(r'), ') and cores']);
    disp(' ')

    row0 = '';
    row1 = '';
    row2 = '';

    for i=1:d
        row0 = [row0, sprintf('%3i--(U%2i)--', r(i), i)];
        row1 = [row1, '       |    '];
        row2 = [row2, sprintf('     %3i    ', n(i,1))];  
    end
    row0 = [row0, sprintf( '%3i', r(end))]; 
    disp(row0)
    disp(row1)
    disp(row2)

elseif all(n(:,1) == 1)
    % row vector case
    disp([head, num2str(sz(1)) 'x' num2str(sz(2)), ...
                ' TT row vector of order ', num2str(d), ...
                ' with inner modes (', num2str(n(:,2).'), '),']);
    disp(['ranks (', num2str(r'), ') and cores']);
    disp(' ')

    row0 = '';
    row1 = '';
    row2 = '';

    for i=1:d
        row0 = [row0, sprintf('     %3i    ', n(i,2))]; 
        row1 = [row1, '       |    '];
        row2 = [row2, sprintf('%3i--(U%2i)--', r(i), i)];
    end
    row2 = [row2, sprintf( '%3i', r(end))]; 
    disp(row0)
    disp(row1)
    disp(row2)
else
    % matrix case 
    disp([head, num2str(sz(1)) 'x' num2str(sz(2)), ... 
                ' TT matrix of order ', num2str(d), ...
                ' with inner row modes (', num2str(n(:,1).'),...
                '), column modes (', num2str(n(:,2).'),'),']);
    disp(['ranks (', num2str(r'), ') and cores']);
    disp(' ')

    row0 = '';
    row1 = '';
    row2 = '';
    row3 = '';
    row4 = '';

    for i=1:d
        row0 = [row0, sprintf('     %3i    ', n(i,2))]; 
        row1 = [row1, '       |    '];
        row2 = [row2, sprintf('%3i--(U%2i)--', r(i), i)];
        row3 = [row3, '       |    '];
        row4 = [row4, sprintf('     %3i    ', n(i,1))];  
    end
    row2 = [row2, sprintf( '%3i', r(end))]; 
    disp(row0)
    disp(row1)
    disp(row2)
    disp(row3)
    disp(row4)
end
                    

end
