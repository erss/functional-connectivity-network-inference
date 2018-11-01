function b = compute_slope( data, f0,f_start,f_stop )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[Sxx, faxis] = pmtm(data,4,size(data,1),f0);
        f_indices = faxis >= f_start & faxis < f_stop;
        X  = log(faxis(f_indices));
        y  = mean(log(Sxx(f_indices,:)),2);
        b = glmfit(X,y);
        b=b(2);

end

