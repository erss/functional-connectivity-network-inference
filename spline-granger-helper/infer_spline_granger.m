function [ model ] = infer_spline_granger( model )
%UNTITLED20 Summary of this function goes here
%   Detailed explanation goes here
t=model.t;
window_size = model.window_size;
window_step = model.window_step;
data = model.data_clean;

i_total = 1+floor((t(end)-t(1)-window_size) /window_step);
adj_spline = NaN(size(data,1),size(data,1),i_total);
splinetime = 0;
for k = 1:i_total
    fprintf(['inferring net ' num2str(k) ' out of ' num2str(i_total) '.\n'])

    t_start = t(1) + (k-1) * window_step;   %... get window start time [s],
    t_stop  = t_start + window_size;                  %... get window stop time [s],
    indices = t >= t_start & t < t_stop;
    d = data(:,indices);
    model_temp=model;
    model_temp.data=d;
    tic
    [ adj_spline(:,:,k)] = build_ar_splines( model_temp);
    st  = toc;
    splinetime = splinetime + st;
   fprintf(['..... time: ' num2str(splinetime) '.\n'])

end
model.codetime = splinetime;
model.A = adj_spline;
end

