%%
% LOAD DATA
T = 10;
Fs = 500;
N= 5; % electrodes
data = randn(N,T*Fs); % electrodes by time
ic_stat = zeros(N);
c_stat = zeros(N);
win_size = size(data,2);
ntrials= win_size/Fs;
params.Fs = 500;
params.tapers = [2 3];
%kIC = zeros(N,N,257);
for i = 1:N
    for j = i:N
        x= data(i,:);
        y= data(j,:);
        x1 = reshape(x,[Fs ntrials]);
        y1 = reshape(y,[Fs ntrials]);
        [~,~,S12,S1,S2,f]=coherencyc(x1,y1,params);
        %imag_coh = imag(S12)./sqrt(S1 .* S2);
        imag_coh = imag(mean(S12,2))./sqrt(mean(S1,2) .* mean(S2,2));
        kIC(i,j,:) = imag_coh;
        % idx = find(f>=14 & f<=28);
        % imag_coh_stat = mean(imag_coh(idx));
        % coh_stat = mean(C(idx));
        % ic_stat(i,j)= imag_coh_stat;
        % c_stat(i,j) = coh_stat;
    end
end

[kIC2,f2] = imag_coherence_statistic_3(data,Fs);
%%
%%% Note: Imaginary coherency seems to be unaffected by windowing approach
%%% vs multitaper approach, however regular coherence is highly affected by
%%% the approach.  For random noise, coherence is much higher in windowing
%%% approach than the multitaper approach.
%%% For random noise, we expect low coherence.
x = randn(1,T*Fs);
y = randn(1,T*Fs);

% TRADITIONAL: windowing
params.tapers = [2 3];
params.Fs = 500;
x1 = reshape(x,[500 10]);
y2 = reshape(y,[500 10]);
[C,phi,S12,S1,S2,f]=coherencyc(x1,y2,params);

imag_coh = imag(mean(S12,2))./sqrt(mean(S1,2) .* mean(S2,2));
figure;
subplot 121
plot(f,imag_coh);
hold on
plot(f,mean(C,2));
ylim([-.2 1])
title('Windowing')
% SOPHISTICATED: multi tapering
params.tapers = [20 39];
params.Fs = 500;
[C,phi,S12,S1,S2,f]=coherencyc(x,y,params);
imag_coh = imag(S12)./sqrt(S1 .* S2);
%plot(f,imag_coh,'g');
subplot 122
plot(f,imag_coh);
hold on
plot(f,C);
ylim([-.2 1])
title('Multi taper')
legend('imaginary','coherence')

%% real data
 load('/Users/erss/Documents/MATLAB/pBECTS006/pBECTS006_sleep07_source.mat')
 load('/Users/erss/Documents/MATLAB/pBECTS006/patient_coordinates_006.mat')
model006.sampling_frequency = 2035;
model006.data=[data_left;data_right];
model006.t=time;
model006.patient_name = 'pBECTS006';
patient_coordinates_006.status ='active-left';
[ model006] = remove_artifacts_all_lobes( model006, patient_coordinates_006);
tic 
[ model006 ] = infer_network_imaginary_coherency_2( model006);
codetime = toc;
