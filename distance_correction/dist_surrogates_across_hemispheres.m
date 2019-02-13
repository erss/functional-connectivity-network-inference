function [ surrogate_distr ] = dist_surrogates_across_hemispheres( A,D,N1,N2)
% DIST_SURROGATES generates a surrogate distribution of 10,000 functional
% connectivity values.  The distribution is sampled from all node pairs in
% A - across all time - for which the distance between nodes is at least 
% the distance between the two closest nodes and at most the distance 
% between the two furthest nodes in the subnetwork A(N1,N2,:).
%
% INPUT:
%   A     = 2D or 3D matrix of FC raw values
%   D     = Corresponding 2D matrix containing distances between each node pair
%   N1,N2 = Indices of subnetwork in questions; connections between N1 to N2
%
% OUTPUT:
%   SURROGATE_DIST = surrogate distribution of 10000 values within range.
nsurrogates=10000;
Dsub = D(N1,N2);

r1= nanmean(Dsub(:)) - 2*nanstd(Dsub(:)); % min(Dsub(:));
r2= nanmean(Dsub(:)) + 2*nanstd(Dsub(:)); % max(Dsub(:));
Dinrange = D>=r1 & D<=r2;

% exclude nodes in same hemisphere
Dinrange(1:324,1:162) = 0;
Dinrange(163:324,163:324) = 0;

% exclude nodes in subnetwork of interest
Dinrange(N1,N2)= 0;

Dinrange = repmat(Dinrange,1,1,size(A,3));
fc_values_dinrange = A(Dinrange);
fc_values_dinrange(isnan(fc_values_dinrange)) = [];
randinx = randi(length(fc_values_dinrange),[nsurrogates,1]);
surrogate_distr = fc_values_dinrange(randinx);

end

