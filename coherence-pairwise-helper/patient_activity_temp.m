function [ leftSOZ,rightSOZ,acrossSOZ ] = patient_activity_temp( A, pc )
%UNTITLED17 Summary of this function goes here
%   Detailed explanation goes here
[LN,~]= find_subnetwork_coords(pc);


% Replace diagonal and lower triangle NaN
M = NaN(size(A,2));
M =tril(M);
for k=1:size(A,3)
    Atemp = A(:,:,k);
    A(:,:,k)=Atemp + M;
end

% Exclude distances <=0.01
D = compute_nodal_distances(pc.coords(3:5,:));
[i,j]=find(D<=0.01);
for k = 1:length(i)
    A(i(k),j(k),:) = NaN;
end

leftSOZ_mat = A(1:length(LN),1:length(LN),:);
rightSOZ_mat = A(length(LN)+1:end,length(LN)+1:end,:);
acrossSOZ_mat = A(1:length(LN),length(LN)+1:end,:);

for t = 1:size(A,3)
    temp =leftSOZ_mat(:,:,t);
    leftSOZ(t) = nanmean(temp(:));
    
    temp =rightSOZ_mat(:,:,t);
    rightSOZ(t) = nanmean(temp(:));
    
    temp =acrossSOZ_mat(:,:,t);
    acrossSOZ(t) = nanmean(temp(:));
end

end

