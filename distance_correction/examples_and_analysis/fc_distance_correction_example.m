%%% fc_distance_correction_example

%%% 1) Load data
name = 'pBECTS006';
pc = load_patient_coordinates(name(1:9));
load(['/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence - r1/' name '_coherence.mat'])

xyz=pc.coords(3:5,:);

%%% 2) Compute distance between nodes
D = compute_nodal_distances(xyz);
 
%%% 3) Ensure A is upper diagonal; NaN on diagonal + below
A = model.kC;
T = ones(size(A,1),size(A,2));
T = tril(T);
T(T==1) = nan;
A = bsxfun(@plus,T,A);

%%% 4) Compute surrogate distributions.
%      patient 6 - dominant spiking in left 
%      patient 7 - dominant spiking in right

[LN, RN] = find_subnetwork_central(pc);

surrogate_distr_left      = dist_surrogates_unilateral( A,D,LN );
surrogate_distr_right     = dist_surrogates_unilateral( A,D,RN );
surrogate_distr_across    = dist_surrogates_across_hemispheres( A,D,LN,RN );
surrogate_distr_bilateral = dist_surrogates_bilateral( A,D,LN, RN );

%%% 5) Compute p-values.

pval_left      = distr_2_pval(A(LN,LN,:),surrogate_distr_left);
pval_right     = distr_2_pval(A(RN,RN,:),surrogate_distr_right);
pval_across    = distr_2_pval(A(LN,RN,:),surrogate_distr_across);

l1 = length(LN);
l2 = length(RN);
Asub = nan(l1+l2,l1+l2,size(A,3));
Asub(1:l1,1:l1,:) = A(LN,LN,:);
Asub(l1+1:end,l1+1:end,:) = A(RN,RN,:);
pval_bilateral = distr_2_pval(Asub,surrogate_distr_bilateral);
pval_bilateral(1:l1,l1+1:end,:) = NaN;

%%% 6) Use FDR to determine significant pvals.

net_left      = pval_2_edge(pval_left);
net_right     = pval_2_edge(pval_right);
net_across    = pval_2_edge(pval_across);

net_bilateral = pval_2_edge(pval_bilateral);
net_bilateral(1:l1,l1+1:end,:) = NaN;

% make symmetric 
net_left      = net_left + permute(net_left, [2 1 3]);
net_right     = net_right + permute(net_right, [2 1 3]);
net_bilateral = net_bilateral + permute(net_bilateral, [2 1 3]);

%%% 7) Save
model_dist_correction.name = name;

model_dist_correction.net_left = net_left;
model_dist_correction.net_right = net_right;
model_dist_correction.net_across = net_across;
model_dist_correction.net_bilateral = net_bilateral;

model_dist_correction.pval_left = pval_left;
model_dist_correction.pval_right = pval_right;
model_dist_correction.pval_across = pval_across;
model_dist_correction.pval_bilateral = pval_bilateral;

model_dist_correction.surrogate_distr_left      = surrogate_distr_left;
model_dist_correction.surrogate_distr_right     = surrogate_distr_right;
model_dist_correction.surrogate_distr_across    = surrogate_distr_across;
model_dist_correction.surrogate_distr_bilateral = surrogate_distr_bilateral;

% OUTPATH = ['/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence/distance_correction/' name '_distances.mat'];
% save(OUTPATH,'model_dist_correction')