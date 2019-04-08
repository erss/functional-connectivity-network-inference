function model = infer_power_soz( model,pc)
% Infers network structure using coherence + imaginary coherency;
% Employs a bootstrap procedure to determine significance.
%
% INPUTS:
% model = structure with network inference parameters
% OUTPUTS:
%   -- New fields added to 'model' structure: --
% kPower = spectal power [nelectrodes x frequency x time]
% f      = frequencies
f0=model.sampling_frequency;
[LN,RN] = find_subnetwork_coords(pc);

%data_clean = remove_artifacts_zone(model.data([LN;RN],:),model.t,f0);

% 1. Load model parameters
data = model.data;
time = model.t;
n    = size(data,1);  % number of electrodes
Fs   = model.sampling_frequency;

% 2. Compute coherence + imaginary coherency for data.

% % NOTE: We are analyzing BETA, but possible bands for interest could be:
% % delta (1-4 Hz), theta (4-8 Hz), alpha (8-12 Hz), beta (12-30 Hz),
% % gamma (30-50 Hz)
% 
% f_start = 21; % Because frequency resolution = 9, f_start=f_stop = 21, and
% f_stop  = 21; % 21+-9 = [12-30] gives us beta band

W = 0.5;
TW = 2*W;                                  % Time bandwidth product.
ntapers         = 2*TW-1;                                    % Choose the # of tapers.
params.tapers   = [TW,ntapers];                              % ... time-bandwidth product and tapers.
params.pad      = -1;                                        % ... no zero padding.
params.trialave = 1;                                         % ... trial average.
params.fpass    = [0 50.1];                                  % ... freq range to pass.
params.Fs       = Fs;                                        % ... sampling frequency.
params.err      = [2 0.05];                                  % ... Jacknife error bars, p =0.05;
movingwin       = [2, 2];   % ... Window size and step.

%faxis = params.fpass(1):W:params.fpass(2);
dataL = convert_to_trials( data(LN,:)', 2*2035 );
[SL,t,fL,SerrL]  = mtspecgramc(dataL,movingwin,params);

dataR = convert_to_trials( data(RN,:)', 2*2035 );
[SR,t,fR,SerrR]  = mtspecgramc(dataR,movingwin,params);

dataC = convert_to_trials( data([LN;RN],:)', 2*2035 );
[SC,t,fC,SerrC]  = mtspecgramc(dataC,movingwin,params);

model.power_left_soz.S = SL;
model.power_right_soz.S = SR;
model.power_combined_soz.S = SC;

model.power_left_soz.f = fL;
model.power_right_soz.f = fR;
model.power_combined_soz.f = fC;

model.power_left_soz.Serr = SerrL;
model.power_right_soz.Serr = SerrR;
model.power_combined_soz.Serr = SerrC;

end
