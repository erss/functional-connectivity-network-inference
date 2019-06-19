%%% Makes two movies: one with data marked as an artifact and one that is
%%% all the data that passes as clean
cfg();

global bects_default;

addpath(genpath(bects_default.bectsnetworkstoolbox))
addpath(genpath(bects_default.fcnetworkinference))
addpath(genpath(bects_default.chronuxtoolbox))
addpath(genpath(bects_default.mgh))
DATAPATH    = bects_default.datapath;
OUTDATAPATH = bects_default.outmoviepath;
RESULTSPATH = bects_default.outdatapathcc;

data_directory = dir(RESULTSPATH);
%%
for idx=5
    patient_name = data_directory(idx).name;
    mkdir(OUTDATAPATH,patient_name)
    fprintf([patient_name '\n']);
  
    
    PATIENTPATH = [DATAPATH patient_name];
    addpath(PATIENTPATH)
    load([RESULTSPATH patient_name '/patient_coordinates']);
  
    source_directory = dir([ PATIENTPATH '/sleep_source/*.mat']);  
  pc=patient_coordinates;
  data=[];
  t =[];
  fprintf('Loading source sessions ... \n')
   for i = 1:6%:size(source_directory,1)
      source_session       = source_directory(i).name
        load([PATIENTPATH '/sleep_source/' source_session],'data_left')
        load([PATIENTPATH '/sleep_source/' source_session],'data_right')
        load([PATIENTPATH '/sleep_source/' source_session],'time')
        
        dtemp = [data_left;data_right];
  
    data =[data, dtemp];
    if i >1
     time = time + t(end)- time(1);
    end
    t=[t time];
   
    
   end
    [ LN,RN ] = find_subnetwork_coords( pc);
    % [PreN,PostN] = find_subnetwork_prepost(pc);
    fprintf('Removing artifacts... \n')
    [data_clean,t_clean, b] = remove_artifacts_zone(data([LN;RN],:),t,2035);
    %%
    d          = data([LN; RN],:)';
    dc         = data_clean';
    %% Movie for CLEAN data & ARTIFACT data
    OUTVIDPATH1 = [OUTDATAPATH patient_name '/' patient_name '_v1_thresh_2.8_clean.avi']; 
    OUTVIDPATH2 = [OUTDATAPATH patient_name '/' patient_name '_v1_thresh_2.8_artifact.avi']; 
    v = VideoWriter(OUTVIDPATH1);
    v.FrameRate=1;
    open(v);
    
    q = VideoWriter(OUTVIDPATH2);
    q.FrameRate=1;
    open(q);
    
    window_step =0.5;
    window_size =0.5;
    i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.
    %h = figure('units','normalized','outerposition',[0 0 .5 1]);
    h=figure;
    g=figure;
    
    for k = 1:i_total %length(t_clean)
        t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
        t_stop  = t_start + window_size;                  %... get window stop time [s],
        indices = t_clean >= t_start & t_clean < t_stop;
        
        if sum(indices)~=0
            figure(h)
            dtemp=dc(indices,:);
            plotchannels(t_clean(indices),dtemp);
            title(['Clean LN + RN ' num2str(k)])
            
            F = getframe(h);
            image = F.cdata;
            writeVideo(v,image(1:end,1:end,:));
        else
            t_start2 = t(1) + (k-1) * window_step;   %... get window start time [s],
            t_stop2  = t_start2 + window_size;                  %... get window stop time [s],
            indices2 = t >= t_start2 & t < t_stop2;
            figure(g)
            dtemp=d(indices2,:);
            plotchannels(t(indices2),dtemp);
            title(['Artifact LN + RN: ' num2str(k)])
            
            F = getframe(g);
            image = F.cdata;
            writeVideo(q,image(1:end,1:end,:));
        end
        
    end
    close(v)
    close(q)
    close all
    
end