function [ surrogate_distr ] = dist_surrogates_unilateral( A,D,N1)
% DIST_SURROGATES generates a surrogate distribution of 10,000 functional
% connectivity values.  The distribution is sampled from all node pairs in
% A - across all time - for which the distance between nodes is at least 
% the distance between the two closest nodes and at most the distance 
% between the two furthest nodes in the subnetwork A(N1,N1,:).
%
% INPUT:
%   A     = 2D or 3D matrix of FC raw values
%   D     = Corresponding 2D matrix containing distances between each node pair
%   N1,N2 = Indices of subnetwork in questions; connections between N1 to N2
%
% OUTPUT:
%   SURROGATE_DIST = surrogate distribution of 10000 values within range.

nsurrogates=10000;
Dsub = D(N1,N1);
Dsub  = Dsub(:);

r1= nanmean(Dsub(:)) - 2*nanstd(Dsub(:)); % min(Dsub(:));
r2= nanmean(Dsub(:)) + 2*nanstd(Dsub(:)); % max(Dsub(:));
Dinrange = D>=r1 & D<=r2;

Dinrange(N1,N1)= 0;

Dinrange = repmat(Dinrange,1,1,size(A,3));
fc_values_dinrange = A(Dinrange);
fc_values_dinrange(isnan(fc_values_dinrange)) = [];
randinx = randi(length(fc_values_dinrange),[1,nsurrogates]);
surrogate_distr = fc_values_dinrange(randinx);

end

