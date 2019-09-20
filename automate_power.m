cfg();

global bects_default;
%%
addpath(genpath(bects_default.bectsnetworkstoolbox))
addpath(genpath(bects_default.fcnetworkinference))
addpath(genpath(bects_default.chronuxtoolbox))
addpath(genpath(bects_default.mgh))

%%% fix before SCC
DATAPATH    = bects_default.datapath;
%%%
OUTDATAPATH = bects_default.outdatapathpwr;
OUTVIDPATH = bects_default.outvidpath;
data_directory = dir(DATAPATH);
load([DATAPATH 'npdata.mat']);
T=table;
%%
%%% DO NOT ANALYZE patients 7,37,38
for k =12% , 30]%[4:10 12:25 28:size(data_directory,1)] %[4:11 13:25 28:size(data_directory,1)] %7:37;%:10 %5:35 loop through patients
    model.sampling_frequency = 407;
    model.patient_name = data_directory(k).name;
    model.threshold = -1.5;
    model.T = 1; %window_size
    fprintf(['Analyzing patient ' model.patient_name '\n']);
    mkdir(OUTDATAPATH,model.patient_name )
    load([ DATAPATH data_directory(k).name '/patient_coordinates.mat'])
    
    if exist([ OUTDATAPATH model.patient_name '/power.mat'],'file' ) == 2
        fprintf(['...file already exists for ' model.patient_name '\n'])
        load([ OUTDATAPATH model.patient_name '/power.mat'] );
        if  exist([ DATAPATH data_directory(k).name '/source_dsamp_data_clean.mat'],'file' ) == 2
            load([ DATAPATH data_directory(k).name '/source_dsamp_data_clean.mat']);
            
        else
            fprintf('... cleaning data \n')
            % Clean data
            [data_clean,b] = remove_artifacts_chrx(data,t,model.sampling_frequency,model.threshold,model.T);
            % Apply data mask & remove
            data_clean = remove_mask(data_clean,t_mask);
            % Remove spikes times
            [LN,RN]= find_subnetwork_coords(patient_coordinates);
            %%%%%%%%%%%% FIX THIS IS WRONG THIS GETS RID OF ALL DATA !!!!!
            if ~strcmp(patient_coordinates.status,'Healthy')
                load([ DATAPATH data_directory(k).name '/spike_times.mat'])
                nL = length(LN);
                t_spike_mask_left = create_spike_times_mask( t, spike_times_left );
                t_spike_mask_right = create_spike_times_mask( t, spike_times_right );
                
                dataL = remove_mask(data_clean(LN,:),t_spike_mask_left);
                dataR = remove_mask(data_clean(RN,:),t_spike_mask_right);
                
                
                x0 = data_clean;
                x0([LN;RN],:)=[dataL;dataR];
                
                data_clean= x0;
                
            end
            cleaning_threshold = model.threshold;
            win_size = model.T;
            save([ DATAPATH data_directory(k).name '/source_dsamp_data_clean.mat'],'data_clean','cleaning_threshold','win_size')
        end
        
        model = infer_power( model, patient_coordinates,data_clean,'SOZ','individual');
    else
        load([ DATAPATH data_directory(k).name '/source_dsamp_data.mat'])
        
        
        
        
        % mkdir([OUTDATAPATH model.patient_name],model.method)
        PATIENTPATH = [DATAPATH model.patient_name];
        addpath(PATIENTPATH)
        
        if  exist([ DATAPATH data_directory(k).name '/source_dsamp_data_clean.mat'],'file' ) == 2
            load([ DATAPATH data_directory(k).name '/source_dsamp_data_clean.mat']);
            
        else
            fprintf('... cleaning data \n')
            % Clean data
            [data_clean,b] = remove_artifacts_chrx(data,t,model.sampling_frequency,model.threshold,model.T);
            % Apply data mask & remove
            data_clean = remove_mask(data_clean,t_mask);
            % Remove spikes times
            [LN,RN]= find_subnetwork_coords(patient_coordinates);
            %%%%%%%%%%%% FIX THIS IS WRONG THIS GETS RID OF ALL DATA !!!!!
            if ~strcmp(patient_coordinates.status,'Healthy')
                load([ DATAPATH data_directory(k).name '/spike_times.mat'])
                nL = length(LN);
                t_spike_mask_left = create_spike_times_mask( t, spike_times_left );
                t_spike_mask_right = create_spike_times_mask( t, spike_times_right );
                
                dataL = remove_mask(data_clean(LN,:),t_spike_mask_left);
                dataR = remove_mask(data_clean(RN,:),t_spike_mask_right);
                
                
                x0 = data_clean;
                x0([LN;RN],:)=[dataL;dataR];
                
                data_clean= x0;
                
            end
            cleaning_threshold = model.threshold;
            win_size = model.T;
            save([ DATAPATH data_directory(k).name '/source_dsamp_data_clean.mat'],'data_clean','cleaning_threshold','win_size')
        end
        
        model.b=b;
        model.status = patient_coordinates.status;
        
        %%%%%%%%%%%%%%%%%%%%%%%% WRITE VIDEO SCRIPT TO CHECK CLEANING AND
        %%%%%%%%%%%%%%%%%%%%%%%% SPIKE REMOVAL PROCEDURE.
        fprintf('... plotting videos')
        % visualize_data_clean( data([LN;RN],:),data_clean([LN;RN],:), t,[OUTVIDPATH model.patient_name '_cleaning_movie_2'] );
        fprintf('... inferring power')
        model = infer_power( model, patient_coordinates,data_clean,'SOZ','individual');
        save([ OUTDATAPATH model.patient_name '/power.mat'],'model')
        clear model
        clear patient_coordinates
        
    end
end







