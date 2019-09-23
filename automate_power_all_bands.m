cfg();

global bects_default;



%%
addpath(genpath(bects_default.bectsnetworkstoolbox))
addpath(genpath(bects_default.fcnetworkinference))
addpath(genpath(bects_default.chronuxtoolbox))
addpath(genpath(bects_default.mgh))

%%% fix before SCCC
DATAPATH    = bects_default.datapath;
%%%
OUTDATAPATH = bects_default.outdatapathpwr;
OUTVIDPATH = bects_default.outvidpath;

data_directory = dir(DATAPATH);
load([DATAPATH 'npdata.mat']);
T=table;
%%
%%% DO NOT ANALYZE patients 7,37,38
for k =5:7 %[4:11 13:25 28:size(data_directory,1)] %7:37;%:10 %5:35 loop through patients
    model.sampling_frequency = 407;
    model.patient_name = data_directory(k).name;
    model.threshold = -1.5;
    fprintf(['Analyzing patient ' model.patient_name '\n']);
    mkdir(OUTDATAPATH,model.patient_name )
    load([ DATAPATH data_directory(k).name '/patient_coordinates.mat'])
    model.T = 1;
    if exist([ OUTDATAPATH model.patient_name '/power_all_bands.mat'],'file' ) == 2
        fprintf(['...file already exists for ' model.patient_name '\n'])
        load([ OUTDATAPATH model.patient_name '/power_all_bands.mat'] );
        model.OUTDATAPATH= OUTDATAPATH;
        if exist([ DATAPATH data_directory(k).name '/source_dsamp_data_clean.mat'],'file' ) == 2
            load([ DATAPATH data_directory(k).name '/source_dsamp_data_clean.mat']);
        else
            load([ DATAPATH data_directory(k).name '/source_dsamp_data.mat'])
            % Clean data
            [data_clean,b] = remove_artifacts_chrx(data,t,model.sampling_frequency,model.threshold,model.T);
            % Apply data mask & remove
            data_clean = remove_mask(data_clean,t_mask);
            % Remove spikes times
            [LN,RN]= find_subnetwork_coords(patient_coordinates);
            
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
            save([ DATAPATH data_directory(k).name '/source_dsamp_data_clean.mat'],'data_clean','cleaning_threshold','win_size','-v7.3')
            
            
        end
        model = infer_power( model, patient_coordinates,data_clean,'SOZ','individual');
        
    else
        load([ DATAPATH data_directory(k).name '/source_dsamp_data.mat'])
        
        % mkdir([OUTDATAPATH model.patient_name],model.method)
        PATIENTPATH = [DATAPATH model.patient_name];
        addpath(PATIENTPATH)
        
        fprintf('... cleaning data \n')
        % Clean data
        [data_clean,b] = remove_artifacts_chrx(data,t,model.sampling_frequency,model.threshold,model.T);
        % Apply data mask & remove
        data_clean = remove_mask(data_clean,t_mask);
        % Remove spikes times
        [LN,RN]= find_subnetwork_coords(patient_coordinates);
        
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
        
        
        model.status = patient_coordinates.status;
        cleaning_threshold = model.threshold;
        win_size = model.T;
        save([ DATAPATH data_directory(k).name '/source_dsamp_data_clean.mat'],'data_clean','cleaning_threshold','win_size','-v7.3')
        %%%%%%%%%%%%%%%%%%%%%%%% WRITE VIDEO SCRIPT TO CHECK CLEANING AND
        %%%%%%%%%%%%%%%%%%%%%%%% SPIKE REMOVAL PROCEDURE.
        fprintf('... plotting videos \n')
        %   visualize_data_clean( data([LN;RN],:),data_clean([LN;RN],:), t,[OUTVIDPATH model.patient_name '_cleaning_movie'] );
        fprintf('... inferring power \n')
        model.OUTDATAPATH = OUTDATAPATH;
        model = infer_power( model, patient_coordinates,data_clean,'SOZ','individual');
        
        save([ OUTDATAPATH model.patient_name '/power_all_bands.mat'],'model')
        
    end

    
    
    clear model
    clear patient_coordinates
end



