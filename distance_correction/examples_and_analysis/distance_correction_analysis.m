load('/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence - r1/distance_correction/pBECTS006_distances.mat')
m06=model_dist_correction;
pc = load_patient_coordinates(model_dist_correction.name);
[LN, RN] = find_subnetwork_central(pc);
l1 = length(LN);
l2 = length(RN);
m06.net_bilateral(1:l1,l1+1:end,:) = NaN;
clear model_dist_correction

load('/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence - r1/distance_correction/pBECTS007_distances.mat')
m07=model_dist_correction;
pc = load_patient_coordinates(model_dist_correction.name);
[LN, RN] = find_subnetwork_central(pc);
l1 = length(LN);
l2 = length(RN);
m06.net_bilateral(1:l1,l1+1:end,:) = NaN;
clear model_dist_correction

load('/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence - r1/distance_correction/pBECTS013_rest02_distances.mat')
m13=model_dist_correction;
pc = load_patient_coordinates(model_dist_correction.name);
[LN, RN] = find_subnetwork_central(pc);
l1 = length(LN);
l2 = length(RN);
m06.net_bilateral(1:l1,l1+1:end,:) = NaN;
clear model_dist_correction

load('/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence - r1/distance_correction/pBECTS020_distances.mat')
m20=model_dist_correction;
pc = load_patient_coordinates(model_dist_correction.name);
[LN, RN] = find_subnetwork_central(pc);
l1 = length(LN);
l2 = length(RN);
m06.net_bilateral(1:l1,l1+1:end,:) = NaN;
clear model_dist_correction

nanmean(reshape(m06.net_left,1,[]))
nanmean(reshape(m13.net_left,1,[]))
nanmean(reshape(m20.net_left,1,[]))

nanmean(reshape(m07.net_right,1,[]))
nanmean(reshape(m13.net_right,1,[]))
nanmean(reshape(m20.net_right,1,[]))

nanmean(reshape(m06.net_across,1,[]))
nanmean(reshape(m07.net_across,1,[]))
nanmean(reshape(m13.net_across,1,[]))
nanmean(reshape(m20.net_across,1,[]))

%%
% adj = m06.net_left;
% %adj(:,:,isnan(adj(2,3,:)))=[];
plot_adj_matrix(m06.net_bilateral);