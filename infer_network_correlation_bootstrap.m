function [ model ] = infer_network_correlation_bootstrap( model)
% Infers network structure using boostrap procedure to determine
% significance.

% 1. Load model parameters
t=model.t;
window_size = model.window_size;
window_step = model.window_step;
data = model.data_clean;
nsurrogates = model.nsurrogates;
n = size(model.data,1);  % number of electrodes




% 2. Compute mx cross correlation for data.
% Divide the data into windows, with overlap.
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);
mx0 = zeros([n n i_total]);
lag0 = zeros([n n i_total]);
t_net = zeros(1,i_total);
for k = 1:i_total
    
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
    d = data(:,indices)';
    if sum(sum(isnan(d))) == 0
        
        [mx0(:,:,k), lag0(:,:,k)] = cross_corr_statistic(d);
    else
        mx0(:,:,k) = NaN(n);
        lag0(:,:,k) = NaN(n);
    end
    fprintf(['... inferring nets: ' num2str(k) ' of ' num2str(i_total) '\n'])
    t_net(k)       = t_start;
    
    
end

% 3. Compute surrogate distrubution.
fprintf(['... generating surrogate distribution \n'])
model = gen_surrogate_distr( model);

% 4. Compute pvals using surrogate distribution.
fprintf(['... computing pvals \n'])
pval = NaN(n,n,i_total);
mx =model.mx_bootstrap;
for i = 1:n
    for j = i+1:n
        v = mx;
        v = sort(v);
        
        for k = 1:i_total
            
            mxij = mx0(i,j,k);
            p =sum(v>mxij); % upper tail
            pval(i,j,k)= p/nsurrogates;
%             if isnan(mx0(i,j,k))
%                 pval(i,j,k) = NaN;
%             else
            if (p == 0)
                pval(i,j,k)=0.5/nsurrogates;
            end
            if isnan( mxij)
                  pval(i,j,k)=NaN;
            end
        end
    end
end


% 5. Use FDR to determine significant pvals.
fprintf(['... computing significance (FDR) \n'])
q=model.q;
m = (n^2-n)/2;                 % number of total tests performed
ivals = (1:m)';
sp = ivals*q/m;

C = zeros(n,n,size(pval,3));

for ii = 1:size(pval,3)
    
    if sum(sum(isfinite(pval(:,:,ii)))) >0
        adj_mat = pval(:,:,ii);
        p = adj_mat(isfinite(adj_mat));
        p = sort(p);
        i0 = find(p-sp<=0);
            if ~isempty(i0)
                threshold = p(max(i0));
            else
                threshold = -1.0;
            end

        %Significant p-values are smaller than threshold.
        sigPs = adj_mat <= threshold;
        Ctemp = zeros(n);
        Ctemp(sigPs)=1;
        C(:,:,ii) = Ctemp+Ctemp';
    else
       C(:,:,ii) = NaN(n,n);
    end
end

% 6. Output/save everything
model.dynamic_network_taxis = t_net;
model.mx0 = mx0;
model.lag0 = lag0;
model.C = C;
model.pvals = pval;
end
