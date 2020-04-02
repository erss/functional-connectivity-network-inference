%%% fc-network-ex

% DYANMIC NETWORK SCRIPT EXAMPLE

%%% 1. LOAD DATA
 model.patient_name ='model013';
 model.data = [data_left; data_right]; % data is [channels x time]
 
%%% 2. LOAD MODEL PARAMETERS
model.sampling_frequency = 2035;  % (Hz) sampling rate
model.window_step        = 0.5;   % (s) window step
model.window_size        = 1;     % (s) window size
model.q                  = 0.05;  % false-discovery-rate
model.nsurrogates        = 10000; % number of surrogates used to generate bootstrap distribution
model.t                  = time;  % time axis

%%% 3. REMOVE ARTIFACTS
model = remove_artifacts_all_lobes(model,patient_coordinates_013);

%%% 4. INFER NETWORK
model = infer_network_correlation( model);

%%% 5. SAVE NETOWORK
model.data = NaN;  % clear data
model.data_clean = NaN;  % clear data
save([ model.patient_name '_cross_correlation.mat'],'model')

%%%%%%%%%%%%%%%%%%%%%%%% 