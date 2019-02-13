%%% Distance Correction analysis - in debug mode
%% 1) Load Data
load('/Users/erss/Documents/MATLAB/pBECTS007/patient_coordinates_007.mat')
%load('/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/cross_corr_bootstrap/pBECTS020_rest03_source.mat')

load('/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence/pBECTS007_coherence.mat')
%% 2) Store variables

pc=patient_coordinates_007;
xyz=pc.coords(3:5,:);
D = compute_nodal_distances( xyz );
A = model.kC;

 for i = 1:size(A,3)
     Atemp = A(:,:,i);
     Atemp(logical(tril(ones(324))))=nan;
     A(:,:,i) = Atemp ;%+ Atemp';
 end
 
%% 3) Compute variables
[LN, RN] = find_subnetwork_central(pc);
n= size(A,1); % number of electrodes
nsurrogates = 10000;
 surrogate_distr_left   = dist_surrogates( A,D,LN,LN );
 surrogate_distr_right  = dist_surrogates( A,D,RN,RN );
surrogate_distr_across = dist_surrogates( A,D,LN,RN );
surrogate_distr_global = dist_surrogates( A,D,1:n,1:n);
surrogate_distr_focus  = dist_surrogates_focus( A,D,LN,RN );



%%
% Dsub=D(RN,RN);
% histogram(Dsub(:));
% title([num2str(nanmean(Dsub(:))-nanstd(Dsub(:))) ' to ' num2str(nanmean(Dsub(:))+nanstd(Dsub(:)))])
%% 4) Plot surrogates + associated distributions from averaged network

figure();

subplot 131

histogram(surrogate_distr_focus,'Normalization','probability','FaceColor','r');
hold on;

meanA = nanmean(A,3);
Atemp = [reshape(meanA(LN,LN),1,[]), reshape(meanA(RN,RN),1,[])];
Atemp(isnan(Atemp)) = [];

histogram(Atemp,'Normalization','probability','FaceColor','g');
title('focus')


subplot 132

histogram(surrogate_distr_across,'Normalization','probability','FaceColor','r');
hold on;

meanA = nanmean(A,3);
Atemp = reshape(meanA(LN,RN),1,[]);
Atemp(isnan(Atemp)) = [];

histogram(Atemp,'Normalization','probability','FaceColor','g');
title('across')

subplot 133

histogram(surrogate_distr_global,'Normalization','probability','FaceColor','r');
hold on;

meanA = nanmean(A,3);
Atemp = reshape(meanA,1,[]);
Atemp(isnan(Atemp)) = [];

histogram(Atemp,'Normalization','probability','FaceColor','g');
title('global')
suptitle(model.patient_name)

%%
figure();

subplot 131

histogram(surrogate_distr_focus,'FaceColor','r');
hold on;

Atemp = [reshape(A(LN,LN,:),1,[]), reshape(A(RN,RN,:),1,[])];
Atemp(isnan(Atemp)) = [];
Atemp = Atemp(randi(length(Atemp),1,10000));

histogram(Atemp,'FaceColor','g');
title('focus')


subplot 132

histogram(surrogate_distr_across,'FaceColor','r');
hold on;

Atemp = reshape(A(LN,RN,:),1,[]);
Atemp(isnan(Atemp)) = [];
Atemp = Atemp(randi(length(Atemp),1,10000));
histogram(Atemp,'FaceColor','g');
title('across')

subplot 133

histogram(surrogate_distr_global,'FaceColor','r');
hold on;

Atemp = reshape(A,1,[]);
Atemp(isnan(Atemp)) = [];
Atemp = Atemp(randi(length(Atemp),1,10000));
histogram(Atemp,'FaceColor','g');
title('global')
suptitle(model.patient_name)


%%
figure();
subplot 131

histogram(surrogate_distr_left,'FaceColor','b');
hold on;

Atemp = [reshape(A(LN,LN,:),1,[])];
Atemp(isnan(Atemp)) = [];
Atemp = Atemp(randi(length(Atemp),1,10000));

histogram(Atemp,'FaceColor','g');
title('focus -left')

subplot 132

histogram(surrogate_distr_right,'FaceColor','c');
hold on;

Atemp = [reshape(A(RN,RN,:),1,[])];
Atemp(isnan(Atemp)) = [];
Atemp = Atemp(randi(length(Atemp),1,10000));

histogram(Atemp,'FaceColor','g');
title('focus - right')


subplot 133

histogram(surrogate_distr_right,'FaceColor','b');
hold on
histogram(surrogate_distr_left,'FaceColor','c');

title('focus - left/right')