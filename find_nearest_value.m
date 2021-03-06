function [nearestValue,nearestValueIdx] = find_nearest_value( values, target )
% Elizabeth Spencer Sept 22 2019
%
% FIND_NEAREST_VALUE find the values in a vector that are closest to target
% measurements of interest.
% INPUTS:
%   values = vector of numbers that you want to match your target
%   target = vector of values
% OUTPUTS:
%   nearestValue = vector of same dim(target).
%   nearestValueIdx = vector of 0s and 1s indexing where target appears in vector of values.               
% Example:
%  values = [10 3 4 2 1 9 8 7 0 5 6];
%  target = [0.5,0.2,4.2,4.5,9.6];
%  [nearestValue, nearestValueIdx] = find_nearest_value( values, target )
%  OUTPUT:
%   nearestValue = 0     4     4    10
%   nearestValueIdx = 1     0     0     0     1     0     0     0     0     0     1
%
%  NOTE: If target number is half way between two values,  then what is
%  returned is the first number it is closest to (the lowest).


[values_sorted, vsIndex ]= sort(values,'ascend');
nearestValue    = nan(1,length(target));
nearestValueIdx = zeros(1,length(values_sorted));

for i = 1:length(target)
    
    [~,idx]=min(abs(values_sorted-target(i)));
    nearestValue(i)=values_sorted(idx);
    
    idx = find(values==nearestValue(i));
    nearestValueIdx(idx) = 1;
end

nearestValueIdx = logical(nearestValueIdx);
%nearestValueIdx = nearestValueIdx(vsIndex);

end

