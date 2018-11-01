%%% fc-network-ex

% DYANMIC NETWORK SCRIPT EXAMPLE

%%% 1. LOAD DATA
 model.patient_name ='model013';
 model.data = [data_left; data_right];
 
%%% 2. LOAD MODEL PARAMETERS
model.sampling_frequency = 2035;
model.window_step = 0.5;% 0.5; % in seconds
model.window_size = 1;   % in seconds
model.q=0.05;
model.nsurrogates = 10000;
model.t=time;

%%% 3. Remove artifacts
model = remove_artifacts_all_lobes(model,patient_coordinates_013);

%%% 4. INFER NETWORK
model = infer_network_correlation_bootstrap( model);

%%% 5. SAVE DATA
model.data = NaN;  % clear data
model.data_clean = NaN;  % clear data
save([ model.patient_name '_cross_correlation.mat'],'model')

%%%%%%%%%%%%%%%%%%%%%%%% 
 
%OUTFIGPATH = strcat('~/Desktop/bects_data/plots/',model.patient_name);
%OUTVIDPATH = strcat('~/Desktop/',model.patient_name,'.avi');
%OUTDATAPATH = strcat('~/Desktop/',model.patient_name,'.mat');
%OUTDATAPATH = strcat('~/Documents/MATLAB/',model.patient_name,'.mat');
% OUTFIGPATH = strcat('~/Documents/MATLAB/',model.patient_name(1:9),'/');
% patient_coordinates = load_patient_coordinates( model.patient_name );
