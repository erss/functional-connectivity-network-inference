% DYANMIC NETWORK SCRIPT
% define window size
%tic
%data=randn(100,200);
clear all
 data(1,:)=randn(1,20000);
 data(2,:)=circshift(data(1,:),10);
 data(3,:)=randn(1,20000);
model.data = data;
model.sampling_frequency = 500;
model.t = 1:1/model.sampling_frequency:size(data,2)/model.sampling_frequency; 
model.window_step = 0.5; % in seconds
model.window_size = 1;   % in seconds
model.q=0.05;
model.nsurrogates = 100;
[ model ] = infer_network_correlation_bootstrap( model);
%infertime = toc;
%model.C
%%
% tic
% for ii = 1:1;%nsurrogates
%     surrogate_network = gen_surrogate_dist(model);
%    [mx(:,:,ii), lag(:,:,ii)] = cross_corr_2(surrogate_network');
%      fprintf(['... gen surrogate: ' num2str(ii) ' of ' num2str(nsurrogates) '\n'])
% end
% toc
% 
% 
% i_total = 1+floor((model.t(end)-model.t(1)-model.window_size) /model.window_step);  % # intervals.
% 
% for k = 1:i_total
%     t_start = model.t(1) + (k-1) * model.window_step;   %... get window start time [s],
%     t_stop  = t_start + model.window_size;                  %... get window stop time [s],
%     indices = model.t >= t_start & model.t < t_stop;             %... find indices for window in t,
%     [Ca(:,:,k), mx0(:,:,k), lag0(:,:,k),rhoa(:,:,k)] = infer_network_correlation_analytic(data(:,indices)');
% 
% 
% end


% d=data(:,1:500);
% % [Ca,mxa,laga,rhoa]=infer_network_correlation_analytic(d');
% %%
% for i = 1:37
%      
%     subplot 121
%     plotNetwork(model.C(:,:,i));
%     
%     subplot 122
%     plotNetwork(Ca(:,:,i))
%     pause
% end