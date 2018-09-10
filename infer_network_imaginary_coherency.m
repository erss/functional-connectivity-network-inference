function [ model ] = infer_network_imaginary_coherency( model)
% Infers network structure using boostrap procedure to determine
% significance.

% 1. Load model parameters
t=model.t;
window_size = 10; % 10 second window
window_step = 5; % 50% overlap
data = model.data_clean;
%nsurrogates = model.nsurrogates;
n = size(model.data,1);  % number of electrodes
Fs = model.sampling_frequency;
% 2. Compute mx cross correlation for data.
% Divide the data into windows, with overlap.
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);
kIC_delta = zeros([n n i_total]);
kIC_theta = zeros([n n i_total]);
kIC_alpha = zeros([n n i_total]);
kIC_beta = zeros([n n i_total]);
kIC_gamma = zeros([n n i_total]);
t_net = zeros(1,i_total);
for k = 1:i_total
    
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
    d = data(:,indices);
    
    nsamples = sum(indices);
    if nsamples/window_size ~= Fs
        i1 = find(indices,1,'first');
        i2 = i1 +Fs -1;
        indices = i1:i2;
        d = data(:,indices);
    end
    
    if sum(sum(isnan(d))) == 0
          fprintf(['' num2str(sum(indices)) ' nan free ' '\n'])
        [kIC,f] = imag_coherence_statistic_3(d,Fs);
      
        % imag_coh_stat = mean(imag_coh(idx));
        %  delta (1-4 Hz), theta (4-8 Hz), alpha (8-12 Hz), beta (12-30 Hz), gamma (30-50 Hz)
        kIC_delta(:,:,k) = mean(kIC(:,:,f>=2 & f<=3),3);
        kIC_theta(:,:,k) = mean(kIC(:,:,f==6),3);
        kIC_alpha(:,:,k) = mean(kIC(:,:,f==10),3);
        kIC_beta(:,:,k)  = mean(kIC(:,:,f>=14 & f<=28),3);
        kIC_gamma(:,:,k) = mean(kIC(:,:,f>=32 & f<=48),3);
    else
         fprintf([num2str(sum(indices)) 'nan' '\n'])
        kIC_delta(:,:,k) = NaN(n);
        kIC_theta(:,:,k) = NaN(n);
        kIC_alpha(:,:,k) = NaN(n);
        kIC_beta(:,:,k)  = NaN(n);
        kIC_gamma(:,:,k) = NaN(n);
    end
    fprintf(['... inferring nets: ' num2str(k) ' of ' num2str(i_total) '\n'])
    t_net(k)       = t_start;
    
    
end

% % 3. Compute surrogate distrubution.
% fprintf(['... generating surrogate distribution \n'])
% model = gen_surrogate_distr( model);
% 
% % 4. Compute pvals using surrogate distribution.
% fprintf(['... computing pvals \n'])
% pval = NaN(n,n,i_total);
% mx =model.mx_bootstrap;
% for i = 1:n
%     for j = i+1:n
%         v = mx;
%         v = sort(v);
%         
%         for k = 1:i_total
%             
%             mxij = mx0(i,j,k);
%             p =sum(v>mxij); % upper tail
%             pval(i,j,k)= p/nsurrogates;
%             %             if isnan(mx0(i,j,k))
%             %                 pval(i,j,k) = NaN;
%             %             else
%             if (p == 0)
%                 pval(i,j,k)=0.5/nsurrogates;
%             end
%             if isnan( mxij)
%                 pval(i,j,k)=NaN;
%             end
%         end
%     end
% end
% 
% 
% % 5. Use FDR to determine significant pvals.
% fprintf(['... computing significance (FDR) \n'])
% q=model.q;
% m = (n^2-n)/2;                 % number of total tests performed
% ivals = (1:m)';
% sp = ivals*q/m;
% 
% C = zeros(n,n,size(pval,3));
% 
% for ii = 1:size(pval,3)
%     
%     if sum(sum(isfinite(pval(:,:,ii)))) >0
%         adj_mat = pval(:,:,ii);
%         p = adj_mat(isfinite(adj_mat));
%         p = sort(p);
%         i0 = find(p-sp<=0);
%         if ~isempty(i0)
%             threshold = p(max(i0));
%         else
%             threshold = -1.0;
%         end
%         
%         %Significant p-values are smaller than threshold.
%         sigPs = adj_mat <= threshold;
%         Ctemp = zeros(n);
%         Ctemp(sigPs)=1;
%         C(:,:,ii) = Ctemp+Ctemp';
%     else
%         C(:,:,ii) = NaN(n,n);
%     end
% end

% 6. Output/save everything
model.dynamic_network_taxis = t_net;
% model.mx0 = mx0;
% model.lag0 = lag0;
% model.C = C;
% model.pvals = pval;
model.kIC_delta = kIC_delta;
model.kIC_theta = kIC_theta;
model.kIC_alpha = kIC_alpha;
model.kIC_beta  = kIC_beta;
model.kIC_gamma = kIC_gamma;

end
