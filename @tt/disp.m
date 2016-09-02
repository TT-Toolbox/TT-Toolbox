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
                    


disp('***')

r = x.r;
d = x.d;
n = x.n;
dd = x.dd;
nn = x.nn;
% dfull = x.dfull;
% nfull = x.nfull;
fmt = x.fmt;

offset = blanks(3);
lbl_n1 = 'size';
lbl_n2 = 'folded';
lbl_nn1 = 'size';
lbl_nn2 = 'unfolded';
lbl_fmt1 = 'corresponding indices of the represented tensor';
sep_n_nn1 = '  \  ';
sep_nn_fmt1 = '   \   ';
sep_n_nn2 = '  /  ';
sep_nn_fmt2 = '   /   ';
sym_core='U';
sep_core=' ';
sep_cores_n = ':   ';
sep_n = ' x ';
sep_n_nn = '  ~  ';
sep_nn_fmt = '  <->  ';
sep_nn = ' x ';
del_nn_left = '(';
del_nn_right = ')';
del_nn_middle = ' ';
sep_fmt = ' x ';
del_fmt_left = '(';
del_fmt_right = ')';
del_fmt_middle = ' ';
sym_void = '_';
sym_dim = '#';

r_len = max(r);
r_len = 1+floor(log10(r_len));
d_len = 1+floor(log10(d));
n_len = max(n, [], 1);
n_len = 1+floor(log10(n_len));

nn_len = max(nn, [], 1);
nn_len = 1+floor(log10(nn_len));
nn_len = max(nn_len, length(sym_void));

dim_void = (fmt == 0);
fmt_len = 1+floor(log10(fmt));
fmt_len(dim_void) = length(sym_void);
fmt_len(~dim_void) = fmt_len(~dim_void)+length(sym_dim);
fmt_len = max(fmt_len, [], 1);

width_n = sum(n_len)+length(sep_n);
offset_n = max([width_n length(lbl_n1) length(lbl_n2)])-width_n;
width_n = width_n + offset_n;
offset_n = blanks(offset_n);

width_nn = 2*length(del_nn_left)+2*length(del_nn_left)+2*(dd-1)*length(del_nn_middle)+sum(nn_len(:))+length(sep_nn);
offset_nn = max([width_nn length(lbl_nn1) length(lbl_nn2)])-width_nn;
width_nn = width_nn + offset_nn;
offset_nn = blanks(offset_nn);

width_fmt = length(del_fmt_left)+length(del_fmt_left)+(dd-1)*length(del_fmt_middle)+sum(fmt_len);


line = [offset blanks(r_len+1+length(sym_core)+length(sep_core)+d_len+length(sep_cores_n))];
line = [line lbl_n1 blanks(width_n-length(lbl_n1))];
line = [line sep_n_nn1];
line = [line lbl_nn1 blanks(width_nn-length(lbl_nn1)) ];
line = [line sep_nn_fmt1 lbl_fmt1];
disp(line);
line = [offset blanks(r_len-1-floor(log10(r(1)))) num2str(r(1))];
line = [line blanks(1+length(sym_core)+length(sep_core)+d_len+length(sep_cores_n))];
line = [line lbl_n2 blanks(width_n-length(lbl_n2))];
line = [line sep_n_nn2];
line = [line lbl_nn2 blanks(width_nn-length(lbl_nn2)) ];
line = [line sep_nn_fmt2 'row' blanks(width_fmt+length(sep_fmt)-length('row')) 'column'];
disp(line);
disp([offset blanks(r_len) '\']);

for k = 1:d
    line = [offset blanks(r_len+1) sym_core sep_core];
    line = [line blanks(d_len-1-floor(log10(k))) num2str(k)];
    line = [line sep_cores_n];
    for s = 1:2
        if s > 1
            line = [line sep_n];
        end
        line = [line blanks(n_len(1,s)-1-floor(log10(n(k,s)))) num2str(n(k,s))];
    end
    line = [line offset_n sep_n_nn];
    for s = 1:2
        if s > 1
            line=[line sep_nn];
        end
        line=[line del_nn_left];
        for kk = 1:dd
            if kk > 1
                line=[line del_nn_middle];
            end
            nn_str=num2str(nn(k,s,kk));
            if fmt(k,kk) == 0
                nn_str = sym_void;
            end
            line = [line blanks(nn_len(1,s,kk)-length(nn_str)) nn_str];
        end
        line=[line del_nn_right];
    end
    line = [line offset_nn sep_nn_fmt];
    for s = 1:2
        if s > 1
            line=[line sep_fmt];
        end
        line=[line del_fmt_left];
        for kk = 1:dd
            if kk > 1
                line=[line del_fmt_middle];
            end
            fmt_str=[sym_dim num2str(fmt(k,kk))];
            if fmt(k,kk) == 0
                fmt_str = sym_void;
            end
            line = [line blanks(fmt_len(1,kk)-length(fmt_str)) fmt_str];
        end
        line=[line del_fmt_right];
    end
    disp(line);
    disp([offset blanks(r_len) '/']);
    disp([offset blanks(r_len-1-floor(log10(r(k+1)))) num2str(r(k+1))]);
    if k == d
        continue
    end
    disp([offset blanks(r_len) '\']);
end


end
