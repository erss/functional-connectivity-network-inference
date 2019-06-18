function model_zone = compute_soz_coherence( model,nodes)
% [kC,kLo,kUp,phi,taxis,Cglobal,kLoGlobal,kUpGlobal] = compute_soz_coherence( model,nodes)
% Computes coherence of group of nodes over time such that each node pair 
% within group is treated as a trial.
%
% INPUTS:
% model = structure with network inference parameters
% node  = nodes in zone of interested. If input is a vector of indices,
%         coherence is computed within that group, e.g. from left SOZ to
%         left SOZ.  If input is a structure with fields 'source' to
%         'target', coherence is computed between source and target nodes
%         e.g. nodes.source = left SOZ and nodes.target = right
%         SOZ finds coherence from left SOZ nodes to right SOZ nodes.
%
% OUTPUTS:
%   -- New 'model_zone' structure: --
% phi       = absolute value of mean phase over frequency bands where
%             coherence occurs [node x node x time]
% kC        = mean coherence over frequency bands for each signal pair and
%             at each moment of time [1 x time]
% kLo, kUp  = lower and upper bounds respectively on estimate of coherence
% f         = frequency axis

% 1. Remove artifacts
f0 = model.sampling_frequency;

if ~isstruct(nodes)
   [data_clean,t_clean, b] = remove_artifacts_zone(model.data(nodes,:),model.t,f0);
else 
   [data_clean,t_clean, b] = remove_artifacts_zone(model.data([nodes.source;nodes.target],:),model.t,f0);
end

% 2. Transform data into appropriate trial structure and remove artifacts
if ~isstruct(nodes)
    [d1,d2]     = convert_zone_to_trials( data_clean');
else
    
    data        = data_clean;
    [d1,d2]     = convert_zone_to_trials( data',nodes);
end

% 3. Load parameters
time    = model.t;

f_start     = round(model.band_params.f_start,3);
f_stop      = round(model.band_params.f_stop, 3);
params      = model.band_params.params;
movingwin   = model.band_params.movingwin;

% 4. Compute coherence from d1 to d2
[C,phase,~,~,~,t,ftmp,~,~,Cerr] = cohgramc(d1,d2,movingwin,params);
f_indices  = round(ftmp,3) >= f_start & round(ftmp,3) <= f_stop;

% 5. Save results
model_zone.t_clean = t_clean;
model_zone.b       = b;
model_zone.f       = ftmp;
model_zone.kC      = C(:,f_indices);
model_zone.kUp     = Cerr(2,:,f_indices);
model_zone.kLo     = Cerr(1,:,f_indices);
model_zone.phi     = phase(:,f_indices);
model_zone.taxis   = t + time(1);

end
