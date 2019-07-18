function b = compute_slope( data, f0,f_start,f_stop )
% Compute average spectrum for every signal in data block.  Fits line to
% log-f log-power and returns slope.
%
% INPUTS:
%  data    = data matrix [T x N], where T is the number of time points and N
%            is the number of channels
%  f0      = sampling_frequency
%  f_start =
%  f_stop  = . [look up in methods]
% OUTPUT:
%  b = slope of log-log line, y = bx + b0


data( :,isnan(data(1,:)))  = []; % if channel has been marked as bad (i.e.
                                 %   nan), remove before computing spectrum
[Sxx, faxis] = pmtm(data,4,size(data,1),f0);
f_indices = faxis >= f_start & faxis < f_stop;
X  = log(faxis(f_indices));
y  = mean(log(Sxx(f_indices,:)),2);
b = glmfit(X,y);
b=b(2);


%  plot(log(faxis(f_indices)),log(Sxx(f_indices)))
% xlabel('log frequencies')
% ylabel('log power')
% title('Time indices 202-3, b = -2.81, LN only')
% set(gca,'FontSize',18)
% xlim([3.4,4.6])
% ylim([-63.5,-59.5])
end

