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
lbl_n1 = 'storage';
lbl_n2 = 'size';
lbl_nn1 = 'unfolded';
lbl_nn2 = 'size';
lbl_fmt1 = 'corresponding indices';
lbl_fmt2 = 'of the represented tensor';
sep_n_nn1 = '  :  ';
sep_nn_fmt1 = '   :   ';
sep_n_nn2 = '  :  ';
sep_nn_fmt2 = '   :   ';
sym_core='U';
sep_core=' ';
sep_cores_n = ' :  ';
sep_n = ' x ';
sep_n_nn = '  ~  ';         %
sep_nn_fmt = '  <->  ';     %
sep_nn = ' x ';
del_nn_left = '(';
del_nn_right = ')';
del_nn_middle = ' ';
sep_fmt = ', ';
del_fmt_left = '(';
del_fmt_right = ')';
del_fmt_middle = ' ';
sym_void = '_';
sym_dim = '#';

fill_cores_n = ':';
fill_n_nn = ':';
fill_nn_fmt = ':';

sym_top = '.';
sym_bottom = ' ';


r_len = max(r);
r_len = 1+floor(log10(r_len));
d_len = 1+floor(log10(d));
n_len = max(n, [], 1);
n_len = 1+floor(log10(n_len));

dim_void = (fmt == 0);

nn_len = 1+floor(log10(nn));
nn_len(dim_void) = length(sym_void);
nn_len = max(nn_len, [], 1);

fmt_len = 1+floor(log10(fmt));
fmt_len(dim_void) = length(sym_void);
fmt_len(~dim_void) = fmt_len(~dim_void)+length(sym_dim);
fmt_len = max(fmt_len, [], 1);

width_n = sum(n_len)+length(sep_n);
offset_n = max([width_n length(lbl_n1) length(lbl_n2)])-width_n;
width_n = width_n + offset_n;
offset_n = blanks(offset_n);

width_nn = sum(nn_len,3) + length(del_nn_left)+length(del_nn_left)+(dd-1)*length(del_nn_middle);
width_nn = sum(width_nn) + (2-1)*length(sep_nn);
offset_nn = max([width_nn length(lbl_nn1) length(lbl_nn2)])-width_nn;
width_nn = width_nn + offset_nn;
offset_nn = blanks(offset_nn);

width_fmt = sum(fmt_len,3) + length(del_fmt_left)+length(del_fmt_left)+(dd-1)*length(del_fmt_middle);
width_fmt1 = width_fmt(1) + length(sep_fmt);
width_fmt = sum(width_fmt) + (2-1)*length(sep_fmt);
width_fmt = max([width_fmt length(lbl_fmt1) length(lbl_fmt2)]) + floor(length(sep_nn_fmt)/2);

L = length(sep_cores_n)-length(fill_cores_n);
fill_cores_n(L+1:end) = [];
fill_cores_n_top = [repmat(sym_top, 1, floor(L/2)) fill_cores_n repmat(sym_top, 1, ceil(L/2))];
fill_cores_n_bottom = [repmat(sym_bottom, 1, floor(L/2)) fill_cores_n repmat(sym_bottom, 1, ceil(L/2))];

L = length(sep_n_nn)-length(fill_n_nn);
fill_n_nn(L+1:end) = [];
fill_n_nn_top = [repmat(sym_top, 1, floor(L/2)) fill_n_nn repmat(sym_top, 1, ceil(L/2))];
fill_n_nn_bottom = [repmat(sym_bottom, 1, floor(L/2)) fill_n_nn repmat(sym_bottom, 1, ceil(L/2))];

L = length(sep_nn_fmt)-length(fill_nn_fmt);
fill_nn_fmt(L+1:end) = [];
fill_nn_fmt_top = [repmat(sym_top, 1, floor(L/2)) fill_nn_fmt repmat(sym_top, 1, ceil(L/2))];
fill_nn_fmt_bottom = [repmat(sym_bottom, 1, floor(L/2)) fill_nn_fmt repmat(sym_bottom, 1, ceil(L/2))];

L=[];

fill_top = repmat(sym_top, 1, length(sym_core)+length(sep_core)+d_len);
fill_top = [fill_top fill_cores_n_top repmat(sym_top, 1, width_n) fill_n_nn_top];
fill_top = [fill_top repmat(sym_top, 1, width_nn) fill_nn_fmt_top];
fill_top = [fill_top repmat(sym_top, 1, width_fmt)];

fill_bottom = repmat(sym_bottom, 1, length(sym_core)+length(sep_core)+d_len);
fill_bottom = [fill_bottom fill_cores_n_bottom repmat(sym_bottom, 1, width_n) fill_n_nn_bottom];
fill_bottom = [fill_bottom repmat(sym_bottom, 1, width_nn) fill_nn_fmt_bottom];
fill_bottom = [fill_bottom repmat(sym_bottom, 1, width_fmt)];

fill = repmat(' ', 1, length(sym_core)+length(sep_core)+d_len);
fill = [fill_bottom fill_cores_n_bottom repmat(' ', 1, width_n) fill_n_nn_bottom];
fill = [fill_bottom repmat(' ', 1, width_nn) fill_nn_fmt_bottom];
fill = [fill_bottom repmat(' ', 1, width_fmt)];
fill = [' ' fill];

line = [offset blanks(r_len) fill(1:1+length(sym_core)+length(sep_core)+d_len+length(sep_cores_n))];
line = [line lbl_n1 blanks(width_n-length(lbl_n1))];
line = [line sep_n_nn1];
line = [line lbl_nn1 blanks(width_nn-length(lbl_nn1)) ];
line = [line sep_nn_fmt1 lbl_fmt1];
disp(line);
line = [offset blanks(r_len-1-floor(log10(r(1)))) num2str(r(1))];
line = [line fill(1:1+length(sym_core)+length(sep_core)+d_len+length(sep_cores_n))];
line = [line lbl_n2 blanks(width_n-length(lbl_n2))];
line = [line sep_n_nn2];
line = [line lbl_nn2 blanks(width_nn-length(lbl_nn2)) ];
line = [line sep_nn_fmt2 lbl_fmt2];
disp(line);
disp([offset blanks(r_len) '\' fill_top]);

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
            fmt_str=[sym_dim num2str(fmt(k,s,kk))];
            if fmt(k,s,kk) == 0
                fmt_str = sym_void;
            end
            line = [line blanks(fmt_len(1,s,kk)-length(fmt_str)) fmt_str];
        end
        line=[line del_fmt_right];
    end
    disp(line);
    disp([offset blanks(r_len) '/' fill_bottom]);
    disp([offset blanks(r_len-1-floor(log10(r(k+1)))) num2str(r(k+1)) fill]);
    if k == d
        continue
    end
    disp([offset blanks(r_len) '\' fill_top]);
end


end
