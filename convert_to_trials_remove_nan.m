function data_trials = convert_to_trials_remove_nan( data, dim1 )
%
% INPUTS:
%  data = [time x n-electrodes]
%  dim1 = window size in samples of desired trial (for ex: 2s * 2035 Hz)
%
% OUTPUT:
%  data = [dim1 x (n-electrodes*time/dim1)]
%
% EXAMPLE:
% M = [(1:22)',(23:44)',(45:66)'];
% 
% M(5:10,1) =nan
% M(7:14,2) =nan
% M(19:22,2)=nan
% 
% convert_to_trials_remove_nan( M, 7 )

% Convert vectors to column vectors.
if isvector(data)
    if size(data,1)==1
        data = data';
    end
end
len   = size(data,1);
tsamp = floor(len/dim1);

nelectrodes = size(data,2);
data_trials =[];
for col = 1:nelectrodes
    signal = data(:,col);
    idx = all(isnan(signal),2);
    idr = diff(find([1;diff(idx);1]));
    D = mat2cell(signal,idr(:),size(signal,2));
    for i = 1:length(D)
        temp = D{i};
        dataTemp = convert_to_trials( temp, dim1 );
        data_trials = [data_trials, dataTemp];
    end
    
end


end

