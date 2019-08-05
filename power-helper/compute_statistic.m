function stat = compute_statistic( f,S,Sfit,f1,f2,str )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

if1 = find(f==f1);
if2 = find(f==f2);


if strcmp(str,'area')
    temp = S(if1:if2) - Sfit(if1:if2);
    stat= sum(temp(temp>0));
    
elseif strcmp(str,'max')
    temp = S(if1:if2) - Sfit(if1:if2);
    stat = max(temp);
    
elseif strcmp(str,'ratio')
    stat =nan;
    
end

if isempty(stat)
    stat=nan;
end

end

