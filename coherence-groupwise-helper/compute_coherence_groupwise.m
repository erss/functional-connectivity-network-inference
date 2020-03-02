function model_zone = compute_coherence_groupwise( model,data)
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

f0 = model.sampling_frequency;

% 2. Transform data into appropriate trial structure and remove artifacts


[d1,d2]     = convert_zone_to_trials(data');

% for kk = size(d1temp,2):-1:1 % remove any trial that contains a nan
%     dt1 = d1temp(:,kk);
%     dt2 = d2temp(:,kk);
%     if any(isnan(dt1)) || any(isnan(dt2))  % col contains at least one nan
%         d1temp(:,kk)=[];
%         d2temp(:,kk)=[];
%     end
%     
% end
% d1 = d1temp;
% d2 = d2temp;

% 3. Load parameters


band_params.params.trialave = 1;           % ... trial average.
%band_params.params.fpass    = [1 50.1];    % ... freq range to pass.
band_params.params.Fs       = f0;        % ... sampling frequency.
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

ntapers                   = 1;                % Choose the # of tapers.
band_params.params.tapers = [TW,ntapers];     % time-bandwidth product and tapers.
band_params.movingwin     = [band_params.window_size, band_params.window_step]; % Window size and step.


f_start     = round(band_params.f_start,3);
f_stop      = round(band_params.f_stop, 3);
params      = band_params.params;
movingwin   = band_params.movingwin;

% 4. Compute coherence from d1 to d2

[C,phase,~,~,~,t,ftmp,~,~,Cerr] = cohgramc(d1,d2,movingwin,params);
f_indices  = round(ftmp,3) >= f_start & round(ftmp,3) <= f_stop;

% 5. Save results
model_zone.f       = ftmp;
model_zone.kC      = C(:,f_indices);
model_zone.kUp     = Cerr(2,:,f_indices);
model_zone.kLo     = Cerr(1,:,f_indices);
model_zone.phi     = phase(:,f_indices);
model_zone.t       = t;

end
