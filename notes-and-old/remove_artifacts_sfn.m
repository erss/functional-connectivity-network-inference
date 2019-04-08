function remove_artifacts_sfn( model, patient_coordinates )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Artifacts:
% Net num: 59; Slope: -1.6934 **
% Net num: 417; Slope: -1.6753
% Clean:
% Net num: 24; Slope: -3.019
% Net num: 13; Slope: -3.8871 **
f0=model.sampling_frequency;
data = model.data;
m = mean(data,2);
m = repmat(m,[1 size(data,2)]);
data = data - m;
threshold = -2;
check_artifact = 1;
[LN,RN] = find_subnetwork_central( patient_coordinates);
[ LNt,RNt] = find_subnetwork_lobe( patient_coordinates,'temporal');

%%% Find time chunks with slope > - 2
d = data([LN; RN],:)';
dt = data([[LNt;LN]; [RNt;RN]],:)';


t = model.t;
window_step = 0.5;
window_size = 0.5;
i_total = 1+floor((t(end)-t(1)-window_size) /window_step);  % # intervals.

data_clean = data;
t_clean    = t;
for k = [13 59]
    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
    taxis=t(indices);
    f_start = 30;
    f_stop  = 95;
    
    %%% Pre/Post central
    [Sxx, faxis] = pmtm(d(indices,:),4,sum(indices),f0);
    f_indices = faxis >= f_start & faxis < f_stop;
    X = log(faxis(f_indices));
    y = mean(log(Sxx(f_indices,:)),2);
    b = glmfit(X,y);
    
    %%% Temporal
    [Sxx, faxis] = pmtm(dt(indices,:),4,sum(indices),f0);
    f_indices = faxis >= f_start & faxis < f_stop;
    X  = log(faxis(f_indices));
    y  = mean(log(Sxx(f_indices,:)),2);
    bt = glmfit(X,y);
    
    
    
    if bt(2) > threshold
        figure;
        subplot 121
        plot(X,y,'k','LineWidth',2)
        set(gca,'FontSize',15)
        xlabel('Log Hz','FontSize',18)
        ylabel('Log Mean Power','FontSize',18)
        
        hold on
        plot(X,b(1)+X.*b(2),'--r','LineWidth',2);
        axis tight
        ylim([-55 -50])
        box off
        axis square
        subplot 122
        plotchannels(t(indices), dt(indices,:))
        hold on
        plot([taxis(1),taxis(1)+.05], [1, 1], 'k', 'LineWidth', 2.5);
        set(gca,'YTickLabel',[]);
        set(gca,'XTickLabel',[]);
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        xlabel('Time (s)','FontSize',18)
        %     check_artifact = 0;
        fprintf(['Net num: ' num2str(k) '; Slope: ' num2str(bt(2)) '\n'])
        axis square
    end
    
    if bt(2) <= -2
        figure;
        subplot 121
        plot(X,y,'k','LineWidth',2)
        set(gca,'FontSize',15)
        
        xlabel('Log Hz','FontSize',18)
        ylabel('Log Mean Power','FontSize',18)
        hold on
        plot(X,b(1)+X.*b(2),'--r','LineWidth',2);
        axis tight
        ylim([-55 -50])
        box off
        axis square
        subplot 122
        plotchannels(t(indices), dt(indices,:))
        hold on
        plot([taxis(1),taxis(1)+.05], [1, 1], 'k', 'LineWidth', 2.5);
        set(gca,'YTickLabel',[]);
        set(gca,'XTickLabel',[]);
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        xlabel('Time (s)','FontSize',18)
        % check_artifact = 0;
        fprintf(['Net num: ' num2str(k) '; Slope: ' num2str(bt(2)) '\n'])
        
        axis square
    end
    %   fprintf([num2str(k),'\n'])
    
end


end

