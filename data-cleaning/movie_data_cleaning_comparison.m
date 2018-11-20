%%% Plots intervals where two artifact removal procedures disagree.

pc=patient_coordinates_020;
% load('/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence - r1/pBECTS020_coherence.mat')
% m1 = model;
% m2 = model;
% m1.data =[data_left;data_right];
% m2.data =[data_left;data_right];

m1=model;
m2=model;

m1 = remove_artifacts_all_lobes( m1, pc);
m2 = remove_artifacts_all_lobes_hem( m2, pc);

%%
% Find all relevant subnetworks
[LNp,RNp] = find_subnetwork_lobe( pc,'parietal');
[LNt,RNt] = find_subnetwork_lobe( pc,'temporal');
[LNo,RNo] = find_subnetwork_lobe( pc,'occipital');
[LNf,RNf] = find_subnetwork_lobe( pc,'frontal');
%[LN,RN]   = find_subnetwork_central( pc);

% % Load data
% data       = model.data;
% data_clean = model.data_clean;

dp1 = m1.data_clean([LNp; RNp],:)';
dt1 = m1.data_clean([LNt; RNt],:)';
do1 = m1.data_clean([LNo; RNo],:)';
df1 = m1.data_clean([LNf; RNf],:)';

dp2 = m2.data_clean([LNp; RNp],:)';
dt2 = m2.data_clean([LNt; RNt],:)';
do2 = m2.data_clean([LNo; RNo],:)';
df2 = m2.data_clean([LNf; RNf],:)';

%% Movie for CLEAN data & ARTIFACT data
OUTVIDPATH1 = strcat('~/Desktop/',model.patient_name,'_cleaned_data_old_v_new_new_temp.avi');
v = VideoWriter(OUTVIDPATH1);
v.FrameRate=1;
v.Quality =100;
open(v);
t = model.t;
window_step = 0.5;
window_size = 0.5;
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.
h = figure('units','normalized','outerposition',[0 0 .5 1]);

for k = 1:i_total %length(t_clean)
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t>= t_start & t < t_stop;
    dtemp1 = dp1(indices,:);
    dtemp2 = dp2(indices,:);
    t1 = dtemp1(1,1);
    t2 = dtemp2(1,1);

% 
     if (isnan(t1) && isfinite(t2)) || (isfinite(t1) && isnan(t2))
        figure(h)
        subplot(4,2,1)
        plotchannels(t(indices),dp1(indices,:));
        title('Parietal')
        subplot(4,2,3)
        plotchannels(t(indices),dt1(indices,:));
        
        title('Temporal')
        subplot(4,2,5)
        plotchannels(t(indices),do1(indices,:));
        title('Occipital')
        subplot(4,2,7)
        plotchannels(t(indices),df1(indices,:));
        title('Frontal')
        
        subplot(4,2,2)
        plotchannels(t(indices),dp2(indices,:));
        title('Parietal')
        subplot(4,2,4)
        plotchannels(t(indices),dt2(indices,:));
        title('Temporal')
        subplot(4,2,6)
        plotchannels(t(indices),do2(indices,:));
        title('Occipital')
        subplot(4,2,8)
        plotchannels(t(indices),df2(indices,:));
        title('Frontal')

        drawnow
        
        suptitle(['Data - Index: ' num2str(k)])
        
        F = getframe(h);
        image = F.cdata;
        writeVideo(v,image(1:end,1:end,:));
     end
end
close(v)