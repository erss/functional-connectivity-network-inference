%%% fc-network-ex

% DYANMIC NETWORK SCRIPT EXAMPLE
addpath(genpath('Toolboxes/chronux_2_12'))
addpath(genpath('Toolboxes/mgh'))

%%% 1. LOAD DATA
model.patient_name ='pBECTS 006';
model.data = [data_left; data_right];
pc=patient_coordinates_006;

%%% 2. LOAD MODEL PARAMETERS
model.sampling_frequency = 2035;
model.q=0.05;
model.nsurrogates = 10000;
model.t=time;

model.params.trialave = 1;                                         % ... trial average.
model.params.fpass    = [1 50.1];                                  % ... freq range to pass.
model.params.Fs       = model.sampling_frequency;                  % ... sampling frequency.
model.params.err = [2 0.05];
%%% 3. Remove artifacts
model = remove_artifacts_all_lobes(model,pc);
% rmfield(model,'t_clean');
% model.data_clean = [data_left;data_right];
%%% --- INFER NETWORKs ---
% Delta: [2, 4]   --> W = 1,   T = 5,   2TW-1 = 9
% Theta: [4, 8]   --> W = 2,   T = 3,   2TW-1 = 11
% Alpha: [8, 12]  --> W = 2,   T = 3,   2TW-1 = 11
% Sigma: [10, 15] --> W = 2.5, T = 2,   2TW-1 = 9
% Beta:  [15, 30] --> W = 7.5, T = 1,   2TW-1 = 14
% Gamma: [30, 50] --> W = 10,  T = 0.5, 2TW-1 = 9


% 7. a) SIGMA -------------------------------------------------------------
% Sigma: [10, 15] --> W = 2.5, T = 2,   2TW-1 = 9
model.W           = 2.5;
model.f_start     = 12.5;
model.f_stop      = 12.5;
model.window_step = 2; % in seconds
model.window_size = 2; % in seconds
model.params.pad      = -1;  % ... no zero padding.
%%
tic
model_sigma = infer_soz_coherence(model,pc);
ctime=toc
% [LN,RN] = find_subnetwork_coords(pc);
% model.left = infer_soz_coherence(model,LN);
% model.right = infer_soz_coherence(model,RN);
% nodes.source = LN;
% nodes.target = RN;
% model.across = infer_soz_coherence(model,nodes);
%%
figure;
plot(model.left.taxis,model.left.kC,'r',model.right.taxis,model.right.kC,'g',model.across.taxis,model.across.kC,'c','LineWidth',2)
hold on;
plot(model.left.taxis,model.left.kLo,'--r',model.left.taxis,model.left.kUp,'--r','LineWidth',1.5)
plot(model.right.taxis,model.right.kLo,'--g',model.right.taxis,model.right.kUp,'--g','LineWidth',1.5)
plot(model.across.taxis,model.across.kLo,'--c',model.across.taxis,model.across.kUp,'--c','LineWidth',1.5)
legend('Left','Right','Between')
ylim([0 0.5])
% % 7. b) SAVE SIGMA DATA
% model_sigma.data = NaN;        % clear data
% model_sigma.data_clean = NaN;  % clear data
% save([ model.patient_name '_sigma_coherence.mat'],'model_sigma')
% 
% 
% % 8. a) BETA --------------------------------------------------------------
% % Beta:  [15, 30] --> W = 7.5, T = 1,   2TW-1 = 14
% model.W           = 7.5;
% model.f_start     = 22.3572;
% model.f_stop      = 22.3572;
% model.window_step = 1; % in seconds
% model.window_size = 1;   % in seconds
% model.params.pad  = 1;                          % ... with zero padding.
% model_beta        = infer_soz_coherence(model);
% 
% % 8. b) SAVE BETA DATA
% model_beta.data       = NaN;  % clear data
% model_beta.data_clean = NaN;  % clear data

% save([ model.patient_name '_beta_coherence.mat'],'model_beta')
%%
% data_c =model.data_clean;
% %%
% 
% dt=4070;
% for i = 1:dt:dt*119
%     t = i:i+dt-1;
%     model.data_clean = data_c(:,t);
% [~,~,~,~,~,CglobalG(i),kLoGlobalG(i),kUpGlobalG(i)] = infer_soz_coherence(model,1:324);
% 
% end

%%
