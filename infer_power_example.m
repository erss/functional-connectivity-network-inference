%%% fc-network-ex

% DYANMIC NETWORK SCRIPT EXAMPLE
addpath(genpath('Toolboxes/chronux_2_12'))
addpath(genpath('Toolboxes/mgh'))

%%% 1. LOAD DATA
 model.patient_name ='pBECTS020_rest05';
 model.data = [data_left; data_right];
 pc = patient_coordinates_020;

%%% 2. LOAD MODEL PARAMETERS
model.sampling_frequency = 2035;
model.window_step = 1;% 0.5; % in seconds
model.window_size = 2;   % in seconds
model.q=0.05;
model.nsurrogates = 10000;
model.t=time;

%%% 3. Remove artifacts

model = remove_artifacts_all_lobes(model,pc);
 d = model.data_clean;
% do = [data_left; data_right];
%%
% m = mean(do,2);
% m = repmat(m,[1 size(do,2)]);
% dtest1 = do - m;
% 
% dtest2 = bsxfun(@minus,do,mean(do,2));

%%% 4. INFER NETWORK
model = infer_power(model);

%%% 5. SAVE DATA
model.data = NaN;  % clear data
model.data_clean = NaN;  % clear data
save([ model.patient_name '_power.mat'],'model')

%%%%%%%%%%%%%%%%%%%%%%%% 

