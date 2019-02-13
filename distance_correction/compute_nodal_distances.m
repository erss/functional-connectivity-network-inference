function D = compute_nodal_distances( xyz )
% Computes Euclidean distance between all sets of points;
%
% INPUT: 
%   xyz = 3 x n matrix of points in xyz space
% OUTPUT:
%   D   = n x n upper triangular matrix of distances between each point;
%   D(i,j) indicates distance between node i and j.
n=size(xyz,2);
D=nan(n);

for i = 1:n
    for j=(i+1):n
        p1 = xyz(:,i);
        p2 = xyz(:,j);
        D(i,j) = sqrt(sum((p1 - p2).^2));
    end
end
end

