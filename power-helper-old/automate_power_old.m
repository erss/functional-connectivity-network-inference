cfg();

global bects_default;

addpath(genpath(bects_default.bectsnetworkstoolbox))
addpath(genpath(bects_default.fcnetworkinference))
addpath(genpath(bects_default.chronuxtoolbox))
addpath(genpath(bects_default.mgh))
DATAPATH    = bects_default.datapath;
OUTDATAPATH = [bects_default.outdatapathpwr 'test/'];
    mkdir(bects_default.outdatapathpwr,test);

data_directory = dir(DATAPATH);
for k =7:37;%:10 %5:35 loop through patients
    model.method='august2';
    model.sampling_frequency = 2035;
    model.patient_name = data_directory(k).name;
    model.threshold = -2.8;
    fprintf(['Inferring power for ' model.patient_name '\n']);
    source_directory = dir([ DATAPATH data_directory(k).name '/sleep_source/*.mat']);
    mkdir(OUTDATAPATH,model.patient_name)
    mkdir([OUTDATAPATH model.patient_name],model.method)
    PATIENTPATH = [DATAPATH model.patient_name];
    addpath(PATIENTPATH)
    model.T = 1; %window_size
    
    %%% ---- Load all data into cell --------------------------------------
    data_cell = cell(2,size(source_directory,1));
    for i = 1:size(source_directory,1)
        
        %%% ---- Load source data and patient coordinate structure --------
        fprintf(['Loading source ' num2str(i) ' of ' num2str(size(source_directory,1)) '...\n'])
        source_session       = source_directory(i).name;
        load([PATIENTPATH '/sleep_source/' source_session],'data_left')
        load([PATIENTPATH '/sleep_source/' source_session],'data_right')
        load([PATIENTPATH '/sleep_source/' source_session],'time')        

        %%% --- Clean data in left SOZ and right SOZ ----------------------
        data_cell{1,i}=[data_left;data_right];
        data_cell{2,i}=time;
        
    end
    patient_coordinates = load_patient_coordinates(PATIENTPATH,[OUTDATAPATH model.patient_name ],source_session );
    
    model = infer_power_old( model, patient_coordinates,data_cell);
    save([ OUTDATAPATH model.patient_name '/' model.method '/power.mat'],'model')

    clear model
    clear patient_coordinates
    clear data_cell
    
end

