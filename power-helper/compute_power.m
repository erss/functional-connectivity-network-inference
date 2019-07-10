function model_region = compute_power( model,nodes,data_cell)
% model_region = compute_power( model,nodes,data_cell)
% Computes power for group of nodes over time such that each node pair
% within group and all 1 s intervals are treated as trials.
%
% INPUTS:
% model = structure with network inference parameters
% node  = vector of indices for nodes for which to compute power
%
% OUTPUTS:
%   -- New 'model_zone' structure: --
% phi       = absolute value of mean phase over frequency bands where
%             coherence occurs [node x node x time]
% kC        = mean coherence over frequency bands for each signal pair and
%             at each moment of time [1 x time]
% kLo, kUp  = lower and upper bounds respectively on estimate of coherence
% f         = frequency axis

% 1. Remove artifacts & transform data into appropriate trial structure

f0 = model.sampling_frequency;
T=model.T;
data = [];
time_clean_cell = cell(1,size(data_cell,2));

if ~isempty(nodes)
    for k =1:size(data_cell,2)
        dtemp = data_cell{1,k};
        [data_clean,time_clean_cell{k}] = remove_artifacts(dtemp(nodes,:),data_cell{2,k},f0, model.threshold);
        
        %%% ---- Convert region into 1 s trials -------------------------
        data_clean = convert_to_trials( data_clean', T*f0 );
        
        for i = size(data_clean,2):-1:1 % remove any trial that contains a nan
            dtemp = data_clean(:,i);
            if any(isnan(dtemp)) % col contains at least one nan
                data_clean(:,i)=[];
            end
            
        end
        
        data = [data, data_clean];
        
    end
else
    data=[];
end

% 2. Load model parameters
band_params = cfg_band('power');
model.band_params=band_params;

% 3. Compute power
params    = band_params.params;
movingwin = band_params.movingwin;                                   % ... Window size and step.
if ~isempty(data)
    [S,~,f,Serr]  = mtspecgramc(data,movingwin,params);
    
    model_region.sbratio    = mean(S(f<=15 &f>=10))/ mean(S(f<=30 &f>=15));
    
    total_power = sum(S);
    
    model_region.total_power = total_power;
    model_region.S    = S;
    model_region.Srel = S./total_power;
    model_region.f    = f;
    model_region.Serr = Serr;
    
else
    model_region.sbratio    = nan;
    model_region.total_power = nan;
    model_region.S    = nan;
    model_region.Srel = nan;
    model_region.f    = nan;
    model_region.Serr = nan;
    
end
model_region.time_clean_cell = time_clean_cell;

end
