function [kIC,f] = imag_coherence_statistic_3(data,Fs)
%beta_band = [12 30]; %beta
%band = [beta_band(1)+2 beta_band(2)-2]; % frequency resolution is 2 so we look at [14, 28] for beta
params.tapers = [2 3]; % [TW, K]; We want a frequency resolution of 2, so T*W = 1*2 =2
% K= number of tapers, rec: 2*TW -1
params.Fs = Fs;
n= size(data,1);
%kIC = zeros(n,n);  %
win_size = size(data,2);
ntrials= win_size/Fs;
for i = 1:n
    for j =i:n% (i+1):n
        
        x = data(i,:);
        y = data(j,:);
        
        % TRADITIONAL: windowing
        x1 = reshape(x,[Fs ntrials]); % reshape data into one second chunks
        % where each chunk is a trial
        y2 = reshape(y,[Fs ntrials]);
        [~,~,S12,S1,S2,f]=coherencyc(x1,y2,params);
        
        imag_coh = imag(mean(S12,2))./sqrt(mean(S1,2) .* mean(S2,2));
        kIC(i,j,:) = imag_coh;%mean(imag_coh(f>=band(1) & f<=band(2)));

    end
end

end