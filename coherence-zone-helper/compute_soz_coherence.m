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

% 1. Transform data into appropriate trial structure.  
if ~isstruct(nodes)
    data        = model.data_clean(nodes,:);
    [d1,d2]     = convert_zone_to_trials( data');
else
    
    data        = model.data_clean;
    [d1,d2]     = convert_zone_to_trials( data',nodes);
end

% 2. Load parameters
time    = model.t;
W       = model.W;
f_start = round(model.f_start,3);
f_stop  = round(model.f_stop, 3);

TW                  = model.window_size*W;                    % Time bandwidth product.
ntapers             = 2*TW-1;                                 % Choose the # of tapers.
model.params.tapers = [TW,ntapers];                           % time-bandwidth product and tapers.
params              = model.params;
movingwin           = [model.window_size, model.window_step]; % Window size and step.

% 3. Compute coherence from d1 to d2
[C,phase,~,~,~,t,ftmp,~,~,Cerr] = cohgramc(d1,d2,movingwin,params);
f_indices  = round(ftmp,3) >= f_start & round(ftmp,3) <= f_stop;

% 4. Save results
model_zone.f  = ftmp;
model_zone.kC = C(:,f_indices);
model_zone.kUp= Cerr(2,:,f_indices);
model_zone.kLo= Cerr(1,:,f_indices);
model_zone.phi= phase(:,f_indices);
model_zone.taxis = t + time(1);

%  only try 10s
%     d1t = d1(1:20350,:);
%     d2t = d2(1:20350,:);
%     d1p = convert_to_trials(d1, model.window_size*model.sampling_frequency);
%     d2p = convert_to_trials(d2, model.window_size*model.sampling_frequency);
%     tic
%     [Cglobal,phase,~,~,~,f,~,~,CerrGlobal] = coherencyc(d1p,d2p,params);
%     ctime = toc;
%     f_indices  = round(f,2) >= f_start & round(f,2) <= f_stop;
%     i = find(f_indices==1);
%     Cglobal   = Cglobal(i(1));
%     kUpGlobal = CerrGlobal(2,i(1));
%     kLoGlobal = CerrGlobal(1,i(1));
%     phi = phase(i(1));








end
