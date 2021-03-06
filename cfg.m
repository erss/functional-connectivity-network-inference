function cfg()

global bects_default;
global angelman_default;
% 
% [ret, name] = system('hostname')
% char(java.lang.System.getProperty('user.name'))
% char(java.net.InetAddress.getLocalHost.getHostName)

host = java.lang.System.getProperty('user.name');
if strcmp(host, 'erss')
    % scc
    bects_default.bectsnetworkstoolbox = '/projectnb/ecog/liz/toolboxes/bects-networks-toolbox';
    bects_default.bu =  '/projectnb/ecog/liz/toolboxes/bu';
    bects_default.fcnetworkinference = '/projectnb/ecog/liz/toolboxes/fc-network-inference-bootstrap/';
    bects_default.chronuxtoolbox = '/projectnb/ecog/liz/toolboxes/chronux/';
    bects_default.mgh =       '/projectnb/ecog/liz/toolboxes/mgh/';
    
    bects_default.datapath =  '/projectnb/ecog/BECTS/source_data_ds/';

    bects_default.outdatapathpwr = '/projectnb/ecog/BECTS/bects_results/power/';
    bects_default.outvidpath     = '/projectnb/ecog/BECTS/bects_results/cleaning_videos/';
    bects_default.datapath =  '/projectnb/ecog/BECTS/source_data_ds/';

    angelman_default.fieldtrip = '/projectnb/ecog/liz/toolboxes/fieldtrip-20200409';
    angelman_default.datapath =  '/projectnb/ecog/angelman-data/data/';
    angelman_default.outdatapath =  '/projectnb/ecog/angelman-data/data_mat_files/';
    angelman_default.angelman = '/projectnb/ecog/liz/toolboxes/angelman/';
   
elseif strcmp(host, 'liz') % Galactica
    
    bects_default.splineGrangertoolbox = '~/Documents/MATLAB/spline-granger-causality';
    bects_default.bectsnetworkstoolbox = '~/Documents/MATLAB/bects-networks-toolbox/';
    bects_default.fcnetworkinference = '~/Documents/MATLAB/fc-network-inference-bootstrap/';
    bects_default.chronuxtoolbox = '~/Documents/MATLAB/Toolboxes/chronux/';
    bects_default.mgh =       '~/Documents/MATLAB/Toolboxes/mgh/';
    bects_default.datapath =   '~/Desktop/bects_data/source_data_2/';
    bects_default.outdatapathcc = '~/Desktop/bects_results/cross_correlation/';
    bects_default.outdatapathccf = '~/Desktop/bects_results/cross_correlation_filter/';
    bects_default.outdatapathpwc = '~/Desktop/bects_results/coherence_pairwise/';
    bects_default.outdatapathtc = '~/Desktop/bects_results/coherence_groupwise/';
    bects_default.outdatapathsg = '~/Desktop/bects_results/spline_granger/';
    bects_default.outmoviepath =  '~/Desktop/bects_results/cleaning_movies/';
    bects_default.outdatapathpwr = '~/Desktop/bects_results/power/';
    
elseif strcmp(host,'erss-mac') %%% my mac
     
    % my mac
    bects_default.bectsnetworkstoolbox = '~/Documents/MATLAB/bects-networks-toolbox/';
    bects_default.bu = '~/Documents/MATLAB/Toolboxes/bu/';

    bects_default.fcnetworkinference = '~/Documents/MATLAB/fc-network-inference-bootstrap/';
    bects_default.chronuxtoolbox = '~/Documents/MATLAB/Toolboxes/chronux/';
    bects_default.mgh =       '~/Documents/MATLAB/Toolboxes/mgh/';
    bects_default.splineGrangertoolbox = '~/Documents/MATLAB/spline-granger-causality/';
    bects_default.datapath =  '~/Documents/BECTS-project/bects_data/source_data_ds/';
    bects_default.outdatapathcc = '~/Documents/BECTS-project/bects_results/cross_correlation/';
    bects_default.outdatapathpwc = '~/Documents/BECTS-project/bects_results/coherence_pairwise/';
    bects_default.outdatapathtc = '~/Documents/BECTS-project/bects_results/coherence_trial/';
    bects_default.outdatapathsg = '~/Documents/BECTS-project/bects_results/spline-Granger/';
    bects_default.outmoviepath =  '~/Documents/BECTS-project/bects_results/cleaning_movies/';
    bects_default.outdatapathpwr = '~/Documents/BECTS-project/bects_results/power/';
    bects_default.outdatapathdownsample = '~/Documents/BECTS-project/bects_data/DKData/downsampled_data/';
    bects_default.outvidpath=bects_default.datapath ;

    
    
end

end