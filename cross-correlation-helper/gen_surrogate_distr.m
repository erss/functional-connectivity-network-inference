function [ model ] = gen_surrogate_distr( model)
% Shuffles channels in time + space to generate distribution of max abs
% cross correlation values.

data = model.data_clean;
window_size = model.window_size * model.sampling_frequency;   % window size (samples)
n = size(data,1);   % size of network
T = size(data,2);   % length of network
nsurrogates = model.nsurrogates;

mx = zeros(1,nsurrogates);
lag = zeros(1,nsurrogates);

%%% Imaginary Coherency parameters

for ii = 1:nsurrogates
    
    ij = randperm(n,2); % Choose two random electrodes i & j, without replacement.
    i=ij(1);
    j=ij(2);
    
    
    ti = randi(T-window_size+1); % Choose random time, i.
    tj = randi(T-window_size+1); % Choose random time, j.
    xi = data(i,ti:(ti+window_size-1));
    xj = data(j,tj:(tj+window_size-1));
    
    while sum(sum(isnan(xi))) > 0
        ti = randi(T-window_size+1); 
        xi = data(i,ti:(ti+window_size-1));
    end
    
    while sum(sum(isnan(xj))) > 0
        tj = randi(T-window_size+1); 
        xj = data(i,tj:(tj+window_size-1));
 %        fprintf(['NaN \n'])
    end
    
    [mxij,lagij] = cross_corr_statistic([xi' xj']); % Compute cross-corr
                                                    % between xi & xj.
    mx(ii)  = mxij(3);
    lag(ii) = lagij(3);


  %  fprintf([num2str(ii),'\n'])
end

% Store surrogate distribution, and lags where abs maximum values occur.
model.mx_bootstrap = mx;
model.lag_bootstrap = lag;

end

