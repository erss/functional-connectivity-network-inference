%%%% SCRIPT THAT CONTAINS BAD CHANNELS FOR EACH PATIENT

% MODEL 20
load('/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence - r3/pBECTS020_rest03__coherence_v3.mat')
model.bad_channels = [1 2 3 9 10 11 15 19 34 41 44 48 163 164 166 170 173 ... 
            174 175 176 177 180 195];
model.bad_time_intervals =[2:45 56 60 78:89 96 97 99 102 150 176 190 267 325 326 329 414 426];