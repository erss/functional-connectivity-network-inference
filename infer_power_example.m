%%% fc-network-ex

% DYANMIC NETWORK SCRIPT EXAMPLE
addpath(genpath('Toolboxes/chronux_2_12'))
addpath(genpath('Toolboxes/mgh'))

%%% 1. LOAD DATA
 model.patient_name ='Patient 20';
 model.data = [data_left; data_right];
 pc = patient_coordinates_020;

%%% 2. LOAD MODEL PARAMETERS
model.sampling_frequency = 2035;
model.window_step = 1;% 0.5; % in seconds
model.window_size = 2;   % in seconds
model.q=0.05;
model.nsurrogates = 10000;
model.t=time;

%%% 3. Remove artifacts
model = remove_artifacts_all_lobes(model,pc);

%%% 4. INFER NETWORK
model = infer_power(model);

%%% 5. SAVE DATA
% model.data = NaN;  % clear data
% model.data_clean = NaN;  % clear data
% save([ model.patient_name '_coherence.mat'],'model')

%%%%%%%%%%%%%%%%%%%%%%%% 
 
%% 6. PLOT GRID 
figure;
xyz=pc.coords(3:5,:);
G= graph(zeros(324,324));

subplot 231
p = plot(G,'XData',xyz(1,:),'YData',xyz(2,:),'ZData',xyz(3,:),'MarkerSize',4,'NodeColor',[0.3010, 0.7450, 0.9330]);
p.NodeCData=log(nanmean(model.delta_power,2));
view(-90,90)
axis square
title('delta log power')
colorbar

subplot 232
p = plot(G,'XData',xyz(1,:),'YData',xyz(2,:),'ZData',xyz(3,:),'MarkerSize',4,'NodeColor',[0.3010, 0.7450, 0.9330]);
p.NodeCData=log(nanmean(model.theta_power,2));
view(-90,90)
axis square
title('theta log power')
colorbar

subplot 233
p = plot(G,'XData',xyz(1,:),'YData',xyz(2,:),'ZData',xyz(3,:),'MarkerSize',4,'NodeColor',[0.3010, 0.7450, 0.9330]);
p.NodeCData=log(nanmean(model.alpha_power,2));
view(-90,90)
axis square
title('alpha log power')
colorbar

subplot 234
p = plot(G,'XData',xyz(1,:),'YData',xyz(2,:),'ZData',xyz(3,:),'MarkerSize',4,'NodeColor',[0.3010, 0.7450, 0.9330]);
p.NodeCData=log(nanmean(model.sigma_power,2));
view(-90,90)
axis square
title('sigma log power')
colorbar

subplot 235
p = plot(G,'XData',xyz(1,:),'YData',xyz(2,:),'ZData',xyz(3,:),'MarkerSize',4,'NodeColor',[0.3010, 0.7450, 0.9330]);
p.NodeCData=log(nanmean(model.beta_power,2));
view(-90,90)
axis square
title('beta log power')
colorbar

subplot 236
p = plot(G,'XData',xyz(1,:),'YData',xyz(2,:),'ZData',xyz(3,:),'MarkerSize',4,'NodeColor',[0.3010, 0.7450, 0.9330]);
p.NodeCData=log(nanmean(model.gamma_power,2));
view(-90,90)
axis square
title('gamma log power')
colorbar

%%
dpower = mean(model.delta_power,2)*10^6;
tpower = mean(model.theta_power,2)*10^6;
apower = mean(model.alpha_power,2)*10^6;
spower = mean(model.sigma_power,2)*10^6;
bpower = mean(model.beta_power,2)*10^6;
gpower = mean(model.gamma_power,2)*10^6;



str_list = {'temporal','parietal','occipital','frontal','focus'};
nS = length(str_list);

GN = [];

figure;
for k = 1:6
    
    
    subplot(6,1,k);
    mean_data = zeros(nS,2);
    sem_data  = zeros(nS,2);
    GN = [];
    
    for i = 1:nS
        if i == nS
            [LN,RN] = find_subnetwork_coords(pc);
        else
            [LN,RN] = find_subnetwork_lobe(pc,str_list{i});
            GN = [GN; LN; RN];
        end
        
        if k == 1
            mean_data(i,1) = mean(dpower(LN));
            mean_data(i,2) = mean(dpower(RN));
            sem_data(i,1)  = std(dpower(LN))/sqrt(length(LN));
            sem_data(i,2)  = std(dpower(RN))/sqrt(length(RN));
            str='delta (\muV)'
            v =[0 2*10^-13];
        elseif k==2
            mean_data(i,1) = mean(tpower(LN));
            mean_data(i,2) = mean(tpower(RN));
            sem_data(i,1)  = std(tpower(LN))/sqrt(length(LN));
            sem_data(i,2)  = std(tpower(RN))/sqrt(length(RN));
            str = 'theta (\muV)'
            v =[0 6*10^-14];
        elseif k==3
            mean_data(i,1) = mean(apower(LN));
            mean_data(i,2) = mean(apower(RN));
            sem_data(i,1)  = std(apower(LN))/sqrt(length(LN));
            sem_data(i,2)  = std(apower(RN))/sqrt(length(RN));
            str = 'alpha (\muV)'
             v =[0 4*10^-14];
        elseif k==4
            mean_data(i,1) = mean(spower(LN));
            mean_data(i,2) = mean(spower(RN));
            sem_data(i,1)  = std(spower(LN))/sqrt(length(LN));
            sem_data(i,2)  = std(spower(RN))/sqrt(length(RN));
            str = 'sigma (\muV)'
             v =[0 2*10^-14];
        elseif k==5
            mean_data(i,1) = mean(bpower(LN));
            mean_data(i,2) = mean(bpower(RN));
            sem_data(i,1)  = std(bpower(LN))/sqrt(length(LN));
            sem_data(i,2)  = std(bpower(RN))/sqrt(length(RN));
            str= 'beta (\muV)'
            v =[0 1*10^-14];
        elseif k==6
            mean_data(i,1) = mean(gpower(LN));
            mean_data(i,2) = mean(gpower(RN));
            sem_data(i,1)  = std(gpower(LN))/sqrt(length(LN));
            sem_data(i,2)  = std(gpower(RN))/sqrt(length(RN));
            str= 'gamma (\muV)'
            v =[0 2*10^-16];
        end
        

    end
    
            h1 = bar(mean_data);
set(gca, 'XTick', 1:nS, 'XTickLabel', str_list);
xtickangle(-45)
xData1 = h1(1).XData+h1(1).XOffset;
xData2 = h1(2).XData+h1(2).XOffset;
xData = sort([xData1 xData2],'ascend');
xData = reshape(xData,2,nS)';
hold on
errorbar(xData,mean_data,1.96.*sem_data,'b.')
ylabel(str)
ylim(v)
    
    suptitle(model.patient_name)
end




