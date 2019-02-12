%%%% SCRIPT THAT CONTAINS BAD CHANNELS FOR EACH PATIENT

% % MODEL 20 - removed the bad sensor so new data w/o this 
% load('/Users/erss/Documents/MATLAB/pBECTS_inferred_nets/coherence - r3/pBECTS020_rest03__coherence_v3.mat')
% model.bad_channels = [1 2 3 9 10 11 15 19 34 41 44 48 163 164 166 170 173 ... 
%             174 175 176 177 180 195];
% model.bad_time_intervals =[2:45 56 60 78:89 96 97 99 102 150 176 190 267 325 326 329 414 426];

% MODEL 13

model.bad_channels =[1:8 10 12 14 15 16 17 18 20 21 24 25 29 31 32 35 36 39 41 ...
    42 44 47 48 53 54 57 64 69 71 72 74 88 104 130 132 163 165:167 170 ...
   172 177 180 182 183 193 201 206 212 230 233];