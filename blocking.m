function [block_ind] = blocking(col_sum,delta,min_block_size)
% "blocking" decides how to block the matrix according to column sums
%
% Input arguments:
% - col_sum: column sums of the data matrix
% - delta: the difference between column sums for columns in one block
% - min_block_size: minimum number of columns in one block
%
% Output arguments:
% - block_ind: a matrix with two columns; the two entries in each row 
%   are the starting and ending indices of a block

n = size(col_sum);
n = n(2);   % total number of items
block_ind = zeros(1,2);
m = 1;
l = 1;      % l is the beginning of a block
for r = 2:n     % r-1 is the end of a block
    if (col_sum(l)-col_sum(r)>delta) && (r-l+1>min_block_size)
        block_ind(m,:) = [l,r-1];   % record location of a block
        block_ind = [block_ind;0,0];
        l = r;
        m = m+1;
    end
end
block_ind(m-1,2) = n;
block_ind = block_ind(1:m-1,:);