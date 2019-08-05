function data = remove_mask(data,t_mask)
% REMOVE_MASK marks times in electrode recordings that have been marked as
% bad to be nan.  
% INPUTS:
% T_MASK = [1 x n-time points] time axis in seconds/ms/... that starts at
%          the beginning of the recording to the end.  The sections that
%          contain nan values in lieu of time stamps are what will be
%          removed in the data
% DATA   = [n-channels x n-time points] data matrix of n-channel recordings
%          
% OUTPUT:
% DATA   = [n-channels x n-time points] data matrix where all periods of
%           time that are nan in T_MASK are marked as nan
%
% Example of usage: 
% x = randn(5,10)
% 
% xMask = [1:10];
% xMask(2:4)=NaN;
% xMask(6:9)=NaN;
% 
% xTest = remove_mask(x,xMask)

i_mask = isfinite(t_mask);
i_mask = double(i_mask);
i_mask(i_mask==0)=nan;
data = bsxfun(@times,data,i_mask);

end

