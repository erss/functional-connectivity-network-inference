function cfg()

global bects_default;

host = java.lang.System.getProperty('user.name');
if strcmp(host, 'erss') % my mac
    bects_default.bectsnetworkstoolbox = '~/Documents/MATLAB/bects-networks-toolbox/';
    bects_default.fcnetworkinference = '~/Documents/MATLAB/fc-network-inference-bootstrap/';
    bects_default.chronuxtoolbox = '~/Documents/MATLAB/Toolboxes/chronux/';
    bects_default.mgh =       '~/Documents/MATLAB/Toolboxes/mgh/';
    bects_default.splineGrangertoolbox = '~/Documents/MATLAB/spline-granger-causality/';
    bects_default.datapath =  '~/Documents/BECTS-project/bects_data/DKData/';
    bects_default.outdatapathcc = '~/Documents/BECTS-project/bects_results/cross_correlation/';
    bects_default.outdatapathpwc = '~/Documents/BECTS-project/bects_results/coherence_pairwise/';
    bects_default.outdatapathtc = '~/Documents/BECTS-project/bects_results/coherence_trial/';
    bects_default.outdatapathsg = '~/Documents/BECTS-project/bects_results/spline-Granger/';
    bects_default.outmoviepath =  '~/Documents/BECTS-project/bects_results/cleaning_movies/';
    bects_default.outdatapathpwr = '~/Documents/BECTS-project/bects_results/power/';
    
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
    

end

end