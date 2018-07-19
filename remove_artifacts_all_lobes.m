function [ model ] = remove_artifacts_all_lobes( model, patient_coordinates )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
threshold = -1.5;





%%% Find time chunks with slope > - 1.5
f0=model.sampling_frequency;
data = model.data;
m = mean(data,2);
m = repmat(m,[1 size(data,2)]);
data = data - m;

[ LNp,RNp] = find_subnetwork_lobe( patient_coordinates,'parietal');
[ LNt,RNt] = find_subnetwork_lobe( patient_coordinates,'temporal');
[ LNo,RNo] = find_subnetwork_lobe( patient_coordinates,'occipital');
[ LNf,RNf] = find_subnetwork_lobe( patient_coordinates,'frontal');
[LN,RN] = find_subnetwork_central( patient_coordinates);
dp = data([LNp; RNp],:)';
dt = data([LNt; RNt],:)';
do = data([LNo; RNo],:)';
df = data([LNf; RNf],:)';
d = data([LN; RN],:)';

t = model.t;
window_step = 0.5;
window_size = 0.5;
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.

data_clean = data;
t_clean = t;

for k = 1:i_total
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
    
    f_start = 30;
    f_stop  = 95;
    
    %%% Parietal
    [Sxx, faxis] = pmtm(dp(indices,:),4,sum(indices),f0);
    f_indices = faxis >= f_start & faxis < f_stop;
    X =log(faxis(f_indices));
    y = mean(log(Sxx(f_indices,:)),2);
    bp = glmfit(X,y);
    
    %%% Occip
       [Sxx, faxis] = pmtm(do(indices,:),4,sum(indices),f0);
    f_indices = faxis >= f_start & faxis < f_stop;
    X =log(faxis(f_indices));
    y = mean(log(Sxx(f_indices,:)),2);
    bo = glmfit(X,y);
    
    %%% Temporal
       [Sxx, faxis] = pmtm(dt(indices,:),4,sum(indices),f0);
    f_indices = faxis >= f_start & faxis < f_stop;
    X =log(faxis(f_indices));
    y = mean(log(Sxx(f_indices,:)),2);
    bt = glmfit(X,y);
    
    %%%Frontal
       [Sxx, faxis] = pmtm(df(indices,:),4,sum(indices),f0);
    f_indices = faxis >= f_start & faxis < f_stop;
    X =log(faxis(f_indices));
    y = mean(log(Sxx(f_indices,:)),2);
    bf = glmfit(X,y);
    
    %%% Pre/Post central
       [Sxx, faxis] = pmtm(d(indices,:),4,sum(indices),f0);
    f_indices = faxis >= f_start & faxis < f_stop;
    X =log(faxis(f_indices));
    y = mean(log(Sxx(f_indices,:)),2);
    b = glmfit(X,y);
    
    %%% MAKE NAN
    
    if bp(2) > threshold || bt(2) > threshold || bf(2) > threshold || bo(2) > threshold || b(2) > threshold
        
        data_clean(:,indices)= NaN;
        t_clean(indices) =NaN;
    end
    fprintf([num2str(k),'\n'])
end





model.data_clean = data_clean;
model.t_clean = t_clean;
end

