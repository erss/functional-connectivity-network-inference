function [data_clean,spindle_det] = remove_spindles(data,f0,varargin)
% Procedure to detect and remove all spindles.

% Load data + remove mean ### check this direction
m    = nanmean(data,2);
m    = repmat(m,[1 size(data,2)]);
data = data - m;
nelectrodes = size(data,1);

data_clean = data;

if isempty(varargin)
    % Detect spindles
    hdr.info.sfreq = f0;
    ch_names={};
    for i = 1:nelectrodes
        ch_names{i} = num2str(i);
    end
    hdr.info.ch_names =ch_names;
    options.MinPeakProminence = 2*exp(-12);
    spindle_prob = LSM_spindle_probabilities(data, hdr,options);
    spindle_det = LSM_spindle_detections(spindle_prob);
    
else
    spindle_det = varargin{1};
end

for k = 1:nelectrodes
    tStart = spindle_det(k).startSample;
    tStop  = spindle_det(k).endSample;
    
    nDetections = length(tStart);
    for i = 1:nDetections
        indices = tStart(i):tStop(i);
        data_clean(k,indices)= NaN;
    end
    fprintf(['...electrode ' num2str(k) '/' num2str(nelectrodes) '\n'])
end

% Remove mean after removing bad time intervals
%data_clean = bsxfun(@minus,data_clean,nanmean(data_clean,2));

end

