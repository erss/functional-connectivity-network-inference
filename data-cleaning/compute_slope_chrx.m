function b = compute_slope_chrx( data, f0,f_start,f_stop )
% Compute average spectrum for every signal in data block.  Fits line to
% log-f log-power and returns slope.
% NOTE: Compute LOG first of Sxx estmates, THEN computes MEAN of the logs
% to get estimate of logf-logSxx
%
% INPUTS:
%  data    = data matrix [T x N], where T is the number of time points and N
%            is the number of channels
%  f0      = sampling_frequency
%  f_start =
%  f_stop  = . [look up in methods]
% OUTPUT:
%  b = slope of log-log line, y = bx + b0


%%% PMTM vs chronux, log first then mean
params.trialave = 0;
params.fpass    = [0 100];
params.Fs       = f0;
params.pad      = -1;
params.tapers   = [1 1]; % TW = 1; ntapers = 1;
nelectrodes = size(data,2);

[Sxx,faxis]=mtspectrumc(data,params);
f_indices = faxis >= f_start & faxis < f_stop;

% X  = log(faxis(f_indices));
% y  = mean(log(Sxx(f_indices,:)),2);
% b  = glmfit(X,y);
% b  = b(2);

for i = 1:nelectrodes
X  = log(faxis(f_indices));
y  =  log(Sxx(f_indices,i));
bval  = glmfit(X,y);
b(i)  = bval(2);
end

% figure;
% ax1= subplot(2,1,1);
% plot(faxis,log(Sxx(:,2)))
% hold on
% plot(faxis,log(Sxx(:,7)))
% ax2=subplot(2,1,2);
% for i = [1 3 4 5 6 8 9]
%    plot(faxis,log(Sxx(:,i)))
% hold on 
% end
% linkaxes([ax1,ax2],'xy')


% [Sxx,faxis]=mtspectrumc(data,params);
% f_indices = faxis >= 20 & faxis < f_stop;
% X  = log(faxis(f_indices));
% y  = mean(log(Sxx(f_indices,:)),2);
% b1  = glmfit(X,y);
% b1  = b1(2);

%b1=nan;
% [Sxx1, faxis1] = pmtm(data,4,size(data,1),f0);
% f_indices = faxis1 >= f_start & faxis1 < f_stop;
% X1  = log(faxis1(f_indices));
% y1  = mean(log(Sxx1(f_indices,:)),2);
% b1 = glmfit(X1,y1);
% b2=b1(2);
% 
% figure;
% subplot 121
% plot(faxis, mean(Sxx(:,:),2))
% hold on;
% plot(faxis1,mean(Sxx1(:,:),2))
% xlabel('frequencies')
% ylabel('power')
% subplot 122
% plot(X,y);
% hold on
% plot(X1,y1);
% legend(['chronux' num2str(b)],['pmtm' num2str(b2)]) 
% xlabel('log frequencies')
% ylabel('log power')
% suptitle('log first then mean')

%%% PMTM vs chronux, mean first then log
% params.trialave = 1;
% params.fpass    = [0 f_stop+5];
% params.Fs       = f0;
% params.pad      = -1;
% params.tapers   = [1 1]; % TW = 1; ntapers = 1;
% 
% [Sxx,faxis]=mtspectrumc(data,params);
% f_indices = faxis >= f_start & faxis < f_stop;
% X  = log(faxis(f_indices));
% y  = log(Sxx(f_indices));
% b = glmfit(X,y);
% b=b(2);
% 
% [Sxx1, faxis1] = pmtm(data,4,size(data,1),f0);
% f_indices = faxis1 >= f_start & faxis1 < f_stop;
% X1  = log(faxis1(f_indices));
% y1  = log(mean(Sxx1(f_indices,:),2));
% b1 = glmfit(X1,y1);
% b2=b1(2);
% 
% figure;
% subplot 121
% plot(faxis, Sxx)
% hold on;
% plot(faxis1,mean(Sxx1(:,:),2))
% xlabel('frequencies')
% ylabel('power')
% subplot 122
% plot(X,y);
% hold on
% plot(X1,y1);
% legend(['chronux' num2str(b)],['pmtm' num2str(b2)]) 
% xlabel('log frequencies')
% ylabel('log power')
% suptitle('Mean first then log')


end

