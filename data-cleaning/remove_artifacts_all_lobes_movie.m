%%% Create visual for artifacts removed and not removed! Given t_ckean

%%
% load('/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence_imaginary/pBECTS006_coherence.mat')
% load('/Users/erss/Documents/MATLAB/pBECTS006/patient_coordinates_006.mat')
% load('/Users/erss/Documents/MATLAB/pBECTS006/pBECTS006_sleep07_source.mat')


%%
pc=patient_coordinates_003;
 model.data =[data_left;data_right];


 model.patient_name = 'pBECTS003'
[ model, bvalues ] = remove_artifacts_all_lobes( model, pc);
%% Find all relevant subnetworks
[LNp,RNp] = find_subnetwork_lobe( pc,'parietal');
[LNt,RNt] = find_subnetwork_lobe( pc,'temporal');
[LNo,RNo] = find_subnetwork_lobe( pc,'occipital');
[LNf,RNf] = find_subnetwork_lobe( pc,'frontal');
[LN,RN]   = find_subnetwork_central( pc);
left_net = [LNp;LNt;LNo;LNf;LN];
right_net = [RNp;RNt;RNo;RNf;RN];
ii = 1:324;
ii([left_net;right_net])=[];
% Load data
data       = model.data;
data_clean = model.data_clean;

dp = data([LNp; RNp],:)';
dt = data([LNt;LN; RNt;RN],:)';
do = data([LNo; RNo],:)';
df = data([LNf; RNf],:)';
%d  = data([LN; RN],:)';

dpc = data_clean([LNp; RNp],:)';
dtc = data_clean([LNt;LN; RNt;RN],:)';
doc = data_clean([LNo; RNo],:)';
dfc = data_clean([LNf; RNf],:)';
%dc  = data_clean([LN; RN],:)';
dleftover = data_clean(ii,:)';
% Movie for CLEAN data & ARTIFACT data
OUTVIDPATH1 = strcat('~/Desktop/',model.patient_name,'_cleaned_data_old.avi');
OUTVIDPATH2 = strcat('~/Desktop/',model.patient_name,'_artifacts_old.avi');
v = VideoWriter(OUTVIDPATH1);
v.FrameRate=1;
open(v);

q = VideoWriter(OUTVIDPATH2);
q.FrameRate=1;
open(q);
t = model.t;
t_clean = model.t_clean;
window_step = 1;
window_size =2;
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
        subplot(2,3,1)
        plotchannels(t_clean(indices),dpc(indices,:));
        title('Parietal')
        subplot(2,3,2)
        plotchannels(t_clean(indices),dtc(indices,:));
        
        title('Temporal')
        subplot(2,3,4)
        plotchannels(t_clean(indices),doc(indices,:));
        title('Occipital')
        subplot(2,3,5)
        plotchannels(t_clean(indices),dfc(indices,:));
        title('Frontal')
        
        h1=subplot(2,3,3)
        plotNetwork(model.net_coh([LN;RN],[LN;RN],k),h1)
        
        subplot(2,3,6)
        plotchannels(t_clean(indices),dleftover(indices,:));
        
%         subplot(3,2,5)
%         plotchannels(t_clean(indices),dc(indices,:));
%         title('Post/pre CG,')
        
        drawnow
        
        suptitle(['Clean Data - Index: ' num2str(k)])
        
        
        F = getframe(h);
        image = F.cdata;
        writeVideo(v,image(1:end,1:end,:));
    else
        t_start2 = t(1) + (k-1) * window_step;   %... get window start time [s],
        t_stop2  = t_start2 + window_size;                  %... get window stop time [s],
        indices2 = t >= t_start2 & t < t_stop2;
        figure(g)
        subplot(2,2,1)
        plotchannels(t(indices2),dp(indices2,:));
        title('Parietal')
        subplot(2,2,2)
        plotchannels(t(indices2),dt(indices2,:));
        
        title('Temproal')
        subplot(2,2,3)
        plotchannels(t(indices2),do(indices2,:));
        title('Occipital')
        subplot(2,2,4)
        plotchannels(t(indices2),df(indices2,:));
        title('Frontal')
        
%         subplot(3,2,5)
%         plotchannels(t(indices2),d(indices2,:));
%         title('Post/pre CG,')
        
        drawnow
        
        suptitle(['Artifact Data - Index: ' num2str(k)])
        
        
        F = getframe(g);
        image = F.cdata;
        writeVideo(q,image(1:end,1:end,:));
    end
    
end
close(v)
close(q)