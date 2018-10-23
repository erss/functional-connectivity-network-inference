function [ model, bvalues ] = remove_artifacts_all_lobes( model, patient_coordinates )
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
    dp = data([LNp; RNp],:)';
    dt = data([[LNt;LN]; [RNt;RN]],:)';
    do = data([LNo; RNo],:)';
    df = data([LNf; RNf],:)';
 %   d = data([LN; RN],:)';
    
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
    bvalues = zeros(4,i_total);
    for k = 1:i_total
        t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
        t_stop  = t_start + window_size;                  %... get window stop time [s],
        indices = t >= t_start & t < t_stop;
        
        f_start = 30;
        f_stop  = 95;
        
        %%% Parietal
        [Sxx, faxis] = pmtm(dp(indices,:),4,sum(indices),f0);
        f_indices = faxis >= f_start & faxis < f_stop;
        X  = log(faxis(f_indices));
        y  = mean(log(Sxx(f_indices,:)),2);
        bp = glmfit(X,y);
        
        %%% Occip
        [Sxx, faxis] = pmtm(do(indices,:),4,sum(indices),f0);
        f_indices = faxis >= f_start & faxis < f_stop;
        X  = log(faxis(f_indices));
        y  = mean(log(Sxx(f_indices,:)),2);
        bo = glmfit(X,y);
        
        %%% Temporal
        [Sxx, faxis] = pmtm(dt(indices,:),4,sum(indices),f0);
        f_indices = faxis >= f_start & faxis < f_stop;
        X  = log(faxis(f_indices));
        y  = mean(log(Sxx(f_indices,:)),2);
        bt = glmfit(X,y);
        
        %%%Frontal
        [Sxx, faxis] = pmtm(df(indices,:),4,sum(indices),f0);
        f_indices = faxis >= f_start & faxis < f_stop;
        X  = log(faxis(f_indices));
        y  = mean(log(Sxx(f_indices,:)),2);
        bf = glmfit(X,y);
        
        %%% Pre/Post central
%         [Sxx, faxis] = pmtm(d(indices,:),4,sum(indices),f0);
%         f_indices = faxis >= f_start & faxis < f_stop;
%         X = log(faxis(f_indices));
%         y = mean(log(Sxx(f_indices,:)),2);
%         b = glmfit(X,y);
        
        %%% MAKE NAN
        
        if bp(2) > threshold || bt(2) > threshold || bf(2) > threshold || bo(2) > threshold% || b(2) > threshold
            
            data_clean(:,indices)= NaN;
            t_clean(indices)     = NaN;
        end
        fprintf([num2str(k),'\n'])
        
        %bvalues(:,k) = [bp(2); bt(2);bf(2);bo(2);b(2)] ;
        bvalues(:,k) = [bp(2); bt(2);bf(2);bo(2)];
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

