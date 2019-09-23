function model_region = compute_power_band( model,data,band)
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

band_params = cfg_band(band,model.sampling_frequency);

f0 = model.sampling_frequency;
T=band_params.movingwin(1);

%%% ---- Convert region into 1 s trials -------------------------
data_clean = convert_to_trials( data', ceil(T*f0) );
trialtemp = size(data_clean,2);
for i = size(data_clean,2):-1:1 % remove any trial that contains a nan
    dtemp = data_clean(:,i);
    if any(isnan(dtemp)) % col contains at least one nan
        data_clean(:,i)=[];
    end
    
end

data = data_clean;
model_region.ntrials = size(data_clean,2);
model_region.ntrials_removed = trialtemp-size(data_clean,2);
fprintf(['... ... ... ... size of data is: ' num2str(size(data)) '\n'])
% 2. Load model parameters
model.band_params=band_params;

% 3. Compute power
params    = band_params.params;
movingwin = band_params.movingwin;                                   % ... Window size and step.
if ~isempty(data)
    [S,~,f,Serr]      = mtspecgramc(data,movingwin,params);
    nearestFreq       = find_nearest_value( f, band_params.f_start);
    model_region.S    = S(f==nearestFreq);
    model_region.f    = f(f==nearestFreq);
    model_region.Serr = Serr(:,f==nearestFreq);
    
    
else

    model_region.S    = nan;
    model_region.f    = nan;
    model_region.Serr = nan;

end

end
