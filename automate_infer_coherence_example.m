%%% Load toolboxes and scripts
addpath(genpath('~/Documents/MATLAB/bects-networks-toolbox/'))
addpath(genpath('~/Documents/MATLAB/fc-network-inference-bootstrap/'))
addpath(genpath('~/Documents/MATLAB/Toolboxes/chronux/'))
addpath(genpath('~/Documents/MATLAB/Toolboxes/mgh/'))

%%% My computer
DATAPATH    = '~/Desktop/bects_data/';
OUTDATAPATH = '~/Desktop/bects_results/coherence - r5/';

%%% Galactica
% DATAPATH    = '~/Desktop/bects_data/source_data_2/'
% OUTDATAPATH = '/Users/liz/Desktop/bects_results/nets_final/';

data_directory = dir(DATAPATH);

for k =  5 % loop through patients
    model.patient_name = data_directory(k).name;
    fprintf([model.patient_name '\n']);
    source_directory = dir([ DATAPATH data_directory(k).name '/sleep_source/*.mat']);
    
    PATIENTPATH = [DATAPATH model.patient_name];
    addpath(PATIENTPATH)
    patient_coordinates = load_patient_coordinates( PATIENTPATH,source_session );
    
    for i = 1:1 %4  % loop through source sessions
        
        %%% 1. LOAD PATIENT DATA
        
        model.patient_name   = data_directory(k).name;
        
        source_session       = source_directory(i).name;
        model.source_session = source_session;
        if strcmp(source_session(11),'r')
            rnge = 1:17;
        else
            rnge = 1:18;
        end
        
        load([PATIENTPATH '/sleep_source/' source_session],'data_left')
        load([PATIENTPATH '/sleep_source/' source_session],'data_right')
        load([PATIENTPATH '/sleep_source/' source_session],'time')
        model.data = [data_left;data_right];
        
        %%% 2. LOAD MODEL PARAMETERS
        model.sampling_frequency = 2035;
        model.q=0.05;
        model.nsurrogates = 10000;
        model.t=time;
        
        model.params.trialave = 1;                        % ... trial average.
        model.params.fpass    = [1 50.1];                 % ... freq range to pass.
        model.params.Fs       = model.sampling_frequency; % ... sampling frequency. 
        params.err            = [2 0.05];                 % ... Jacknife error bars, p =0.05;
                                                          
        %%% 3. REMOVE ARTIFACTS
        model = remove_artifacts_all_lobes(model,patient_coordinates);
        
        %%% 4. --- INFER NETWORKs ---
        % Delta: [2, 4]   --> W = 1,   T = 5,   2TW-1 = 9
        % Theta: [4, 8]   --> W = 2,   T = 3,   2TW-1 = 11
        % Alpha: [8, 12]  --> W = 2,   T = 3,   2TW-1 = 11
        % Sigma: [10, 15] --> W = 2.5, T = 2,   2TW-1 = 9
        % Beta:  [15, 30] --> W = 7.5, T = 1,   2TW-1 = 14
        % Gamma: [30, 50] --> W = 10,  T = 0.5, 2TW-1 = 9
        
        % 4. a) DELTA -------------------------------------------------------------
        % Delta: [2, 4]   --> W = 1,   T = 5,   2TW-1 = 9
        model.W           = 1;
        model.window_step = 5; % in seconds
        model.window_size = 5;   % in seconds
        model.f_start     = 3;
        model.f_stop      = 3;
        model.params.pad  = -1;                           % ... no zero padding.
        model_delta       = infer_network_coherency(model);
        model_delta.fband = 'delta';
        
        % 4. b) SAVE DELTA DATA
        model_delta.data       = NaN;  % clear data
        model_delta.data_clean = NaN;  % clear data
        save([ OUTDATAPATH source_session(rnge) '_delta_coherence.mat'],'model_delta')
        
        % 5. a) THETA -------------------------------------------------------------
        % Theta: [4, 8]   --> W = 2,   T = 3,   2TW-1 = 11
        model.W           = 2;
        model.f_start     = 6;
        model.f_stop      = 6;
        model.window_step = 3; % in seconds
        model.window_size = 3;   % in seconds
        model.params.pad  = -1;                          % ... no zero padding.
        model_theta       = infer_network_coherency(model);
        model_theta.fband = 'theta';
        
        % 5. b) SAVE THETA DATA
        model_theta.data       = NaN;  % clear data
        model_theta.data_clean = NaN;  % clear data
        save([ OUTDATAPATH source_session(rnge) '_theta_coherence.mat'],'model_theta')
        
        % 6. a) ALPHA -------------------------------------------------------------
        % Alpha: [8, 12]  --> W = 2,   T = 3,   2TW-1 = 11
        model.W           = 2;
        model.f_start     = 10;
        model.f_stop      = 10;
        model.window_step = 3; % in seconds
        model.window_size = 3;   % in seconds
        model.params.pad      = -1;                          % ... no zero padding.
        model_alpha       = infer_network_coherency(model);
        model_alpha.fband = 'alpha';
        
        % 6. b) SAVE ALPHA DATA
        model_alpha.data       = NaN;  % clear data
        model_alpha.data_clean = NaN;  % clear data
        save([ OUTDATAPATH source_session(rnge) '_alpha_coherence.mat'],'model_alpha')
        
        % 7. a) SIGMA -------------------------------------------------------------
        % Sigma: [10, 15] --> W = 2.5, T = 2,   2TW-1 = 9
        model.W           = 2.5;
        model.f_start     = 12.5;
        model.f_stop      = 12.5;
        model.window_step = 2; % in seconds
        model.window_size = 2; % in seconds
        model.params.pad  = -1;                           % ... no zero padding.
        model_sigma       = infer_network_coherency(model);
        model_sigma.fband = 'sigma';
        
        % 7. b) SAVE SIGMA DATA
        model_sigma.data = NaN;  % clear data
        model_sigma.data_clean = NaN;  % clear data
        save([OUTDATAPATH source_session(rnge) '_sigma_coherence.mat'],'model_sigma')
        
        
        % 8. a) BETA --------------------------------------------------------------
        % Beta:  [15, 30] --> W = 7.5, T = 1,   2TW-1 = 14
        model.W           = 7.5;
        model.f_start     = 22.3572;
        model.f_stop      = 22.3572;
        model.window_step = 1; % in seconds
        model.window_size = 1;   % in seconds
        model.params.pad  = 1;                          % ... with zero padding.
        model_beta        = infer_network_coherency(model);
        model_beta.fband  = 'beta';
        
        % 8. b) SAVE BETA DATA
        model_beta.data       = NaN;  % clear data
        model_beta.data_clean = NaN;  % clear data
        save([OUTDATAPATH source_session(rnge)  '_beta_coherence.mat'],'model_beta')
        
        % 9. a) GAMMA -------------------------------------------------------------
        % Gamma: [30, 50] --> W = 10,  T = 0.5, 2TW-1 = 9
        model.W           = 10;
        model.f_start     = 39.9804;
        model.f_stop      = 39.9804;
        model.window_step = 0.5; % in seconds
        model.window_size = 0.5;   % in seconds
        model.params.pad  = -1;                          % ... no zero padding.
        model_gamma       = infer_network_coherency(model);
        model_gamma.fband = 'gamma';
        
        % 9. b) SAVE GAMMA DATA
        model_gamma.data       = NaN;  % clear data
        model_gamma.data_clean = NaN;  % clear data
        save([ OUTDATAPATH source_session(rnge)  '_gamma_coherence.mat'],'model_gamma')
        
        
        clear model_delta
        clear model_theta
        clear model_alpha
        clear model_sigma
        clear model_beta
        clear model_gamma
        clear model
        clear data_left
        clear data_right
        clear time
    end
    clear model_delta
    clear model_theta
    clear model_alpha
    clear model_sigma
    clear model_beta
    clear model_gamma
    clear model
    clear patient_coordinates
    clear data_left
    clear data_right
    clear time
end