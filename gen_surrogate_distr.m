function [ model ] = gen_surrogate_distr( model)
% Shuffles channels in time to generates one surrogate network.

data = model.data;
window_size = model.window_size * model.sampling_frequency;   % window size (samples)
n = size(data,1);   % size of network
T = size(data,2);   % length of network
nsurrogates = model.nsurrogates;

mx = zeros(1,nsurrogates);
lag = zeros(1,nsurrogates);

for ii = 1:nsurrogates
    
    ij = randperm(n,2);
    i=ij(1);
    j=ij(2);
    ti = randi(T-window_size+1);
    tj = randi(T-window_size+1);
    
    xi = data(i,ti:(ti+window_size-1));
    xj = data(j,tj:(tj+window_size-1));
    
    [mxij,lagij] = cross_corr_statistic([xi' xj']);
    
    mx(ii)  = mxij(3);
    lag(ii) = lagij(3);
    
end
model.mx_bootstrap = mx;
model.lag_bootstrap = lag;

% % shuffle in time
% starting_times = randi(T-window_size+1,[nsurrogates, 1]);  % Randomly picks starting
% starting_times = repmat(starting_times,[1,window_size]);
% 
% indices = 0:window_size-1;
% indices = repmat(indices,[nsurrogates,1]);
% indices = starting_times + indices;
% indices(indices>size(data,2)) = NaN;
% 
% 
% % shuffle in space
% space_index = randi(n,[1 nsurrogates])' - ones([1 nsurrogates])';
% indices = indices + repmat(space_index,[1,window_size]).*size(data,2);
% % 
%  d= data';
%  surrogate_network=d(indices);
end

