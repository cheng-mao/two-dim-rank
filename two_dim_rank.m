% Two-Dimensional Ranking from Pairwise Comparisons
% by Cheng Mao (Georgia Tech), Ashwin Pananjady (UC Berkeley) 
% and Martin Wainwright (UC Berkeley)

function [per_est] = two_dim_rank(Y, N, tau)
% "two_dim_rank" aggregates a set of comparisons between pairs of items to
% produce a ranking of the items
%
% Input arguments:
% - Y: n*n data matrix. Entry Y_ij is the result of a comparison between 
%      items i and j. Y_ij = 1 means that i beats j. Y_ij can be the 
%      frequency that i beats j in a set of comparisons. 
% - N: the number of all comparisons 
% - tau: tuning parameter. tau can be set to 1.2.
% 
% Output arguments:
% - per_est: the ranking estimator. Item i is ranked at per_est(i).

n = size(Y);
n = n(2);   % total number of items
G = zeros(n);   % a graph whose topological sort is the final ranking estimator

% per_pre is the ranking estimator obtained from sorting the column sums
[col_sum,per_pre] = sort(sum(Y,1),'descend'); 

% obtain blocks according to column sums
block_ind = blocking(col_sum,0.5*sqrt(N/n*log(n)),0.1*n*sqrt(n/N));
[m,~] = size(block_ind);    % m is the number of blocks

% sort the columns of Y according to column sums
Y = Y(:,per_pre);

% if averages of two rows differ significantly, add a directed edge to G
col_avg = sum(Y,2)/sqrt(n);
G = G|(col_avg-col_avg'>tau*sqrt(N/n^2*log(n)));

% main procedure of two-dimensional sorting
for i = 1:m
    % for each block, compute the average of entries along each row
    block_avg = sum(Y(:,block_ind(i,1):block_ind(i,2)),2)/sqrt(block_ind(i,2)-block_ind(i,1)+1);
    % add a directed edge to G if two averages differ significantly
    G_new = G|(block_avg-block_avg'>tau*sqrt(N/n^2*log(n)));
    if isdag(digraph(G_new))
        G = G_new;
    end
end

% topological sort of G
[~,per1] = sort(sum(Y,2),'descend');
G = G(per1,per1);
G = digraph(G);
per2 = toposort(G,'Order','stable');
per_est = per1(per2);