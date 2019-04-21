function model = infer_power_soz( model)
% Computes power in left SOZ, right SOZ, and both SOZs with error bars.
% Plots in figpath
%
% INPUTS:
% model = structure with network inference parameters
%
% OUTPUTS:
%   -- New fields added to 'model' structure: --
% kPower = spectal power [nelectrodes x frequency x time]
% f      = frequencies

%data_clean = remove_artifacts_zone(model.data([LN;RN],:),model.t,f0);

% 1. Load model parameters

Fs   = model.sampling_frequency;

% 2. Compute coherence + imaginary coherency for data.
W = 0.5;
TW = 2*W;                                  % Time bandwidth product.
ntapers         = 2*TW-1;                                    % Choose the # of tapers.
params.tapers   = [TW,ntapers];                              % ... time-bandwidth product and tapers.
params.pad      = -1;                                        % ... no zero padding.
params.trialave = 1;                                         % ... trial average.
params.fpass    = [0 50.1];                                  % ... freq range to pass.
params.Fs       = Fs;                                        % ... sampling frequency.
params.err      = [2 0.05];                                  % ... Jacknife error bars, p =0.05;
movingwin       = [2, 2];                                    % ... Window size and step.

%faxis = params.fpass(1):W:params.fpass(2);
dataL = model.dataL;
dataR = model.dataR;
dataC = model.dataC;

fprintf('...inferring left SOZ power \n');
[SL,~,fL,SerrL]  = mtspecgramc(dataL,movingwin,params);
fprintf('...inferring right SOZ power \n');
[SR,~,fR,SerrR]  = mtspecgramc(dataR,movingwin,params);
fprintf('...inferring combined SOZ power \n');
[SC,~,fC,SerrC]  = mtspecgramc(dataC,movingwin,params);

model.power_left_soz.S = SL;
model.power_right_soz.S = SR;
model.power_combined_soz.S = SC;

model.power_left_soz.f = fL;
model.power_right_soz.f = fR;
model.power_combined_soz.f = fC;

model.power_left_soz.Serr = SerrL;
model.power_right_soz.Serr = SerrR;
model.power_combined_soz.Serr = SerrC;

%%% Compute sigma/beta ratio
 % mean([10,14.5])/mean([15, 29.5])
model.power_left_soz.sbratio     = mean(SL(fL<=15 &fL>=10))/ mean(SL(fL<=30 &fL>=15));
model.power_right_soz.sbratio    = mean(SR(fR<=15 &fR>=10))/ mean(SR(fR<=30 &fR>=15));
model.power_combined_soz.sbratio = mean(SC(fC<=15 &fC>=10))/ mean(SC(fC<=30 &fC>=15));

h = figure;
set(h, 'Visible', 'off');
plot(fL,SL,'r',fR,SR,'g',fC,SC,'b')
hold on
plot(fL,SerrL(1,:),'--r',fL,SerrL(2,:),'--r')
plot(fR,SerrR(1,:),'--g',fL,SerrR(2,:),'--g')
plot(fC,SerrC(1,:),'--b',fL,SerrC(2,:),'--b')

legend('left SOZ','right SOZ','combined SOZ')
xlim([0 25])
xlabel('Frequency (Hz)','FontSize',18)
ylabel('Power','FontSize',18)
title(model.patient_name,'FontSize',20)

box off
 saveas(h,[model.figpath model.patient_name '_power.fig']);
 saveas(h,[model.figpath model.patient_name '_power.jpg']);

end
