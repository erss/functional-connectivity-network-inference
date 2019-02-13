function P = correct_for_distance( A,D,pc )
% CORRECT_FOR_DISTANCE computes significance of coupling between two nodes
% given their Euclidean distance.  
%
%
% INPUTS:
%   A: 2D or 3D matrix of FC raw values
%   D: Corresponding 2D matrix containing distances between each node pair
%   pc: structure patient_coordinates xyz coordinates
%
% OUTPUT:
%   P: ???
 
[LN, RN] = find_subnetwork_central(pc);
n= size(A,1); % number of electrodes
nsurrogates = 10000;
surrogate_distr_left   = dist_surrogates( A,D,LN,LN );
surrogate_distr_right  = dist_surrogates( A,D,RN,RN );
surrogate_distr_across = dist_surrogates( A,D,LN,RN );
surrogate_distr_global = dist_surrogates( A,D,1:n,1:n);
surrogate_distr_focus  = dist_surrogates_focus( A,D,LN,RN );
pval_left = distr_2_pval(A,surrogate_distr_left,LN,LN );
% 
histogram(surrogate_distr_left,'FaceColor','r');
hold on;
Aleft= A(LN,LN,:);
Aright = A(RN,RN,:);
Across = A(LN,RN,:);
Atemp = [Aleft(:); Aright(:)];
%Atemp = [Across(:)];

Atemp(isnan(Atemp)) = [];
Atemp = Atemp(randi(length(Atemp),1,10000));
histogram(Atemp,'FaceColor','g');
title('focus')
%  histogram(Atemp,'Normalization','probability','FaceColor','g');




%             P(i,j)= p/nsurrogates; % smaller the value more significant
%             

% P = nan(size(D));
% for k = 1:1;%size(A,3)
%     for i = 1:n
%         for j=i+1:n
%             %%% AT SOME POINT REMOVE kSTAT from surrogate dist
%             %%% MAKE SURE SELF-COUPLING
%             kStat = A(i,j,k);
%             dist =  D(i,j);
% 
%             [x,y]= find(D==dist); %% find range <0.005 - try 0.002
%             surrogate_stats = A(x,y,:);
%             surrogate_stats=surrogate_stats(:);
%             %%% with replacement
%             ii = randi(length(surrogate_stats),[1,nsurrogates]) ;
%             surrogate_stats = surrogate_stats(ii);
%             p =sum(surrogate_stats>kStat); % upper tail ???
%             P(i,j)= p/nsurrogates; % smaller the value more significant
%             
%             if (p == 0)
%                 P(i,j)=0.5/nsurrogates;
%             end
%             
%           
%        fprintf(['i: ' num2str(i) ', j: ' num2str(j) ' \n'])
%         end
%           
%     end
%     
% end


end

