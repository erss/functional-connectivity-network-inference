function model = infer_network_coherence( model)
% Infers network structure using coherence + imaginary coherency;
% Employs a bootstrap procedure to determine significance.
%
% INPUTS:
% model = structure with network inference parameters
%
% OUTPUTS:
%   -- New fields added to 'model' structure: --
% phase     = absolute value of mean phase over frequency bands where
%             coherence occurs [node x node x time]
% kC        = mean coherence over frequency bands for each signal pair and
%             at each moment of time [node x node x time]
% f         = frequency axis
% net_coh   = binary adjacency matrix [node x node x time]
% pval_coh  = p-value for each edge pair in adjacency [node x node x time]
% distr_coh = surrogate distrobution of coherence [1 x model.nsurrogates]

% 1. Load model parameters
nsurrogates = model.nsurrogates;
data        = model.data_clean;
time        = model.t;
n           = size(model.data_clean,1);  % number of electrodes

W       = model.W;
f_start = round(model.f_start,3);
f_stop  = round(model.f_stop, 3);

TW                  = model.window_size*W;                    % Time bandwidth product.
ntapers             = 2*TW-1;                                 % Choose the # of tapers.
model.params.tapers = [TW,ntapers];                           % time-bandwidth product and tapers.
params              = model.params;
movingwin           = [model.window_size, model.window_step]; % Window size and step.


%%% If coherence network already exists, skip this step.
if ~isfield(model,'kC')
    
    d1 = data(1,:)';
    d2 = data(2,:)';

    [~,~,~,~,~,t,f]=cohgramc(d1,d2,movingwin,params);
    kC  = nan([n n length(t)]);
    kUp = nan([n n length(t)]);
    kLo = nan([n n length(t)]); 
    phi = nan([n n length(t)]);
    % Compute the coherence.
    % Note that coherence is positive.
    %%%% MANU: subtract mean before -- this is done in the remove artifacts
    %%%% step
    for i = 1:n
        d1 = data(i,:)';
        parfor j = (i+1):n % parfor on inside
            d2 = data(j,:)';
            [net_coh,phase,~,~,~,~,ftmp,~,~,Cerr] = cohgramc(d1,d2,movingwin,params);
            f_indices  = round(ftmp,3) >= f_start & round(ftmp,3) <= f_stop;
          %  kC(i,j,:)  = mean(net_coh(:,f_indices),2);
            kC(i,j,:)  = net_coh(:,f_indices);
            kUp(i,j,:) = Cerr(2,:,f_indices);
            kLo(i,j,:) = Cerr(1,:,f_indices);
            phi(i,j,:) = phase(:,f_indices);
            fprintf(['Infering edge row: ' num2str(i) ' and col: ' num2str(j) '. \n' ])
        end
        
        fprintf(['Inferred edge row: ' num2str(i) '\n' ])
    end
    
    model.dynamic_network_taxis = t + time(1); %%% DOUBLE CHECK THIS STEP
                                               %%% TO FIX TIME AXIS
    model.f = f;
    model.kC = kC;
    model.phi = phi;
    model.kLo = kLo;
    model.kUp = kUp;
end

% % 3. Compute surrogate distrubution.
fprintf(['... generating surrogate distribution \n'])
if ~isfield(model,'distr_coh')
    
    model = gen_surrogate_distr_coh(model,params,movingwin,f_start,f_stop);
end
%
% % 4. Compute pvals using surrogate distribution.
fprintf(['... computing pvals \n'])

% Initialize coherence pvals
pval_coh = NaN(size(model.kC));
distr_coh = sort(model.distr_coh);

num_nets = size(pval_coh,3);

for i = 1:n
    for j = (i+1):n
        
        for k = 1:num_nets
            
            % Compute coherence for node pair (i,j) at time k
            kCohTemp = model.kC(i,j,k);
            if isnan(kCohTemp)
                pval_coh(i,j,k)=NaN;
            else
                p =sum(distr_coh>kCohTemp); % upper tail
                pval_coh(i,j,k)= p/nsurrogates;
                if (p == 0)
                    pval_coh(i,j,k)=0.5/nsurrogates;
                end
            end
            
        end
    end
end


% 5. Use FDR to determine significant pvals.
fprintf(['... computing significance (FDR) \n'])
q=model.q;


% Compute significant pvals for coherence
net_coh = zeros(n,n,num_nets);

for ii = 1:num_nets
    if sum(sum(isfinite(pval_coh(:,:,ii)))) >0
        adj_mat = pval_coh(:,:,ii);
        p = adj_mat(isfinite(adj_mat));
        p = sort(p);
        
        m = length(p);                 % number of total tests performed
        ivals = (1:m)';
        sp = ivals*q/m;
        
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
        net_coh(:,:,ii) = Ctemp+Ctemp';
    else
        net_coh(:,:,ii) = NaN(n,n);
    end
end

% 6. Output/save everything
model.net_coh = net_coh;
model.pval_coh = pval_coh;


end
