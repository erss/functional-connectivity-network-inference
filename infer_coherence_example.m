%%% fc-network-ex

% DYANMIC NETWORK SCRIPT EXAMPLE
addpath(genpath('Toolboxes/chronux_2_12'))
addpath(genpath('Toolboxes/mgh'))

%%% 1. LOAD DATA
 model.patient_name ='model019';
 model.data = [data_left; data_right];

%%% 2. LOAD MODEL PARAMETERS
model.sampling_frequency = 2035;
model.window_step = 1;% 0.5; % in seconds
model.window_size = 2;   % in seconds
model.q=0.05;
model.nsurrogates = 10000;
model.t=time;

%%% 3. Remove artifacts
model = remove_artifacts_all_lobes(model,patient_coordinates_019);


%%% --- INFER NETWORK ---Delta = 2-4 (TW=2, K=3), Theta = 4-8 (TW=4, K=7), 
% Alpha = 8-12, Sigma = 12.5 - 15,

% 4. a) BETA
model.W = 9;
model.f_start = 21;
model.f_stop  = 21;
model_beta = infer_network_coherency(model);

% 4. b) SAVE BETA DATA
model_beta.data = NaN;  % clear data
model_beta.data_clean = NaN;  % clear data
save([ model.patient_name '_beta_coherence.mat'],'model_beta')

% 5. a) THETA
model.W = 2;
model.f_start = 6;
model.f_stop  = 6;
model_theta = infer_network_coherency(model);

% 5. b) SAVE THETA DATA
model_theta.data = NaN;  % clear data
model_theta.data_clean = NaN;  % clear data
save([ model.patient_name '_theta_coherence.mat'],'model_theta')

% 6. a) ALPHA
model.W = 2;
model.f_start = 10;
model.f_stop  = 10;
model_alpha = infer_network_coherency(model);

% 6. b) SAVE THETA DATA
model_alpha.data = NaN;  % clear data
model_alpha.data_clean = NaN;  % clear data
save([ model.patient_name '_alpha_coherence.mat'],'model_alpha')


