function visualize_data_clean( data_original,data_clean, t, OUTVIDPATH)
% Makes video of data in 1 s intervals.  Top subplot indicates data that
% has been marked as good to analyze, bottom subplot has been removed from
% analysis.
% 
% INPUTS:
% data_original = [n-electrodes x n-timepoints] original electrode
%                  recordings
% data_clean    = [n-electrodes x n-timepoints] electrode recordings where
%                 time points to be ignored are marked as nan
% t             = [1 x n-timepoints] taxis
% OUTVIDPATH    = path to save video


v = VideoWriter(OUTVIDPATH); % path to save video, 'v'
v.FrameRate=15;              % frames/sec
open(v);
window_size = 1;
window_step = 1;
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.
h = figure('units','normalized','outerposition',[0 0 .5 1],'visible','off');


% 
data_temp = data_original(:);
data_temp(isfinite(data_clean)) = nan;
data_removed = reshape(data_temp,size(data_clean));


%h=figure('visible','on');
for k=1:i_total
    
    % Get 1 s time window
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
    
    % Plot cleaned data
    subplot(2,1,1);
    plotchannels(t(indices),data_clean(:,indices)');
    title('Clean data')

    % Plot thrown out data (mask,spikes,slope tests included)
    
    subplot(2,1,2);
    plotchannels(t(indices),data_removed(:,indices)');
    title('Removed data')
    suptitle([num2str(k) '/' num2str(i_total)])
    F = getframe(h); % ***
    image = F.cdata; % ***
    writeVideo(v,image(1:end,1:end,:)); % ***
     fprintf(['Plotting image ' num2str(k) '/' num2str(i_total) '.\n'])


end
close(v) 

end

