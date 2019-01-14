function model = infer_power( model)
% Infers network structure using coherence + imaginary coherency;
% Employs a bootstrap procedure to determine significance.
%
% INPUTS:
% model = structure with network inference parameters
% OUTPUTS:
%   -- New fields added to 'model' structure: --
% kPower = spectal power [nelectrods x frequency x time]
% f      = frequencies

% 1. Load model parameters
data = model.data_clean;
time = model.t;
n = size(model.data_clean,1);  % number of electrodes
Fs = model.sampling_frequency;

% 2. Compute coherence + imaginary coherency for data.

% % NOTE: We are analyzing BETA, but possible bands for interest could be:
% % delta (1-4 Hz), theta (4-8 Hz), alpha (8-12 Hz), beta (12-30 Hz),
% % gamma (30-50 Hz)
% 
% f_start = 21; % Because frequency resolution = 9, f_start=f_stop = 21, and
% f_stop  = 21; % 21+-9 = [12-30] gives us beta band

W = 0.5;
TW = model.window_size*W;                                  % Time bandwidth product.
ntapers         = 2*TW-1;                                    % Choose the # of tapers.
params.tapers   = [TW,ntapers];                              % ... time-bandwidth product and tapers.
params.pad      = -1;                                        % ... no zero padding.
params.trialave = 1;                                         % ... trial average.
params.fpass    = [0 50.1];                                  % ... freq range to pass.
params.Fs       = Fs;                                        % ... sampling frequency.
movingwin       = [ model.window_size, model.window_step];   % ... Window size and step.

faxis = params.fpass(1):W:params.fpass(2);

%%% If coherence network already exists, skip this step.
%if ~isfield(model,'kPower')
    
    d1 = data(1,:)';
    [S,t,f]  = mtspecgramc(d1,movingwin,params); % output S is length(t)
    % by length(f)
    kPower  = zeros([n length(f) length(t)]);
    kPower(1,:,:) = S';
    % Compute the coherence.
    % Note that coherence is positive.
    %%%% 
    for i = 2:n
        d1 = data(i,:)';
        [S,t,f]  = mtspecgramc(d1,movingwin,params);
        kPower(i,:,:) = S';
        % f_indices = ftmp >= f_start & ftmp <= f_stop;
        fprintf(['Inferred electrode: ' num2str(i) '\n' ])
        
    end
    
    model.dynamic_network_taxis = t + time(1); %%% DOUBLE CHECK THIS STEP, to
    %%% TO FIX TIME AXIS
    model.f = f;
    model.kPower = kPower;
    
%end

% BEANDS: delta (1-4 Hz), theta (4-8 Hz), alpha (8-12 Hz), beta (15-30 Hz),
% gamma (30-50 Hz)

% 3. Infer delta band 
band = [1 4];
f_start = band(1);
f_stop  = band(2);
f_indices = f >= f_start & f <= f_stop;
model.delta_power = squeeze(mean(kPower(:,f_indices,:),2));

% 4. Infer theta;
band = [4 8];
f_start = band(1);
f_stop  = band(2);
f_indices = f >= f_start & f <= f_stop;
model.theta_power = squeeze(mean(kPower(:,f_indices,:),2));

% 5. Infer alpha;
band = [8 12];
f_start = band(1);
f_stop  = band(2);
f_indices = f >= f_start & f <= f_stop;
model.alpha_power = squeeze(mean(kPower(:,f_indices,:),2));

% 6. Infer sigma;
band = [12 15];
f_start = band(1);
f_stop  = band(2);
f_indices = f >= f_start & f <= f_stop;
model.sigma_power = squeeze(mean(kPower(:,f_indices,:),2));

% 7. Infer beta;
band = [15 30];
f_start = band(1);
f_stop  = band(2);
f_indices = f >= f_start & f <= f_stop;
model.beta_power = squeeze(mean(kPower(:,f_indices,:),2));

% 8. Infer gamma;
band = [30 50];
f_start = band(1);
f_stop  = band(2);
f_indices = f >= f_start & f <= f_stop;
model.gamma_power = squeeze(mean(kPower(:,f_indices,:),2));



end
