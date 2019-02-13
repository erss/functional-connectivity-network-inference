function pval = distr_2_pval(A, distr)
% DISTR_2_PVAL 
%
% INPUT:
%   A     = 2D or 3D matrix of FC raw values
%   distr = surrogate distribution
%
% OUTPUT:
%   Pval = surrogate distribution of 10000 values within range.

kStats=  A(:);
distr = sort(reshape(distr,length(distr),1),'ascend');
C = bsxfun(@gt,distr,kStats'); % gt = greater than; ge ?
pval = sum(C,1)./length(distr); % upper tail ???
pval = reshape(pval,size(A));

if size(A,1)==size(A,2) && sum(isfinite(A(end,1,:))) == 0
    % if A is square and the bottom left connection is always 0, then
    % ensure that the lower diagonal of the pval matrix is nan.
    T = ones(size(A,1),size(A,2));
    T = tril(T);
    T(T==1) = nan;
    pval = bsxfun(@plus,pval,T);
end

t = squeeze(isnan(A(1,2,:)));
ii = find(t==1);
pval(:,:,ii) = nan([size(pval(:,:,1)),length(ii)]);
pval(pval==0) = 0.5/length(distr);

end

