function net = pval_2_edge(pval)
% PVAL_2_EDGE takes in a matrix of pvalues of size N1 x N2 x T and uses FDR to convert to
% binary matrix.  Computes for each t in T and ignores NaN inputs. Keeps only the smallest
% (i.e., most significant) p-values.  The following bit of code thresholds
% the p-values using the FDR method.

%%% 1. Compute necessary parameters
q = 0.05;                     % false discovery rate parameter
temp= nanmean(pval,3);
m = sum(sum(isfinite(temp))); % total number of tests performed per t in T
ivals = (1:m)';
qs = ivals*q/m;

%%% 2. Determine significance
net = zeros(size(pval));
num_nets= size(pval,3);

for ii = 1:num_nets
    if sum(sum(isfinite(pval(:,:,ii)))) >0 % if there is at least one finite
                                           % value in pval matrix, continue
        adj_mat = pval(:,:,ii);
        pvals = adj_mat(isfinite(adj_mat));
        pvals = sort(pvals);
        i0 = find(pvals-qs<=0);
        if ~isempty(i0)
            threshold = pvals(max(i0));
        else
            threshold = -1.0;
        end
        % % DIAGNOSTIC PLOT to check p-values.
        %   plot(sort(pvals))
        %   hold on
        %   plot(q*(1:length(pvals))/length(pvals), 'k')
        %   %plot(ones(size(pvals))*0.05/length(pvals), 'r')
        %   hold off

        %Significant p-values are smaller than threshold.
        sigPs = adj_mat <= threshold;
        Ctemp = zeros(size(pval(:,:,1)));
        Ctemp(sigPs)=1;
        net(:,:,ii) = Ctemp;
    else
        net(:,:,ii) = NaN(size(pval(:,:,1)));
    end
end
end
