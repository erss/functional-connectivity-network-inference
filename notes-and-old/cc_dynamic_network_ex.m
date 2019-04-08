% DYANMIC NETWORK SCRIPT EXAMPLE
clear all

% 1. LOAD DATA
data(1,:)=randn(1,20000);
data(2,:)=circshift(data(1,:),10);
data(3,:)=randn(1,20000);
model.data = data;

% 2. LOAD MODEL PARAMETERS
model.sampling_frequency = 500;
model.t = 1:1/model.sampling_frequency:size(data,2)/model.sampling_frequency;
model.window_step = 0.5; % in seconds
model.window_size = 1;   % in seconds
model.q=0.05;
model.nsurrogates = 100;

% 3. INFER NETWORK
[ model ] = infer_network_correlation_bootstrap( model);
