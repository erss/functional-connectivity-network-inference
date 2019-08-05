function yfit = fit_line(f,S,f1,f2)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

if1 = (f==f1);
if2 = (f==f2);
m = (S(if1)- S(if2))/(f1-f2);
b = S(if1) - m*f1;
yfit = m.*f +b;

if isempty(yfit)
    yfit=nan;
end
end

