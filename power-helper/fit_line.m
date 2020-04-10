function yfit = fit_line(x,y,x1,x2)
%  
% FIT_LINE finds line between two points, x1 and x2
%
% INPUTS:
%   x      = x axis
%   y      = y axis
%   x1,x2 = values in x at which to fit a line between.
%
% OUTPUTS:
%   yfit   = line of length y with slope and intercept computed from
%            points (x1,y(x1)) and (x2, y(x2))

x1Index = (x==x1);
x2Index = (x==x2);
m = (y(x1Index)- y(x2Index))/(x1-x2);
b = y(x1Index) - m*x1;
yfit = m.*x +b;

if isempty(yfit)
    yfit=nan;
end
end

