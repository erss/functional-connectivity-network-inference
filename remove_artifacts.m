function [ model ] = remove_artifacts( model, patient_coordinates )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
slope_threshold = -2;

 [ LN,RN ] = find_subnetwork_lobe( patient_coordinates,'temporal');


%%% Find time chunks with slope > - 1.5
f0=model.sampling_frequency;
data = model.data;
m = mean(data,2);
m = repmat(m,[1 size(data,2)]);
data = data - m;

d = data([LN, RN],:)';

t = model.t;
window_step = 0.5;
window_size = 0.5;
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.

slope = zeros(3,i_total);

for k = 1:i_total
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
    
    [Sxx, faxis] = pmtm(d(indices,:),4,sum(indices),f0);
    
    f_start = 30;
    f_stop  = 95;
    f_indices = faxis >= f_start & faxis < f_stop;
    
    X =log(faxis(f_indices));
    y = mean(log(Sxx(f_indices,:)),2);
    b = glmfit(X,y);

    slope(1,k)=t_start;
    slope(2,k) = t_stop;
    slope(3,k)=b(2);
    fprintf([num2str(k),'\n'])
end


indices = (slope(3,:) > slope_threshold);
bad_channels = slope(:,indices);

data_clean = data;
t_clean = t;
for k = size(bad_channels,2):-1:1
    t_start = bad_channels(1,k);
    t_stop = bad_channels(2,k);
    indx = find(t >= t_start & t < t_stop);
    
    data_clean(:,indx)= NaN;
    t_clean(indx) =NaN;
end

model.data_clean = data_clean;
model.t_clean = t_clean;
end

