%%% Load relative power spectra of a patient
load('group_power_spectra.mat','f','hData');
Sxx = hData(:,11);

%%% Compute sigma bump

min_freq = 10;   %% Define sigma bump range  %%% CHANGE THIS FOR YOUR DATA
max_freq = 15;
Sfit = fit_line(f,Sxx,min_freq,max_freq);

frequency_indices = logical(f>=min_freq | f<=max_freq); 
sigma_power_difference = Sxx(frequency_indices) - Sfit(frequency_indices);

%%% Compute difference on positive values
sigma_bump = sum(sigma_power_difference(sigma_power_difference>0));

plot(f,Sxx)
hold on;
plot(f,Sfit)
legend('Power spectrum','Fit line')
xlabel('Hz')
ylabel('Power')




