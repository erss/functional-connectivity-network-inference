%%% Plots data post cleaning and corresponding networks

%%
% load('/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence - r1/pBECTS020_coherence.mat')
% load('/Users/erss/Documents/MATLAB/pBECTS020/patient_coordinates_020.mat')
% load('/Users/erss/Documents/MATLAB/pBECTS020/pBECTS020_rest03_source.mat')
% 
%  model.patient_name = 'pBECTS020';
%%
model = model_sigma_two;
pc=patient_coordinates_003;
model.data =[data_left;data_right];
[ model, bvalues ] = remove_artifacts_all_lobes( model, pc);
%% Find all relevant subnetworks
[LNp,RNp] = find_subnetwork_lobe( pc,'parietal');
[LNt,RNt] = find_subnetwork_lobe( pc,'temporal');
[LNo,RNo] = find_subnetwork_lobe( pc,'occipital');
[LNf,RNf] = find_subnetwork_lobe( pc,'frontal');
[LN,RN]   = find_subnetwork_central( pc);
left_net = [LNp;LNt;LNo;LNf];
right_net = [RNp;RNt;RNo;RNf];
ii = 1:324;
ii([left_net;right_net])=[];
% Load data
data       = model.data;
data_clean = model.data_clean;

dpc = data_clean([LNp; RNp],:)';
dtc = data_clean([LNt; RNt],:)';
doc = data_clean([LNo; RNo],:)';
dfc = data_clean([LNf; RNf],:)';
%dc  = data_clean([LN; RN],:)';
dleftover = data_clean(ii,:)';
%%% Movie for CLEAN data & ARTIFACT data
OUTVIDPATH1 = strcat('~/Desktop/',model.patient_name,'_cleaned_network_05.avi');
v = VideoWriter(OUTVIDPATH1);
v.FrameRate=1;
open(v);

t = model.t;
t_clean = model.t_clean;
window_step = 1;
window_size = 2;
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.
%h = figure('units','normalized','outerposition',[0 0 .5 1]);
h=figure;
for k = 1:i_total %length(t_clean)
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
    
   
        figure(h)
        subplot(2,3,1)
        plotchannels(t(indices),dpc(indices,:));
        title('Parietal')
        
        subplot(2,3,2)
        plotchannels(t(indices),dtc(indices,:));
        title('Temporal')
        
        subplot(2,3,4)
        plotchannels(t(indices),doc(indices,:));
        title('Occipital')
        
        subplot(2,3,5)
        plotchannels(t(indices),dfc(indices,:));
        title('Frontal')
        
        h1=subplot(2,3,3);
        plotNetwork(model.net_coh([LN;RN],[LN;RN],k),h1)
        
        subplot(2,3,6)
        plotchannels(t(indices),dleftover(indices,:));
        
        drawnow
        
        suptitle(['Index: ' num2str(k)])
        
        
        F = getframe(h);
        image = F.cdata;
        writeVideo(v,image(1:end,1:end,:));
    
end
close(v)
