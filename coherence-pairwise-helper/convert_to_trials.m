function data = convert_to_trials( data, dim1 )
% 
% INPUTS:
%  data = [time x n-electrodes]
%  dim1 = window size in samples of desired trial (for ex: 2s * 2035 Hz)
%
% OUTPUT:
%  data = [dim1 x (n-electrodes*time/dim1)]
%
% EXAMPLE:
%  M = [(1:7)',(8:14)',(15:21)'];
%  Mt= convert_to_trials( M, 3 )

% Convert vectors to column vectors.
if isvector(data)
    if size(data,1)==1
        data = data';
    end
end

len   = size(data,1);
tsamp = floor(len/dim1);
dtemp = data(1:tsamp*dim1,:);
data  = reshape(dtemp,dim1,tsamp*size(data,2));

end
%%%

