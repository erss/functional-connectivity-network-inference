%%% fc-network-ex

% DYANMIC NETWORK SCRIPT EXAMPLE
addpath(genpath('Toolboxes/chronux_2_12'))
addpath(genpath('Toolboxes/mgh'))

%%% 1. LOAD DATA
 model.patient_name ='pBECTS007';
 model.data = [data_left; data_right];
 pc = patient_coordinates_007;

%%% 2. LOAD MODEL PARAMETERS
model.sampling_frequency = 2035;
model.window_step = 2;% % in seconds
model.window_size = 2;   % in seconds
model.q=0.05;
model.nsurrogates = 10000;
model.t=time;

%%% 3. Remove artifacts

model = remove_artifacts_all_lobes(model,pc);
% model.bad_channels =[1:8 10 12 14 15 16 17 18 20 21 24 25 29 31 32 35 36 39 41 ...
%     42 44 47 48 53 54 57 64 69 71 72 74 88 104 130 132 163 165:167 170 ...
%    172 177 180 182 183 193 201 206 212 230 233];
% 
% [ data] = remove_bad_channels( model );

%%% 4. INFER NETWORK
model = infer_power_old(model);

%%% 5. SAVE DATA
% model.data = NaN;  % clear data
% model.data_clean = NaN;  % clear data
% save([ model.patient_name '_power.mat'],'model')

%%%%%%%%%%%%%%%%%%%%%%%% 

