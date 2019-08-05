%%% Automated procedure to concatenate data into new file with three
%%% entries:
%%% data = data downsampled by a factor of 5, 2035/5 = 407 Hz
%%% t    = time axis starting from 0
%%% t_mask = variable t, but indices marked as nan for intervals that are
%%%          not true n2 sleep, to remove these times from data apply the
%%%          following commands: 
%%%          i_mask = isfinite(t_mask);
%%%%         data_clean = bsxfun(@times,data,i_mask);

DATAPATH    = '/projectnb/ecog/BECTS/source_data/';
OUTDATAPATH = '/projectnb/ecog/BECTS/source_data_ds/';
data_directory = dir(DATAPATH);


spindleDataTable;
patient_names=spindleObs(:,1);
patient_names=categorical(cellstr(patient_names));

for k=10:size(data_directory,1) % patient pBECTS001
    mkdir(OUTDATAPATH,[data_directory(k).name '/'])
    fprintf(['Concatenating ' data_directory(k).name ' data\n']);
    source_directory = dir([ DATAPATH data_directory(k).name '/sleep_source/*.mat']);
    PATIENTPATH = [DATAPATH data_directory(k).name];
    addpath(PATIENTPATH)
    
    %%% ---- Load all data into cell --------------------------------------
    r = 5;
    Fs = 2035;
    data_cat_dec=[];
    t = 0;
    for i = 1:size(source_directory,1)
        
        %%% ---- Load source data and patient coordinate structure --------
        fprintf(['Loading source ' num2str(i) ' of ' num2str(size(source_directory,1)) '...\n'])
        source_session       = source_directory(i).name;
        load([PATIENTPATH '/sleep_source/' source_session],'data_left')
        load([PATIENTPATH '/sleep_source/' source_session],'data_right')
        
        %%% --- Clean data in left SOZ and right SOZ ----------------------
        
        data = [data_left;data_right];
        y=[];
        for ii=1:size(data,1)
            y(ii,:) = decimate(data(ii,:),r);
        end
        data_cat_dec = [data_cat_dec, y];
        t = t + size(data,2);
    end
    
    time_cat = (0:t-1)./Fs;
    Fss = Fs/r;
    time_cat_dec =(0:size(data_cat_dec,2)-1)./Fss;
    
    data = data_cat_dec;
    t = time_cat_dec;
    
    %%%%%% create time mask
    t_mask = nan(size(t));
    nm =data_directory(k).name;
    p=find(patient_names==nm);
    times_mask = spindleObs(p,2);
    for ti = 1:size(times_mask{1},1)
        t1 = times_mask{1}{ti}(1);
        t2 = times_mask{1}{ti}(2);
        if t2==endNum
            time_indices = t >=t1;
            t_mask(time_indices) = ones(1,sum(time_indices));
        else
            time_indices = t >=t1 & t <=t2;
            t_mask(time_indices) = ones(1,sum(time_indices));
        end
    end
    
    t_mask = t_mask.*t;
    
    save([OUTDATAPATH data_directory(k).name '/source_dsamp_data.mat'],'data','t','t_mask','-v7.3')
end
