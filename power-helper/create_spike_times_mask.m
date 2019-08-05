function [ t_spike_mask ] = create_spike_times_mask( t, spike_times )
% CREATE_SPIKE_TIMES_MASK creates a time axis where 200 ms around
% spike times are marked as nan;
%
% INPUTs:
%  t          = [1 x n-timepoints] time axis
% spike_times = [1 x n-spikes] vector containing the time points where all
%               spikes occure
%
% OUTPUT:
% t_spike_mask = [1 x n-timepoints] time axis with spike time +/- 100 ms
%                are marked as nan.

t_spike_mask = t;

for i = 1:length(spike_times)

    t_start = spike_times(i) - 0.1;
    t_stop = spike_times(i) + 0.1;
    indices = t >= t_start & t <= t_stop;

    t_spike_mask(indices) = nan;
end


end

