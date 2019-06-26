cfg();

global bects_default;

addpath(genpath(bects_default.bectsnetworkstoolbox))
addpath(genpath(bects_default.fcnetworkinference))
addpath(genpath(bects_default.chronuxtoolbox))
addpath(genpath(bects_default.mgh))
DATAPATH    = bects_default.datapath;
OUTDATAPATH = bects_default.outdatapathtc;

data_directory = dir(DATAPATH);

for k = [15 37]; % loop through patients
    model.patient_name = data_directory(k).name;
    fprintf([model.patient_name '\n']);
    source_directory = dir([ DATAPATH data_directory(k).name '/sleep_source/*.mat']);
    
    PATIENTPATH = [DATAPATH model.patient_name];
    addpath(PATIENTPATH)
    mkdir(OUTDATAPATH,[model.patient_name '/sigma/'])
    mkdir(OUTDATAPATH,[model.patient_name '/delta/'])
    for i = 1:size(source_directory,1)  % loop through source sessions
        
        %%% 1. LOAD PATIENT DATA
        
        model.patient_name   = data_directory(k).name;
        source_session       = source_directory(i).name;
        model.source_session = source_session;
        patient_coordinates = load_patient_coordinates(PATIENTPATH,[OUTDATAPATH model.patient_name ],source_session );
        
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
        model.q                  = 0.05;
        model.t                  = time;
        model.threshold          = -2.8; % cleaning threshold
        model.params.trialave = 1;                        % ... trial average.
        model.params.fpass    = [1 50.1];                 % ... freq range to pass.
        model.params.Fs       = model.sampling_frequency; % ... sampling frequency. 
        model.params.err      = [2 0.05];                 % ... Jacknife error bars, p =0.05;
        

        % 4. a) DELTA -------------------------------------------------------------
        % Delta: [2, 4]   --> W = 1,   T = 5,   2TW-1 = 9
        model.band_params = cfg_band('delta');
        model_delta       = infer_network_coherence_groupwise(model,patient_coordinates);
        
        % 4. b) SAVE DELTA DATA
        model_delta.data       = NaN;  % clear data
        model_delta.data_clean = NaN;  % clear data
        save([ OUTDATAPATH model.patient_name '/delta/' source_session(rnge) '.mat'],'model_delta','-v7.3')
        
        % 7. a) SIGMA -------------------------------------------------------------
        % Sigma: [10, 15] --> W = 2.5, T = 2,   2TW-1 = 9
        model.band_params = cfg_band('sigma');
        model_sigma       = infer_network_coherence_groupwise(model,patient_coordinates);
        
        %7. b) SAVE SIGMA DATA
        model_sigma.data = NaN;  % clear data
        model_sigma.data_clean = NaN;  % clear data
        save([ OUTDATAPATH model.patient_name '/sigma/' source_session(rnge) '.mat'],'model_sigma','-v7.3')
        
        
%         
%         h = figure;
%         set(h, 'Visible', 'off');
%         plot_patient_activity_zone(model_delta)
%         
%         saveas(h,[OUTFIGPATH model.source_session(1:17) '_delta.fig']);
%         
%         
%         f = figure;
%         set(f, 'Visible', 'off');
%         plot_patient_activity_zone(model_sigma)
%         
%         saveas(f,[OUTFIGPATH model.source_session(1:17) '_sigma.jpg']);
%         
        
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