function model_region = compute_power_dynamic( model,data)
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

%%% ---- Convert region into 1 s trials -------------------------
% data_clean = convert_to_trials( data', T*f0 );
% trialtemp = size(data_clean,2);
% for i = size(data_clean,2):-1:1 % remove any trial that contains a nan
%     dtemp = data_clean(:,i);
%     if any(isnan(dtemp)) % col contains at least one nan
%         data_clean(:,i)=[];
%     end
%
% end
%
% data = data_clean;

%%%

% model_region.ntrials = size(data_clean,2);
% model_region.ntrials_removed = trialtemp-size(data_clean,2);
%%%%
%%% First get rid of mask data and spikes



data2=data;
datatemp = isnan(data);
datatemp = sum(datatemp,1);
data2(:,datatemp==size(data,1)) =[];
data=data2';



% 2. Load model parameters
band_params = cfg_band('power',model.sampling_frequency);

band_params.params.trialave = 0;
model.band_params=band_params;

% 3. Compute power
params    = band_params.params;
movingwin = band_params.movingwin;
% ... Window size and step.

if ~isempty(data)
    [S,t,f,Serr]  = mtspecgramc(data,movingwin,params);
    S = nanmean(S,3);
    
    model_region.sbratio    = mean(S(:,f<=15 &f>=10),2)./ mean(S(:,f<=30 &f>=15),2);
    
    model_region.total_power = sum(S,2);
    model_region.S    = S;
    model_region.Srel = S./model_region.total_power;
    model_region.f    = f;
    model_region.t    = t;
    model_region.Serr = Serr;
    sigma_area_relative = nan(size(t));
    sigma_area_absolute = nan(size(t));
    sigma_max_relative = nan(size(t));
    sigma_max_absolute = nan(size(t));
    for i = 1:length(t)
        Sfit = fit_line(f,model_region.Srel(i,:),10,15);
        stat = compute_statistic( f,model_region.Srel(i,:),Sfit,10,15,'area' );
        sigma_area_relative(i) = stat;
        
        Sfit = fit_line(f,model_region.S(i,:),10,15);
        stat = compute_statistic( f,model_region.S(i,:),Sfit,10,15,'area' );
        sigma_area_absolute(i) = stat;
        
        
        Sfit = fit_line(f,model_region.Srel(i,:),10,15);
        stat = compute_statistic( f,model_region.Srel(i,:),Sfit,10,15,'max' );
        sigma_max_relative(i) = stat;
        
        Sfit = fit_line(f,model_region.S(i,:),10,15);
        stat = compute_statistic( f,model_region.S(i,:),Sfit,10,15,'max' );
        sigma_max_absolute(i) = stat;
        
    end
    model_region.sigma_area_relative = sigma_area_relative;
    model_region.sigma_area_absolute = sigma_area_absolute;
    model_region.sigma_max_relative = sigma_max_relative;
    model_region.sigma_max_absolute = sigma_max_absolute;
    
else
    model_region.sbratio    = nan;
    model_region.total_power = nan;
    model_region.S    = nan;
    model_region.Srel = nan;
    model_region.f    = nan;
    model_region.Serr = nan;
    model_region.sigma_bump = nan;
    
    model_region.sigma_area_relative =nan;
    model_region.sigma_area_absolute =nan;
    model_region.sigma_max_relative = nan;
    model_region.sigma_max_absolute = nan;
    
end

end
