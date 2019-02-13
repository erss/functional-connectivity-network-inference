load('pBECTS006_distances.mat')
m06 = model_dist_correction;
clear model_dist_correction;
load('pBECTS007_distances.mat')
m07 = model_dist_correction;
clear model_dist_correction;
load('pBECTS013_rest02_distances.mat')
m13 = model_dist_correction;
clear model_dist_correction;
load('pBECTS020_distances.mat')
m20 = model_dist_correction;
clear model_dist_correction;
%%
%%%
% m=m06;
% subplot 412
% histogram(m.surrogate_distr_left);
% hold on;
% histogram(m.surrogate_distr_right);
% histogram(m.surrogate_distr_bilateral);
% %%%

for t = 1:size(m06.net_left,3)
    %    n =m06.net_left(:,:,t);
    n =m06.net_right(:,:,t);
    dens06(t) = nanmean(n(:));
end

for t = 1:size(m07.net_left,3)
    %     n =m07.net_right(:,:,t);
    n = m07.net_right(:,:,t);
    dens07(t) = nanmean(n(:));
end
for t = 1:size(m13.net_left,3)
    %     n =m13.net_bilateral(:,:,t);
    n = m13.net_right(:,:,t);
    dens13(t) = nanmean(n(:));
end
for t = 1:size(m20.net_left,3)
    
    %     n =m20.net_bilateral(:,:,t);
    n = m20.net_right(:,:,t);
    dens20(t) = nanmean(n(:));
    
end

plot(dens06); hold on
plot(dens07);
hold on
plot(dens13);
plot(dens20);

legend('6','7','13','20')
