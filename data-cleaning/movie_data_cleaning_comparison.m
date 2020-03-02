%%% Plots intervals where two artifact removal procedures disagree.

pc=patient_coordinates;



%%
% Find all relevant subnetworks
[LN,RN] = find_subnetwork_coords( pc);
data_spikes_included_soz = data_clean_spikes_included([LN;RN],:)';
data_spikes_removed_soz = data_clean_spikes_removed([LN;RN],:)';


%% Movie for CLEAN data & ARTIFACT data
OUTVIDPATH1 = ['~/Desktop/pBECTS040_cleaned_spikes_w_o_spikes.avi'];
v = VideoWriter(OUTVIDPATH1);
v.FrameRate=1;
v.Quality =100;
open(v);
t =(1:size(data_spikes_included_soz,1))/407;
window_step = 2;
window_size = 2;
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.
h = figure('units','normalized','outerposition',[0 0 .5 1]);

for k = 1:i_total %length(t_clean)
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t>= t_start & t < t_stop;
    dsi = data_spikes_included_soz(indices,:);
    dsr = data_spikes_removed_soz(indices,:);
    
    figure(h)
    subplot(2,1,1)
    plotchannels(t(indices),dsi);
    title('Spikes Included')
    subplot(2,1,2)
    plotchannels(t(indices),dsr);
    
    title('Spike Removed')
    
    
    drawnow
    
    suptitle(['Data - Index: ' num2str(k)])
    
    F = getframe(h);
    image = F.cdata;
    writeVideo(v,image(1:end,1:end,:));
    
end
close(v)