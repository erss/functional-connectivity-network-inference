%%% Load toolboxes and scripts
addpath(genpath('~/Documents/MATLAB/bects-networks-toolbox/'))
addpath(genpath('~/Documents/MATLAB/fc-network-inference-bootstrap/'))
addpath(genpath('~/Documents/MATLAB/Toolboxes/chronux/'))
addpath(genpath('~/Documents/MATLAB/Toolboxes/mgh/'))

%%% My computer
DATAPATH    = '~/Desktop/bects_data/DKData/';
OUTDATAPATH = '~/Desktop/bects_results/power - r2/';

% %%% Galactica
% DATAPATH    = '~/Desktop/bects_data/source_data_2/'
% OUTDATAPATH = '/Users/liz/Desktop/bects_results/power---NAME---/';

data_directory = dir(DATAPATH);
for k =8 %5:35 loop through patients

    model.sampling_frequency = 2035;
    model.patient_name = data_directory(k).name;
    fprintf(['Inferring power for ' model.patient_name '\n']);
    source_directory = dir([ DATAPATH data_directory(k).name '/sleep_source/*.mat']);
    
    PATIENTPATH = [DATAPATH model.patient_name];
    addpath(PATIENTPATH)
    
    dataL =[];
    dataR =[];
    dataC =[];
  
    for i = 1:size(source_directory,1)
        
        %%% ---- Load source data and patient coordinate structure --------
        fprintf(['Loading source ' num2str(i) ' of ' num2str(size(source_directory,1)) '...\n'])
        source_session       = source_directory(i).name;
        load([PATIENTPATH '/sleep_source/' source_session],'data_left')
        load([PATIENTPATH '/sleep_source/' source_session],'data_right')
        load([PATIENTPATH '/sleep_source/' source_session],'time')
        patient_coordinates = load_patient_coordinates( PATIENTPATH,source_session );
        
        %%% --- Clean data in left SOZ and right SOZ ----------------------
        [LN,RN] = find_subnetwork_coords(patient_coordinates);
        nL=length(LN);
        data =[data_left;data_right];
        [data_clean,t_clean] = remove_artifacts_zone(data([LN;RN],:),time,model.sampling_frequency);
        
        %%% ---- Convert left SOZ into 2 s trials -------------------------
        dataLt = data_clean(1:nL,:);
        dataLt = convert_to_trials( dataLt', 2*2035 );
        
        for i = size(dataLt,2):-1:1 % remove any trial that contains a nan
            dtemp = dataLt(:,i);
            if any(isnan(dtemp)) % col contains at least one nan
                dataLt(:,i)=[];
            end
            
        end
        
        %%% ---- Convert right SOZ into 2 s trials ------------------------
        dataRt = data_clean(nL+1:end,:);
        dataRt = convert_to_trials( dataRt', 2*2035 );
        for i = size(dataRt,2):-1:1 % remove any trial that contains a nan
            dtemp = dataRt(:,i);
            if any(isnan(dtemp)) % col contains at least one nan
                dataRt(:,i)=[];
            end
            
        end
        
        %%% ---- Convert left and right SOZ into 2 s trials ---------------
        dataCt = convert_to_trials( data_clean', 2*2035 );
        for i = size(dataCt,2):-1:1 % remove any trial that contains a nan
            dtemp = dataCt(:,i);
            if any(isnan(dtemp)) % col contains at least one nan
                dataCt(:,i)=[];
            end  
        end
        
        dataL = [dataL, dataLt ];
        dataR = [dataR, dataRt ];
        dataC = [dataC, dataCt ];
        
        clear data_left
        clear data_right
        
      
    end
    model.figpath = [OUTDATAPATH '/'];
    model.dataL = dataL;
    model.dataR = dataR;
    model.dataC = dataC;
    model = infer_power_soz( model);
    model=rmfield(model,'dataL');
    model=rmfield(model,'dataR');
    model=rmfield(model,'dataC');
    save([ OUTDATAPATH source_session(1:17)  '_power.mat'],'model')

end

