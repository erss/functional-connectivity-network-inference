function nearestValue = find_nearest_value( values, target )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here


[~,idx]=min(abs(values-target));
nearestValue=values(idx);

end

