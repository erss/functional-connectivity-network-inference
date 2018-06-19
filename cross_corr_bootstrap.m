function [ model ] = cross_corr_bootstrap( model)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
t=model.t;
window_size = model.window_size;
window_step = model.window_step;
% Step 1: Generate surrogate and compute surrogate cross correlations
nsurrogates = model.nsurrogates;
n = size(model.data,1);
tic
model = gen_surrogate_distr( model);
model.disttime = toc;
% mx = zeros([n n nsurrogates]);
% lag = zeros([n n nsurrogates]);

% for ii = 1:nsurrogates
%     surrogate_network = gen_surrogate_data(model);
%     [mx(:,:,ii), lag(:,:,ii)] = cross_corr_2(surrogate_network');
%      fprintf(['... gen surrogate: ' num2str(ii) ' of ' num2str(nsurrogates) '\n'])
% end

% CC of real data
data = model.data;


% Divide the data into windows, with overlap.
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.

mx0 = zeros([n n i_total]);
lag0 = zeros([n n i_total]);
t_net = zeros(1,i_total);
for k = 1:i_total
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;             %... find indices for window in t,
    [mx0(:,:,k), lag0(:,:,k)] = cross_corr_2(data(:,indices)');
     fprintf(['... inferring nets: ' num2str(k) ' of ' num2str(i_total) '\n'])
     t_net(k)       = t_start; 
end


% Step 3: build binary network
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
            if (p == 0)
                pval(i,j,k)=0.5/nsurrogates;
            end
        end
        
    end
end


%%Step 4: FDR to determine significant pvals
q=model.q;
m = (n^2-n)/2;                 % number of total tests performed
ivals = (1:m)';
sp = ivals*q/m;

C = zeros(n,n);

for ii = 1:size(pval,3)
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
end


% Output everything
model.taxis = t_net;
model.mx0 = mx0;
model.lag0 = lag0;
model.C = C;
model.pvals = pval;
end

