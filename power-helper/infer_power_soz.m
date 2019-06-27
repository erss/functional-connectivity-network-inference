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
band_params = cfg_band('power');
model.band_params=band_params;

% 2. Compute coherence + imaginary coherency for data.
params    = band_params.params;
movingwin = band_params.movingwin;                                   % ... Window size and step.

%faxis = params.fpass(1):W:params.fpass(2);
dataL = model.dataL;
dataR = model.dataR;
dataC = model.dataC;
if strcmp(model.method,'relative_power_trial')
    dataL = bsxfun(@minus,dataL,nanstd(dataL,1));
    dataR = bsxfun(@minus,dataR,nanstd(dataR,1));
    dataC = bsxfun(@minus,dataC,nanstd(dataC,1));
    
end
fprintf('...inferring left SOZ power \n');
[SL,~,fL,SerrL]  = mtspecgramc(dataL,movingwin,params);
fprintf('...inferring right SOZ power \n');
[SR,~,fR,SerrR]  = mtspecgramc(dataR,movingwin,params);
fprintf('...inferring combined SOZ power \n');
[SC,~,fC,SerrC]  = mtspecgramc(dataC,movingwin,params);

model.leftSOZ.S = SL;
model.rightSOZ.S = SR;
model.combinedSOZ.S = SC;

model.leftSOZ.f = fL;
model.rightSOZ.f = fR;
model.combinedSOZ.f = fC;

model.leftSOZ.Serr = SerrL;
model.rightSOZ.Serr = SerrR;
model.combinedSOZ.Serr = SerrC;

%%% Compute sigma/beta ratio
% mean([10,14.5])/mean([15, 29.5])
model.leftSOZ.sbratio     = mean(SL(fL<=15 &fL>=10))/ mean(SL(fL<=30 &fL>=15));
model.rightSOZ.sbratio    = mean(SR(fR<=15 &fR>=10))/ mean(SR(fR<=30 &fR>=15));
model.combinedSOZ.sbratio = mean(SC(fC<=15 &fC>=10))/ mean(SC(fC<=30 &fC>=15));

h = figure;
set(h, 'Visible', 'off');
plot(fL,SL,'r',fR,SR,'g',fC,SC,'b')
hold on
plot(fL,SerrL(1,:),'--r',fL,SerrL(2,:),'--r')
plot(fR,SerrR(1,:),'--g',fL,SerrR(2,:),'--g')
plot(fC,SerrC(1,:),'--b',fL,SerrC(2,:),'--b')

legend('left SOZ','right SOZ','combined SOZ')
xlim([0 30])
xlabel('Frequency (Hz)','FontSize',18)
ylabel('Power','FontSize',18)
title(model.patient_name,'FontSize',20)

box off
saveas(h,[model.figpath model.patient_name '/' model.method '/power.fig']);
saveas(h,[model.figpath model.patient_name '/' model.method '/power.png']);

end
