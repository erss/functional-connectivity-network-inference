model.sampling_frequency = 407;
model.patient_name = 'pBECTS040';
PATH= [ '~/Documents/BECTS-project/bects_data/source_data_ds/' model.patient_name '/power_time.mat'];
model.threshold = -1.5;
model.T = 1; %window_size

fprintf(['Analyzing patient ' model.patient_name '\n']);
load([ '~/Documents/BECTS-project/bects_data/source_data_ds/' model.patient_name '/patient_coordinates.mat'])
load([ '~/Documents/BECTS-project/bects_data/source_data_ds/' model.patient_name '/source_dsamp_data_clean.mat']);

PATIENTPATH = [ '~/Documents/BECTS-project/bects_data/source_data_ds/' model.patient_name];
addpath(PATIENTPATH)


model.status = patient_coordinates.status;

[LN,RN] = find_subnetwork_coords(patient_coordinates);
N = [LN;RN];

band_params = cfg_band('power',model.sampling_frequency);
model.band_params=band_params;

% 3. Compute power
params    = band_params.params;
movingwin = band_params.movingwin;

[S,t,f,Serr]  = mtspecgramc(data_clean(N(12),:),movingwin,params);

model.sbratio    = mean(S(f<=15 &f>=10))/ mean(S(f<=30 &f>=15));

total_power = nansum(S,1);

model.total_power = total_power;
model.S    = S;
model.Srel = S./total_power;
model.f    = f;
model.t    = t;
model.Serr = Serr;
model.SrelSigma = nanmean(S(:,f < 15 & f > 10),2)/nanmean(total_power(f < 15 & f > 10));
Sfit = fit_line(f,model.Srel,10,15);
stat = compute_statistic( f,model.Srel,Sfit,10,15,'area' );
model.sigma_bump_rel = stat;



model_LN2 = model;

%%
[S,t,f,Serr]  = mtspecgramc(data_clean(N(8),:),movingwin,params);

model.sbratio    = mean(S(f<=15 &f>=10))/ mean(S(f<=30 &f>=15));

total_power = nansum(S,1);

model.total_power = total_power;
model.S    = S;
model.Srel = S./total_power;
model.f    = f;
model.t    = t;
model.Serr = Serr;
model.SrelSigma = nanmean(S(:,f < 15 & f > 10),2)/nanmean(total_power(f < 15 & f > 10));
Sfit = fit_line(f,model.Srel,10,15);
stat = compute_statistic( f,model.Srel,Sfit,10,15,'area' );
model.sigma_bump_rel = stat;



model_LN1 = model;

%%
load([ '~/Documents/BECTS-project/bects_data/source_data_ds/' model.patient_name '/coherence_2.mat'])
load('/Users/erss/Documents/BECTS-project/bects_data/source_data_ds/pBECTS040/pBECTS040_minpeakprom2eNeg12_all_electrode.mat')
load([ '~/Documents/BECTS-project/bects_data/source_data_ds/' model.patient_name '/source_dsamp_data.mat']);

%%
OUTVIDPATH = '~/Desktop/pBECTS040_SOZ_Test';
v = model.sigma.net_coh(N(8),N(12),:);
phi = model.sigma.phi(N(8),N(12),:);

vUp = model.sigma.kUp(N(8),N(12),:);
vLo = model.sigma.kLo(N(8),N(12),:);

data_original = data([N(8),N(12)],:);
data_cleanTemp = data_clean([N(8),N(12)],:);


vid = VideoWriter(OUTVIDPATH); % path to save video, 'v'
vid.FrameRate=15;              % frames/sec
open(vid);
window_size = 1;
window_step = 1;
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.
h = figure('units','normalized','outerposition',[0 0 1 1],'visible','on');


%
data_temp = data_original(:);
data_temp(isfinite(data_cleanTemp)) = nan;
data_removed = reshape(data_temp,size(data_cleanTemp));


%h=figure('visible','on');
for k=90:240 %1:i_total
    
    % Get 1 s time window
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
    t_mid = (t_stop + t_start)/2;
    % Plot cleaned data
    subplot(3,2,[1 2])
    
    plotchannels_r(t(indices),data_cleanTemp(:,indices)',data_removed(:,indices)');
    % Plot thrown out data (mask,spikes,slope tests included)
    
    subplot(3,2,3)
    nearestValue = find_nearest_value( model_LN1.t, t_mid );
    plot(model_LN1.t,model_LN1.SrelSigma,'k','LineWidth',2)
    hold on;
    plot(model_LN1.t(model_LN1.t==nearestValue),model_LN1.SrelSigma(model_LN1.t==nearestValue),...
        'mo','MarkerSize',10,'MarkerFaceColor','m')
    xlim([75,250])
    xlabel('Time')
    ylabel('Power in 1')
    title(['T: ' num2str(nearestValue)])
    subplot(3,2,4)
    nearestValue = find_nearest_value( model_LN2.t, t_mid );
    
    plot(model_LN2.t,model_LN2.SrelSigma,'k','LineWidth',2)
    hold on;
    plot(model_LN2.t(model_LN2.t==nearestValue),model_LN2.SrelSigma(model_LN2.t==nearestValue),...
        'mo','MarkerSize',10,'MarkerFaceColor','m')
    xlabel('Time')
    ylabel('Power in 2')
    xlim([75,250])
    title(['T: ' num2str(nearestValue)])
    
    subplot(3,2,5)
    nearestValue = find_nearest_value( model.sigma.t, t_mid );
    plot(model.sigma.t,squeeze(v),'o','MarkerFaceColor','b','MarkerSize',8)
    hold on;
    vT = squeeze(v);
    errorbar(model.sigma.t,squeeze(v),squeeze(v)-squeeze(vLo),squeeze(v)-squeeze(vUp),'b')
    plot(model.sigma.t(model.sigma.t==nearestValue),vT(model.sigma.t==nearestValue),'om','MarkerFaceColor','m','MarkerSize',8)

    xlabel('Time')
    ylabel('Coherence between 1 & 2')
    xlim([75,250])
    title(['T: ' num2str(nearestValue)])
    subplot(3,2,6)
    plot(model.sigma.t,squeeze(phi),'o','MarkerFaceColor','b','MarkerSize',8)
    hold on;
    vT = squeeze(phi);
    title(['T: ' num2str(nearestValue)])
    plot(model.sigma.t(model.sigma.t==nearestValue),vT(model.sigma.t==nearestValue),'om','MarkerFaceColor','m','MarkerSize',8)
    xlabel('Time')
    ylabel('Phase Difference')
    xlim([75,250])
    
    suptitle([num2str(k) '/' num2str(i_total)])
    F = getframe(h); % ***
    image = F.cdata; % ***
    writeVideo(vid,image(1:end,1:end,:)); % ***
    fprintf(['Plotting image ' num2str(k) '/' num2str(i_total) '.\n'])
    
end
close(vid)
