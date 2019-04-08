function [ surrogate_network ] = gen_surrogate_data( model)
% Shuffles channels in time to generates one surrogate network.

data = model.data;
window_size = model.window_size * model.sampling_frequency;   % window size (samples)
n = size(data,1);   % size of network
T = size(data,2);   % length of network

% shuffle in time
starting_times = randi(T-window_size+1,[n, 1]);  % Randomly picks starting
                                                 % 
starting_times = repmat(starting_times,[1,window_size]);

indices = 0:window_size-1;
indices = repmat(indices,[n,1]);
indices = starting_times + indices;
indices(indices>size(data,2)) = NaN;
% 
%     for ii = 1:n
%         temp = data(ii,:);
%         temp = temp(indices(ii,:));
%         surrogate_network(ii,:)=temp;
%     end

% shuffle in space
space_index = randi(size(data,1),[1 size(data,1)])' - ones([1 size(data,1)])';
 indices = indices + repmat(space_index,[1,window_size]).*size(data,2);
% 
 d= data';
 surrogate_network=d(indices);
end

