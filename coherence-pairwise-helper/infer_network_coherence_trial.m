function model = infer_network_coherence_trial( model,data,path)
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
%band_params  = cfg_band( 'sigma',model.sampling_frequency );


band_params.params.trialave = 1;           % ... trial average.
%band_params.params.fpass    = [1 50.1];    % ... freq range to pass.
band_params.params.Fs       = model.sampling_frequency;        % ... sampling frequency.
band_params.params.err      = [2 0.05];    % ... Jacknife error bars, p =0.05;

band_params.params.fpass = [10 15];
band_params.W           = 2.5;
band_params.f_start     = 12.5;
band_params.f_stop      = 12.5;
band_params.window_step = 2;      % in seconds
band_params.window_size = 2;      % in seconds
band_params.params.pad  = -1;     % ... no zero padding.
band_params.fband = 'sigma';
TW                        = band_params.window_size*band_params.W;  % Time bandwidth product.

ntapers                   = 1;                                 % Choose the # of tapers.
band_params.params.tapers = [TW,ntapers];                           % time-bandwidth product and tapers.
band_params.movingwin     = [band_params.window_size, band_params.window_step]; % Window size and step.

n           = size(data,1);  % number of electrodes
T=band_params.movingwin(1);

f_start     = round(band_params.f_start,3);
f_stop      = round(band_params.f_stop, 3);
params      = band_params.params;
movingwin   = band_params.movingwin;
f0 = model.sampling_frequency;

%%% If coherence network already exists, skip this step.
if ~isfield(model,'sigma')
    
    d1 = data(1,:)';
    d2 = data(2,:)';
    
    d1temp = convert_to_trials( d1, T*f0 );
    d2temp = convert_to_trials( d2, T*f0 );
    
    for kk = size(d1temp,2):-1:1 % remove any trial that contains a nan
        dt1 = d1temp(:,kk);
        dt2 = d2temp(:,kk);
        if any(isnan(dt1)) || any(isnan(dt2))  % col contains at least one nan
            d1temp(:,kk)=[];
            d2temp(:,kk)=[];
        end
        
    end
    d1 = d1temp;
    d2 = d2temp;
    
    %%% ---- Convert region into 1 s trials -------------------------
    
    [C,~,~,~,~,t,f]=cohgramc(d1,d2,movingwin,params);
    kC  = nan([n n length(t)]);
    kUp = nan([n n length(t)]);
    kLo = nan([n n length(t)]);
    phi = nan([n n length(t)]);
    % Compute the coherence.
    % Note that coherence is positive.
    %%%% MANU: subtract mean before -- this is done in the remove artifacts
    %%%% step
    % poolobj = gcp('nocreate');
    %  addAttachedFiles(poolobj,'coherr')
    for i = 1:n
        
        parfor j = (i+1):n % parfor on inside
            
            d1 = data(i,:)';
            d1 = d1 - nanmean(d1);
            d2 = data(j,:)';
            d2 = d2 - nanmean(d2);
            
            d1temp = convert_to_trials( d1, T*f0 );
            d2temp = convert_to_trials( d2, T*f0 );
            
            for kk = size(d1temp,2):-1:1 % remove any trial that contains a nan
                dt1 = d1temp(:,kk);
                dt2 = d2temp(:,kk);
                if any(isnan(dt1)) || any(isnan(dt2))  % col contains at least one nan
                    d1temp(:,kk)=[];
                    d2temp(:,kk)=[];
                end
                
            end
            d1 = d1temp;
            d2 = d2temp;
            
            if  ~(size(d1,2)==0 || size(d2,2)==0)
                [net_coh,phase,~,~,~,~,ftmp,~,~,Cerr] = cohgramc(d1,d2,movingwin,params);
                f_indices  = round(ftmp,3) >= f_start & round(ftmp,3) <= f_stop;
                % kC(i,j,:)  = mean(net_coh(:,f_indices),2);
                kC(i,j,:)  =net_coh(f_indices);
                
                %  kC(i,j,:)  = nanmean(net_coh,1);
                
                kUp(i,j,:) = Cerr(2,f_indices);
                kLo(i,j,:) = Cerr(1,f_indices);
                % phi(i,j,:) =  nanmean(phase,1);
                phi(i,j,:) =  phase(f_indices);
            end
            fprintf(['Infering edge row: ' num2str(i) ' and col: ' num2str(j) '. \n' ])
        end
        
        fprintf(['Inferred edge row: ' num2str(i) '\n' ])
        model.sigma.f = f;
        model.sigma.net_coh = kC;
        model.sigma.phi = phi;
        model.sigma.kUp = kUp;
        model.sigma.kLo = kLo;
        model.sigma.t   = t;
        save(path,'model','-v7.3')
        
    end
    model.sigma.f = f;
    model.sigma.net_coh = kC;
    model.sigma.phi = phi;
    model.sigma.kUp = kUp;
    model.sigma.kLo = kLo;
    save(path,'model','-v7.3')
    
    
else
    
    kC  = model.sigma.net_coh;
    kUp = model.sigma.kUp;
    kLo = model.sigma.kLo;
    phi = model.sigma.phi;
    % Compute the coherence.
    % Note that coherence is positive.
    %%%% MANU: subtract mean before -- this is done in the remove artifacts
    %%%% step
    %     poolobj = gcp('nocreate');
    %     addAttachedFiles(poolobj,'coherr')
    for i = 1:n
        
        parfor j = (i+1):n % parfor on inside
            
            if isnan(kC(i,j,:))
                d1 = data(i,:)';
                d1 = d1 - nanmean(d1);
                d2 = data(j,:)';
                d2 = d2 - nanmean(d2);
                
                d1temp = convert_to_trials( d1, T*f0 );
                d2temp = convert_to_trials( d2, T*f0 );
                
                for kk = size(d1temp,2):-1:1 % remove any trial that contains a nan
                    dt1 = d1temp(:,kk);
                    dt2 = d2temp(:,kk);
                    if any(isnan(dt1)) || any(isnan(dt2))  % col contains at least one nan
                        d1temp(:,kk)=[];
                        d2temp(:,kk)=[];
                    end
                    
                end
                d1 = d1temp;
                d2 = d2temp;
                if ~(size(d1,2)==0 || size(d2,2)==0)
                    [net_coh,phase,~,~,~,~,ftmp,~,~,Cerr] = cohgramc(d1,d2,movingwin,params);
                    f_indices  = round(ftmp,3) >= f_start & round(ftmp,3) <= f_stop;
                    % kC(i,j,:)  = mean(net_coh(:,f_indices),2);
                    kC(i,j,:)  =net_coh(f_indices);
                    
                    %  kC(i,j,:)  = nanmean(net_coh,1);
                    
                    kUp(i,j,:) = Cerr(2,f_indices);
                    kLo(i,j,:) = Cerr(1,f_indices);
                    % phi(i,j,:) =  nanmean(phase,1);
                    phi(i,j,:) =  phase(f_indices);
                end
                fprintf(['Infering edge row: ' num2str(i) ' and col: ' num2str(j) '. \n' ])
            end
        end
        
        fprintf(['Inferred edge row: ' num2str(i) '\n' ])
        model.sigma.net_coh = kC;
        model.sigma.phi = phi;
        model.sigma.kUp = kUp;
        model.sigma.kLo = kLo;
        save(path,'model','-v7.3')
        
    end
    model.sigma.net_coh = kC;
    model.sigma.phi = phi;
    model.sigma.kUp = kUp;
    model.sigma.kLo = kLo;
    save(path,'model','-v7.3')
    
    
end




end
