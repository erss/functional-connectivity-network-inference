cfg();

global bects_default;

addpath(genpath(bects_default.bectsnetworkstoolbox))
addpath(genpath(bects_default.fcnetworkinference))
addpath(genpath(bects_default.chronuxtoolbox))
addpath(genpath(bects_default.splineGrangertoolbox))
addpath(genpath(bects_default.mgh))
DATAPATH    = bects_default.datapath;
OUTDATAPATH = bects_default.outdatapathsg;

data_directory = dir(DATAPATH);

for k= 8 % loop through patients
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
        model.window_size = 1;   % in seconds
        model.window_step = 1;   % in seconds

        model.q=0.05;
        model.nsurrogates = 10000;
        model.t=time;
        
        %%% 2b. SPLINE INFERENCE PARAMS
        model.s = 0.5;
        model.cntrl_pts = round(linspace(0,2035*0.040,5));
        model.estimated_model_order = model.cntrl_pts(end);
        %%% 3. REMOVE ARTIFACTS
        
        [model.data_clean,model.t_clean, model.b] = remove_artifacts_zone(model.data,model.t,model.sampling_frequency);
        
        %%% 4. INFER NETWORK
       
        [ model_spline] = infer_spline_granger( model);

        %%% 5. SAVE DATA
        model_spline.data = NaN;  % clear data
        model_spline.data_clean = NaN;  % clear data
        save([OUTDATAPATH model.patient_name '/' source_session(rnge)],'model_spline','-v7.3')
        
        clear model_spline
        clear model
        clear data_left
        clear data_right
        clear time
        
    end
    clear model_spline
    clear model
    clear data_left
    clear data_right
    clear time
    
end





