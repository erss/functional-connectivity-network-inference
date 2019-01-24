function [ model ] = gen_surrogate_distr_coh( model,params,movingwin,f_start,f_stop)
% Shuffles channels in time + space to generate distribution of coherence
% and imaginary coherence values

data = model.data_clean;
window_size = model.window_size * model.sampling_frequency;   % window size (samples)
n = size(data,1);   % size of network
T = size(data,2);   % length of network
nsurrogates = model.nsurrogates;

%distr_imag_coh = zeros(1,nsurrogates);
distr_coh      = zeros(1,nsurrogates);

% Determine distance
D = compute_nodal_distances(pc.coords(3:5,:));
[i,j]=find(D<=0.01);

for ii = 1:nsurrogates
    
    ij = randperm(n,2); % Choose two random electrodes i & j, without '
                        % replacement.
    i=ij(1);
    j=ij(2);
    
    while D(i,j) <= 0.01
        ij = randperm(n,2); % Keep choosing electrode pairs until i and j 
                            % are > 0.01 apart.
        i=ij(1);
        j=ij(2);
    end
    while sum(isfinite(data(i,:))) == 0
        i =randperm(n,1); 
    end
    while sum(isfinite(data(j,:))) == 0
        j =randperm(n,1);
    end
    ti = randi(T-window_size+1); % Choose random time, i.
    tj = randi(T-window_size+1); % Choose random time, j.
    xi = data(i,ti:(ti+window_size-1));
    xj = data(j,tj:(tj+window_size-1));
    
 
    
    while sum(sum(isnan(xi))) > 0
        ti = randi(T-window_size+1);
        xi = data(i,ti:(ti+window_size-1));
    end
    
    while sum(sum(isnan(xj))) > 0
        tj = randi(T-window_size+1);
        xj = data(i,tj:(tj+window_size-1));
       
    end
    
    [C,~,~,~,~,~,f]=cohgramc(xi',xj',movingwin,params);
    f_indices = f >= f_start & f <= f_stop;
%    cross_spec = mean(S12(:,f_indices),2);
%     spec1      = mean(S1(:,f_indices),2);
%     spec2      = mean(S2(:,f_indices),2);
%     distr_imag_coh(ii)= imag(cross_spec) ./ sqrt( spec1 ) ./ sqrt( spec2 );
    distr_coh(ii) =  mean(C(:,f_indices),2);
    
    
    fprintf([num2str(ii),'\n'])
end

% Store surrogate distribution, and lags where abs maximum values occur.
%     model.distr_imag_coh = distr_imag_coh;
model.distr_coh = distr_coh;

end

