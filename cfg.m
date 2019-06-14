function cfg()

global bects_default;

host = java.lang.System.getProperty('user.name');
if strcmp(host, 'erss') % my mac
    bects_default.bectsnetworkstoolbox = '~/Documents/MATLAB/bects-networks-toolbox/';
    bects_default.fcnetworkinference = '~/Documents/MATLAB/fc-network-inference-bootstrap/';
    bects_default.chronuxtoolbox = '~/Documents/MATLAB/Toolboxes/chronux/';
    bects_default.mgh =       '~/Documents/MATLAB/Toolboxes/mgh/';
    bects_default.datapath =  '~/Documents/BECTS-project/bects_data/DKData/';
    bects_default.outdatapathcc = '~/Documents/BECTS-project/bects_results/cross_correlation/';
    bects_default.outdatapathpwc = '~/Documents/BECTS-project/bects_results/coherence_pw/';
    bects_default.outdatapathtc = '~/Documents/BECTS-project/bects_results/coherence_trial/';
    bects_default.outdatapathsg = '';

elseif strcmp(host, 'liz') % Galactica
    bects_default.bectsnetworkstoolbox = '~/Documents/MATLAB/bects-networks-toolbox/';
    bects_default.fcnetworkinference = '~/Documents/MATLAB/fc-network-inference-bootstrap/';
    bects_default.chronuxtoolbox = '~/Documents/MATLAB/Toolboxes/chronux/';
    bects_default.mgh =       '~/Documents/MATLAB/Toolboxes/mgh/';
    bects_default.datapath =   '~/Desktop/bects_data/source_data_2/';
 %   bects_default.outdatapath = '/Users/liz/Desktop/bects_results/nets_final/';
    bects_default.outdatapathcc = '';
    bects_default.outdatapathpwc = '';
    bects_default.outdatapathtc = '';
    bects_default.outdatapathsg = '';


end

end