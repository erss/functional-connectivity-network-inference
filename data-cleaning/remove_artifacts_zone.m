function [data_clean,t_clean, b ] = remove_artifacts_zone(data,t,f0)
% Procedure to detect and remove all artifacts. Compute
% average spectrum of signals within data matrix. Fit line to log f-log
% power. If slope is > -2, mark as artifact.


% Load sampling frequency and define artifact threshold.
threshold = -2.8;

% Load data + remove mean
m    = mean(data,2);
m    = repmat(m,[1 size(data,2)]);
data = data - m;


window_step = 0.5;
window_size = 0.5;
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.

data_clean = data;
t_clean    = t;

b = zeros(1,i_total);
for k = 1:i_total
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;        %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
    
    f_start = 30;
    f_stop  = 95;
    
    b(k) = compute_slope(data(:,indices)',f0,f_start,f_stop);
    if b(k) > threshold % if slope is greater than threshold then artifact
        data_clean(:,indices)= NaN;
        t_clean(indices)     = NaN;
    end

    
end

% Remove mean after removing bad time intervals
data_clean = bsxfun(@minus,data_clean,nanmean(data_clean,2));

end

