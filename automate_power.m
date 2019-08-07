cfg();

global bects_default;

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
for k =[4:size(data_directory,1)] %7:37;%:10 %5:35 loop through patients
    model.sampling_frequency = 407;
    model.patient_name = data_directory(k).name;
    model.threshold = -1.5;
    fprintf(['Analyzing patient ' model.patient_name '\n']);
    mkdir(OUTDATAPATH,model.patient_name )
    load([ DATAPATH data_directory(k).name '/patient_coordinates.mat'])
    
    if exist([ OUTDATAPATH model.patient_name '/power.mat'],'file' ) == 2
        fprintf(['...file already exists for ' model.patient_name '\n'])
        load([ OUTDATAPATH model.patient_name '/power.mat'] );
        
    else
        load([ DATAPATH data_directory(k).name '/source_dsamp_data.mat'])
        
        
        
        
        % mkdir([OUTDATAPATH model.patient_name],model.method)
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
            t_spike_mask_left = create_spike_times_mask( t, spike_times_left );
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
        
        visualize_data_clean( data([LN;RN],:),data_clean([LN;RN],:), t,[OUTVIDPATH model.patient_name '_cleaning_movie'] );
        fprintf('... inferring power')
        model = infer_power( model, patient_coordinates,data_clean);
        save([ OUTDATAPATH model.patient_name '/power.mat'],'model')
        
    end
    pc= patient_coordinates;
    
    fn = fieldnames(model.labels);
    for i = 1:numel(fn)
       % fprintf([num2str(i) '\n'])
        temp = model.labels.(fn{i});
        
        %%% THINGS OF INTEREST
        name = cellstr(pc.name);
        label = cellstr(fn{i});
        status = cellstr(pc.status);
        hand = cellstr(pc.hand);
        gender = cellstr(pc.gender);
        age = pc.age;
        
        
        %%% STUFF FROM TABLE
        ii = find(strcmp(npdata.ID,name)==1);
        GPBdomRaw = npdata.GPBdomRaw(ii);
        GPBdomZ   = npdata.GPBdomZ(ii);
        GPBnonRaw = npdata.GPBnonRaw(ii);
        GPBnonZ   = npdata.GPBnonZ(ii);
        PhonoAwareRaw = npdata.PhonoAwareRaw(ii);
        PhonoAwareZ =npdata.PhonoAwareZ(ii);
        spiking_hem = npdata.SpikingHemisphere(ii);
        %%% ANALYSIS
        
        if isfield(temp,'warning_msg')
            sbratio = nan;
            total_power = nan;
            sigma_bump =nan;
            
            ntrials = nan;
            ntrials_removed = nan;
        else
            sbratio = temp.sbratio;
            total_power = temp.total_power;
            
            ntrials = temp.ntrials;
            ntrials_removed = temp.ntrials_removed;
            sigma_bump = temp.sigma_bump;
        end
        
        T_temp = table(name,status,label,hand,gender,age, spiking_hem,...
            sbratio,sigma_bump,total_power,ntrials,ntrials_removed, ...
            GPBdomRaw,GPBdomZ,GPBnonRaw,GPBnonZ,PhonoAwareRaw,PhonoAwareZ);
        T = [T;T_temp];
        
        
    end
    
    
    clear model
    clear patient_coordinates
end

    save([ OUTDATAPATH 'sigma_bump_table.mat'],'T')


