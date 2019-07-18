cfg();

global bects_default;

addpath(genpath(bects_default.bectsnetworkstoolbox))
addpath(genpath(bects_default.fcnetworkinference))
addpath(genpath(bects_default.chronuxtoolbox))
addpath(genpath(bects_default.mgh))
DATAPATH    = bects_default.datapath;
OUTDATAPATH = '~/Documents/BECTS-project/bects_results/test/';

data_directory = dir(DATAPATH);
for k =6;%:10 %5:35 loop through patients
    model.method = 'old';
    model.sampling_frequency = 2035;
    model.patient_name = data_directory(k).name;
    model.threshold = -2.8;
    fprintf(['Inferring power for ' model.patient_name '\n']);
    source_directory = dir([ DATAPATH data_directory(k).name '/sleep_source/*.mat']);
    mkdir(OUTDATAPATH,model.patient_name)
    mkdir([OUTDATAPATH model.patient_name],model.method)
    PATIENTPATH = [DATAPATH model.patient_name];
    addpath(PATIENTPATH)
    T = 1; %window_size
    dataL =[];
    dataR =[];
    dataC =[];
     time_clean_cell = cell(1,size(source_directory,1));
    for i = 1:1l%size(source_directory,1)
        
        %%% ---- Load source data and patient coordinate structure --------
        fprintf(['Loading source ' num2str(i) ' of ' num2str(size(source_directory,1)) '...\n'])
        source_session       = source_directory(i).name;
        load([PATIENTPATH '/sleep_source/' source_session],'data_left')
        load([PATIENTPATH '/sleep_source/' source_session],'data_right')
        load([PATIENTPATH '/sleep_source/' source_session],'time')
        patient_coordinates = load_patient_coordinates(PATIENTPATH,[OUTDATAPATH model.patient_name ],source_session );
        
        %%% --- Clean data in left SOZ and right SOZ ----------------------
        [LN,RN] = find_subnetwork_coords(patient_coordinates);
        nL=length(LN);
        data =[data_left;data_right];
        [data_clean,time_clean_cell{i}] = remove_artifacts(data([LN;RN],:),time,model.sampling_frequency,model.threshold);
        
        %%% ---- Convert left SOZ into 1 s trials -------------------------
        dataLt = data_clean(1:nL,:);
        dataLt = convert_to_trials( dataLt', T*2035 );
        
        for ii = size(dataLt,2):-1:1 % remove any trial that contains a nan
            dtemp = dataLt(:,ii);
            if any(isnan(dtemp)) % col contains at least one nan
                dataLt(:,ii)=[];
            end
            
        end
        
        %%% ---- Convert right SOZ into 1 s trials ------------------------
        dataRt = data_clean(nL+1:end,:);
        dataRt = convert_to_trials( dataRt', T*2035 );
        for ii = size(dataRt,2):-1:1 % remove any trial that contains a nan
            dtemp = dataRt(:,ii);
            if any(isnan(dtemp)) % col contains at least one nan
                dataRt(:,ii)=[];
            end
            
        end
        
        %%% ---- Convert left and right SOZ into 1 s trials ---------------
        dataCt = convert_to_trials( data_clean', T*2035 );
        for ii = size(dataCt,2):-1:1 % remove any trial that contains a nan
            dtemp = dataCt(:,ii);
            if any(isnan(dtemp)) % col contains at least one nan
                dataCt(:,ii)=[];
            end
        end
        
        dataL = [dataL, dataLt ];
        dataR = [dataR, dataRt ];
        dataC = [dataC, dataCt ];
        
        clear data_left
        clear data_right
        
        
        
    end
    if ~isempty(dataL) && ~isempty(dataR) && ~isempty(dataC)
        model.t = time;
        model.t_clean = t_clean;
        model.figpath = OUTDATAPATH;
        model.dataL = dataL;
        model.dataR = dataR;
        model.dataC = dataC;
        model = infer_power_soz( model);
        model=rmfield(model,'dataL');
        model=rmfield(model,'dataR');
        model=rmfield(model,'dataC');
        save([ OUTDATAPATH model.patient_name '/' model.method '/power.mat'],'model')
    end
    
    clear model
    clear patient_coordinates
    clear dataL
    clear dataR
    clear dataC
    clear dataLt
    clear dataRt
    clear dataCt
    
end

