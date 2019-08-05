%%% Visualize masked downsampled videos for Galactica

% OUTVIDPATH = ['/projectnb/ecog/BECTS/downsampled_videos/' patient '_n2_sleep.avi'];
% load(['/projectnb/ecog/BECTS/source_data_ds/' patient '/source_dsamp_data.mat'])
% load(['/projectnb/ecog/BECTS/source_data_ds/' patient '/patient_coordinates.mat'])

data_dir = dir('~/Desktop/source_data_ds/');
for ii=3:size(data_dir,1)
    patient = data_directory(ii).name;
    fprintf(['Making ' patient ' data video.\n']);

    OUTVIDPATH = ['~/Desktop/downsampled_videos/' patient '_n2_sleep.avi'];
load(['/Desktop/source_data_ds/' patient '/source_dsamp_data.mat'])
load(['/Desktop/source_data_ds/' patient '/patient_coordinates.mat'])

    
[LN,RN] = find_subnetwork_coords(patient_coordinates);
data = data([LN;RN],:);

i_mask = isfinite(t_mask);
data_mask = bsxfun(@times,data,i_mask);

v = VideoWriter(OUTVIDPATH); % path to save video, 'v'
v.FrameRate=15;              % frames/sec
open(v);
window_size = 1;
window_step = 1;
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.

h=figure('visible','off');
for k=1:i_total
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
   
    plotchannels(t(indices),data_mask(:,indices)')
    title([num2str(k) '/' num2str(i_total) ', b=' num2str(b(k))])
    F = getframe(h); % ***
    image = F.cdata; % ***
    writeVideo(v,image(1:end,1:end,:)); % ***
     fprintf(['Plotting image ' num2str(k) '/' num2str(i_total) '.\n'])

end
close(v) % *** If you don't have this line then it will never finish writing
         %     which is the problem I was having
end