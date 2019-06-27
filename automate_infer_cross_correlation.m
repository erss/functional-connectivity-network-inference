cfg();

global bects_default;

addpath(genpath(bects_default.bectsnetworkstoolbox))
addpath(genpath(bects_default.fcnetworkinference))
addpath(genpath(bects_default.chronuxtoolbox))
addpath(genpath(bects_default.mgh))
DATAPATH    = bects_default.datapath;
OUTDATAPATH = bects_default.outdatapathcc;

data_directory = dir(DATAPATH);

for k= 6;%[15 37] % loop through patients
    model.patient_name = data_directory(k).name;
    mkdir(OUTDATAPATH,model.patient_name)
    fprintf([model.patient_name '\n']);
    source_directory = dir([ DATAPATH data_directory(k).name '/sleep_source/*.mat']);
    
    PATIENTPATH = [DATAPATH model.patient_name];
    addpath(PATIENTPATH)
    for i = 1:size(source_directory,1)  %4  % loop through source sessions
        model.patient_name = data_directory(k).name;
        source_session       = source_directory(i).name;
        model.source_session = source_session;
        patient_coordinates = load_patient_coordinates(PATIENTPATH,[OUTDATAPATH model.patient_name ],source_session );
        
        if strcmp(source_session(11),'r')
            rnge = 1:17;
        else
            rnge = 1:18;
        end
        %%% 1. LOAD DATA
        load([PATIENTPATH '/sleep_source/' source_session],'data_left')
        load([PATIENTPATH '/sleep_source/' source_session],'data_right')
        load([PATIENTPATH '/sleep_source/' source_session],'time')
        
        [LN,RN]=find_subnetwork_coords(patient_coordinates);
        model.data = [data_left;data_right];
        model.data = model.data([LN;RN],:);
        
        %%% 2. LOAD MODEL PARAMETERS
        model.sampling_frequency = 2035;
        model.window_step = 1;% 0.5; % in seconds
        model.window_size = 1;   % in seconds
        model.q=0.05;
        model.nsurrogates = 10000;
        model.t=time;
        model.threshold = -2.8;
        %%% 3. REMOVE ARTIFACTS
        
        
        [model.data_clean,model.t_clean, model.b] = remove_artifacts(model.data,model.t,...
            model.sampling_frequency,model.threshold);
        
        
        %%% 4. INFER NETWORK
        model_cross_corr = infer_network_correlation( model);
        %%% 5. SAVE DATA
        model_cross_corr.data = NaN;  % clear data
        model_cross_corr.data_clean = NaN;  % clear data
        save([OUTDATAPATH model.patient_name '/' source_session(rnge)],'model_cross_corr','-v7.3')
        
        clear model_cross_corr
        clear model
        clear data_left
        clear data_right
        clear time
        
    end
    clear model_cross_corr
    clear model
    clear data_left
    clear data_right
    clear time
    
end





