
cfg();

global bects_default;

addpath(genpath(bects_default.bectsnetworkstoolbox))
addpath(genpath(bects_default.fcnetworkinference))
addpath(genpath(bects_default.chronuxtoolbox))
addpath(genpath(bects_default.mgh))
DATAPATH    = bects_default.datapath;
OUTDATAPATH = '~/Documents/BECTS-project/bects_results/test/';
data_directory =dir(DATAPATH);

%%% Plots intervals where two artifact removal procedures disagree.
k=6;
model.method='new';
model.sampling_frequency = 2035;
model.patient_name = data_directory(k).name;
model.threshold = -2.8;
fprintf(['Inferring power for ' model.patient_name '\n']);
source_directory = dir([ DATAPATH data_directory(k).name '/sleep_source/*.mat']);
mkdir(OUTDATAPATH,model.patient_name)
mkdir([OUTDATAPATH model.patient_name],model.method)
PATIENTPATH = [DATAPATH model.patient_name];
addpath(PATIENTPATH)
model.T = 0.5; %window_size


%%% ---- Load all data into cell --------------------------------------
%data_cell = cell(2,size(source_directory,1));
data_cell = cell(2,2);

for i = 1:2%size(source_directory,1)
    
    
    %%% ---- Load source data and patient coordinate structure --------
    fprintf(['Loading source ' num2str(i) ' of ' num2str(size(source_directory,1)) '...\n'])
    source_session       = source_directory(i).name;
    
    patient_coordinates = load_patient_coordinates(PATIENTPATH,[OUTDATAPATH model.patient_name ],source_session );
    [LN,RN] = find_subnetwork_coords(patient_coordinates);
    load([PATIENTPATH '/sleep_source/' source_session],'data_left')
    load([PATIENTPATH '/sleep_source/' source_session],'data_right')
    load([PATIENTPATH '/sleep_source/' source_session],'time')
    
    %%% --- Clean data in left SOZ and right SOZ ----------------------
    dtemp = [data_left;data_right];
    data_cell{1,i}=dtemp([LN;RN],:);
    data_cell{2,i}=time;
    
end

t = [data_cell{2,1}, data_cell{2,2}-data_cell{2,2}(1)+1/2035+data_cell{2,1}(end)];
%, ...

%data_cell{2,2}-data_cell{2,2}(1)+1/2035+data_cell{2,1}(end) ...
 
%data_cell{2,2}-data_cell{2,2}(1)+1/2035+data_cell{2,1}(end)]

%%
data_clean_both = [];
data_clean_LN   = [];
data_clean_RN   = [];
data            = [];
nL = length(LN);
for i = 1:size(data_cell,2)
    dtemp = data_cell{1,i};
    
    d1 = remove_artifacts(dtemp,data_cell{2,i},model.sampling_frequency,model.threshold);
    data_clean_both = [data_clean_both, d1];
    
    d2= remove_artifacts(dtemp(1:nL,:),data_cell{2,i},model.sampling_frequency,model.threshold);
    data_clean_LN = [data_clean_LN,d2];
    
    
    d3= remove_artifacts(dtemp(nL+1:end,:),data_cell{2,i},model.sampling_frequency,model.threshold);
    data_clean_RN = [data_clean_RN,d3];
    
    data = [data,dtemp];
end


%% Movie for CLEAN data & ARTIFACT data
taxis=t;
OUTVIDPATH1 = strcat('~/Desktop/',model.patient_name,'_cleaning_comp_small_1s.avi');
v = VideoWriter(OUTVIDPATH1);
v.FrameRate=1;
v.Quality =100;
open(v);
window_size = 1;
window_step = 1;
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.
h = figure('units','normalized','outerposition',[0 0 .5 1]);

for k = 1:i_total %length(t_clean)
h = figure('units','normalized','outerposition',[0 0 .5 1]);

    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
    
   
    
    dtemp1a = data(1:nL,indices)';
    dtemp1b = data(nL+1:end,indices)';
    
    dtemp2a = data_clean_LN(:,indices)';
    dtemp2b = data_clean_RN(:,indices)';

    dtemp3a = data_clean_both(1:nL,indices)';
    dtemp3b = data_clean_both(nL+1:end,indices)';
    
    
    
    figure(h)
    subplot(3,2,1)
    plotchannels(taxis(indices),dtemp1a);
    title('Original - LN')
    
    subplot(3,2,2)
    plotchannels(taxis(indices),dtemp1b);
    title('Original - RN');
    
    
    subplot(3,2,3)
    plotchannels(taxis(indices),dtemp2a);
    title('Cleaned on Left Only')
    
    subplot(3,2,4)
    plotchannels(taxis(indices),dtemp2b);
    title('Cleaned on Right Only')
    
    subplot(3,2,5)
    plotchannels(taxis(indices),dtemp3a);
    title('Cleaned on both - LN')
    
    subplot(3,2,6)
    plotchannels(taxis(indices),dtemp3b);
    title('Cleaned on both - RN')
    
    
    
    
    drawnow
    
    suptitle(['Data - Index: ' num2str(k)])
    
    F = getframe(h);
    image = F.cdata;
    writeVideo(v,image(1:end,1:end,:));
    
end
close(v)

%%%%
% sum(isnan(data_clean_LN(1,:)))
% 
% ans =
% 
%      1319731
% 
% sum(isnan(data_clean_RN(1,:)))
% 
% ans =
% 
%       215715
% 
% sum(isnan(data_clean_both(1,:)))
% 
% ans =
% 
%       554560