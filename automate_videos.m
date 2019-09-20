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

%%
%%% DO NOT ANALYZE patients 7,37,38
for k =6:size(data_directory,1)
    model.sampling_frequency = 407;
    model.patient_name = data_directory(k).name;
    model.threshold = -1.5;
    fprintf(['Analyzing patient ' model.patient_name '\n']);
    load([ DATAPATH data_directory(k).name '/patient_coordinates.mat'])
    load([ DATAPATH data_directory(k).name '/source_dsamp_data.mat'])
    
    PATIENTPATH = [DATAPATH model.patient_name];
    addpath(PATIENTPATH)
    model.T = 1; %window_size
    
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
        t_spike_mask_left  = create_spike_times_mask( t, spike_times_left );
        t_spike_mask_right = create_spike_times_mask( t, spike_times_right );
        
        dataL = remove_mask(data_clean(LN,:),t_spike_mask_left);
        dataR = remove_mask(data_clean(RN,:),t_spike_mask_right);
        
        
        x0 = data_clean;
        x0([LN;RN],:)=[dataL;dataR];
        
        data_clean= x0;
        
    end
    
    model.b=b;
    model.status = patient_coordinates.status;
    
    %%%%%%%%%%%%%%%%%%%%%%%% WRITE VIDEO SCRIPT TO CHECK CLEANING AND
    %%%%%%%%%%%%%%%%%%%%%%%% SPIKE REMOVAL PROCEDURE.
    [LNt,RNt] = find_subnetwork_str( patient_coordinates,'lateralorbitofrontal');
    fprintf('... plotting video for lateral orbito frontal')
    visualize_data_clean( data([LNt;RNt],:),data_clean([LNt;RNt],:), t,[OUTVIDPATH model.patient_name '_lateralorbitofrontal'] );
    
    [LNt,RNt] = find_subnetwork_str( patient_coordinates,'lingual');
    fprintf('... plotting video for lingual')
    visualize_data_clean( data([LNt;RNt],:),data_clean([LNt;RNt],:), t,[OUTVIDPATH model.patient_name '_lingual'] );
    
    [LNt,RNt] = find_subnetwork_str( patient_coordinates,'superiorfrontal');
    fprintf('... plotting video for superior frontal')
    visualize_data_clean( data([LNt;RNt],:),data_clean([LNt;RNt],:), t,[OUTVIDPATH model.patient_name '_superiorfrontal'] );
    
    [LNt,RNt] = find_subnetwork_str( patient_coordinates,'insula');
    fprintf('... plotting video for insula')
    visualize_data_clean( data([LNt;RNt],:),data_clean([LNt;RNt],:), t,[OUTVIDPATH model.patient_name '_insula'] );
    
    
    
    clear model
    clear patient_coordinates 
end