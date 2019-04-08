%%% Power by trial

DATAPATH    = '~/Desktop/bects_data/DansData';
data_directory = dir(DATAPATH);

load('/Users/erss/Desktop/bects_data/DansData/pBECTS013/sleep_source/pBECTS013_rest02_source.mat');
[ LN,RN ] = find_subnetwork_coords( patient_coordinates_013);
model.sampling_frequency = 2035;
data13=[data_left;data_right];
data13 = data13([LN;RN],:);
n = size(data_left,2);
n1 = floor(n/4070);
data13 = data13(:,1:n1*4070)';
%%
load('/Users/erss/Desktop/bects_data/DansData/pBECTS019/sleep_source/pBECTS019_rest01_source.mat')
[ LN,RN ] = find_subnetwork_coords( patient_coordinates_019);

data19 = [data_left;data_right];
data19 = data19([LN;RN],:);
n = size(data_left,2);
n1 = floor(n/4070);
data19 = data19(:,1:n1*4070)';
%%
load('/Users/erss/Desktop/bects_data/DansData/pBECTS020/sleep_source/pBECTS020_rest05_on-ico-2-position_averaged-sources-from-ico-5.mat')
[ LN,RN ] = find_subnetwork_coords( patient_coordinates_020);

data20 = [data_left;data_right];
data20 = data20([LN;RN],:);
n = size(data_left,2);
n1 = floor(n/4070);
data20 = data20(:,1:n1*4070)';
%% Compute power on ALL healthy
data13 = reshape(data13,4070,[]);
data19 = reshape(data19,4070,[]);
data20 = reshape(data20,4070,[]);

data = [data13 data19 data20];

%%
%data = data';
movingwin = [2 2];
params.tapers = [1 1];
params.pad = -1;
params.Fs = 2035;
params.fpass = [0 50.1];
params.err = [2 0.05];
params.trialave = 1;
%%
tic
[S,t,f,Serr]=mtspecgramc(data,movingwin,params);
tim = toc;

figure;
plot(f,S,'r',f,Serr(1,:),'--r',f,Serr(2,:),'--r')
hold on;

%% Combined SOZ


load('/Users/erss/Desktop/bects_data/DansData/pBECTS006/pBECTS006_sleep07_source.mat')
[ LN,RN ] = find_subnetwork_coords( patient_coordinates_006);
model.sampling_frequency = 2035;
data6=[data_left;data_right];
data6 = data6([LN;RN],:);
n = size(data_left,2);
n1 = floor(n/4070);
data6 = data6(:,1:n1*4070)';
%%
load('/Users/erss/Desktop/bects_data/DansData/pBECTS007/pBECTS007_sleep05_source.mat')
[ LN,RN ] = find_subnetwork_coords( patient_coordinates_007);

data7 = [data_left;data_right];
data7 = data7([LN;RN],:);
n = size(data_left,2);
n1 = floor(n/4070);
data7 = data7(:,1:n1*4070)';
%%
load('/Users/erss/Desktop/bects_data/DansData/pBECTS003/sleep_source/pBECTS003_rest02_source.mat')
[ LN,RN ] = find_subnetwork_coords( patient_coordinates_003);

data3 = [data_left;data_right];
data3 = data3([LN;RN],:);
n = size(data_left,2);
n1 = floor(n/4070);
data3 = data3(:,1:n1*4070)';
%% Compute power on combined SOZ
data3 = reshape(data3,4070,[]);
data6 = reshape(data6,4070,[]);
data7 = reshape(data7,4070,[]);

data = [data3 data6 data7];

%%
%data = data';
movingwin = [2 2];
params.tapers = [1 1];
params.pad = -1;
params.Fs = 2035;
params.fpass = [0 50.1];
params.err = [2 0.05];
params.trialave = 1;
%%
tic
[S,t,f,Serr]=mtspecgramc(data,movingwin,params);
tim = toc;

plot(f,S,'b',f,Serr(1,:),'--b',f,Serr(2,:),'--b')

%%
xlabel('Frequency')
ylabel('Power')
xlim([5 30])
