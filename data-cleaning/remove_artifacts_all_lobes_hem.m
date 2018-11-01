function [ model, bvalues ] = remove_artifacts_all_lobes_hem( model, patient_coordinates )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

f0=model.sampling_frequency;
data = model.data;
m = mean(data,2);
m = repmat(m,[1 size(data,2)]);
data = data - m;
threshold = -2;

%%% FIX @O so included in first if statement
    [ LNp,RNp] = find_subnetwork_lobe( patient_coordinates,'parietal');
    [ LNt,RNt] = find_subnetwork_lobe( patient_coordinates,'temporal');
    [ LNo,RNo] = find_subnetwork_lobe( patient_coordinates,'occipital');
    [ LNf,RNf] = find_subnetwork_lobe( patient_coordinates,'frontal');
    [LN,RN] = find_subnetwork_central( patient_coordinates);
    
if isfield(model,'t_clean') && length(model.t_clean) > 1
        data_clean = data;
    
    for t = 1:length(model.t_clean)
    
        if isnan(model.t_clean(t))
            data_clean(:,t) = nan;
        end
    end

  
    model.data_clean = data_clean;
    bvalues          = nan;
else
    %%% Find time chunks with slope > - 2
    
%     if strcmp(model.patient_name,'pBECTS020')
%         No = [LNo;RNo];
%         No([6 7 8]) = [];
%         Np =[LNp;RNp];
%         Np([4 5 19 20 21]) = [];
%         dp = data(Np,:)';
%         do = data(No,:)';
%         fprintf('pBECTS020!!!')
%     end
    t = model.t;
    window_step = 0.5;
    window_size = 0.5;
    i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.
    
    data_clean = data;
    t_clean    = t;
    
    %bvalues = zeros(5,i_total);
    b = zeros(4,2,i_total);
    for k = 1:i_total
        t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
        t_stop  = t_start + window_size;                  %... get window stop time [s],
        indices = t >= t_start & t < t_stop;
        
        f_start = 30;
        f_stop  = 95;
        
        %%% Parietal
        b(1,1,k) = compute_slope(data(LNp,indices)',f0,f_start,f_stop);
        b(1,2,k) = compute_slope(data(RNp,indices)',f0,f_start,f_stop);
        
        %%% Occip
        b(2,1,k) = compute_slope(data(LNo,indices)',f0,f_start,f_stop);
        b(2,2,k) = compute_slope(data(RNo,indices)',f0,f_start,f_stop);
        
        %%% Temporal
        b(3,1,k) = compute_slope(data([LNt;LN],indices)',f0,f_start,f_stop);
        b(3,2,k) = compute_slope(data([RNt;RN],indices)',f0,f_start,f_stop);
        
        
        %%% Frontal
        b(4,1,k) = compute_slope(data(LNf,indices)',f0,f_start,f_stop);
        b(4,2,k) = compute_slope(data(RNf,indices)',f0,f_start,f_stop);

        
        bt = b(:,:,k) > -2;
        if sum(bt(:)) > 0 % if at least one slope is greater than threshold
                          % then artifact           
            data_clean(:,indices)= NaN;
            t_clean(indices)     = NaN;
        end
        fprintf([num2str(k),'\n'])
        
        %bvalues(:,k) = [bp(2); bt(2);bf(2);bo(2);b(2)] ;
        %bvalues(:,k) = [bp(2); bt(2);bf(2);bo(2)];
    end
    
    if strcmp(model.patient_name,'pBECTS020')
        bad_k = [60 79 80 84 89 96 97 99 176 267 326 329 426];
        data_clean(:,bad_k)= NaN;
        t_clean(bad_k) =NaN;
    end
    model.data_clean = data_clean;
    model.t_clean    = t_clean;
end


end

