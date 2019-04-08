clear

% Make the data.
Fs = 500;                                   % Example sampling frequency.
T  = 1000;                                   % Example duration of data.
N  = T*Fs;                                  % Total number of data point.

% Noise data.
d1 = randn(N,1);
d2 = randn(N,1);
d3 = randn(N,1);
d4 = randn(N,1);
d5 = randn(N,1);
% Frequency band signal.
d0a = sin(2.0*pi*(1:N)/Fs*20)';
d0b = sin(2.0*pi*(1:N)/Fs*18)';

% Generate data this is noise and the narrow band signal with shift
d1 = d1 + 1*d0a ;
d2 = d2 + 1*circshift(d0a,-2) ;
d3 = d3 + 1*d0b;
d4 = d4 + 1*circshift(d0b,4);

taxis = 1/Fs:1/Fs:T;

%plot(taxis,d1,taxis,d2)

%%
%-------------------------------------------------------------------------%
% Chronux MTM parameters
TW = 2*9;                                    % Time bandwidth product.
ntapers         = 2*TW-1;                   % Choose the # of tapers.
params.tapers   = [TW,ntapers];             % ... time-bandwidth product and tapers.
params.pad      = -1;                       % ... no zero padding.
params.trialave = 1;                        % ... trial average.
params.fpass    = [1 50.1];                 % ... freq range to pass.
params.Fs       = Fs;                       % ... sampling frequency.
movingwin       = [2,1];                   % Window size and step.

% Compute the coherence.
[C,phi,S12,S1,S2,t,f]=cohgramc_MAK(d1,d2,movingwin,params);

%% Show that we can correctly estimate the coherence

subplot(3,1,1)
plot(f, C(1,:), '*')                                        % Coherence returned from chronux.
cohr = abs(S12(1,:)) ./ sqrt( S1(1,:) ) ./ sqrt( S2(1,:) ); % Coherence computed from chronux outputs.
hold on
plot(f, cohr)
hold off
axis tight

%%%% Compute imaginary cohrence.
icohr = imag(S12(1,:)) ./ sqrt( S1(1,:) ) ./ sqrt( S2(1,:) );
hold on
plot(f, icohr)
hold off

legend({'Coherence'; 'Estimate from S12,S1,S2'; 'Imag Cohernece'})

%%%% Also plot the phase.
subplot(3,1,2)
plot(f, phi(1,:))
ylabel('Phase')
axis tight

%%%% Plot phase versus imaginary coherence
subplot(3,1,3)
plot(phi(1,:), icohr, '*')
xlabel('Phase')
ylabel('Imaginary coherence')

%%


