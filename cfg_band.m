function [ band_params ] = cfg_band( band )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

% Delta: [2, 4]   --> W = 1,   T = 5,   2TW-1 = 9
% Theta: [4, 8]   --> W = 2,   T = 3,   2TW-1 = 11
% Alpha: [8, 12]  --> W = 2,   T = 3,   2TW-1 = 11
% Sigma: [10, 15] --> W = 2.5, T = 2,   2TW-1 = 9
% Beta:  [15, 30] --> W = 7.5, T = 1,   2TW-1 = 14
% Gamma: [30, 50] --> W = 10,  T = 0.5, 2TW-1 = 9

band_params.params.trialave = 1;           % ... trial average.
band_params.params.fpass    = [1 50.1];    % ... freq range to pass.
band_params.params.Fs       = 2035;        % ... sampling frequency.
band_params.params.err      = [2 0.05];    % ... Jacknife error bars, p =0.05;

if strcmp(band,'delta')
%     band_params.W           = 1;
%     band_params.window_step = 5;       % in seconds
%     band_params.window_size = 5;       % in seconds
%     band_params.f_start     = 3;
%     band_params.f_stop      = 3;
%     band_params.params.pad  = -1;      % ... no zero padding.
%     band_params.fband       = 'delta';

    band_params.W           = 1;
    band_params.window_step = 1;       % in seconds
    band_params.window_size = 1;       % in seconds
    band_params.f_start     = 3;
    band_params.f_stop      = 3;
    band_params.params.pad  = -1;      % ... no zero padding.
    band_params.fband       = 'delta';
    
elseif strcmp(band,'theta')
    band_params.W           = 2;
    band_params.f_start     = 6;
    band_params.f_stop      = 6;
    band_params.window_step = 3;  % in seconds
    band_params.window_size = 3;  % in seconds
    band_params.params.pad  = -1; % ... no zero padding.
    band_params.fband = 'theta';
    
elseif strcmp(band,'alpha')
    band_params.W           = 2;
    band_params.f_start     = 10;
    band_params.f_stop      = 10;
    band_params.window_step = 3;  % in seconds
    band_params.window_size = 3;  % in seconds
    band_params.params.pad  = -1; % ... no zero padding.
    band_params.fband = 'alpha';
elseif strcmp(band,'sigma')
%     band_params.W           = 2.5;
%     band_params.f_start     = 12.5;
%     band_params.f_stop      = 12.5;
%     band_params.window_step = 2;      % in seconds
%     band_params.window_size = 2;      % in seconds
%     band_params.params.pad  = -1;     % ... no zero padding.
%     band_params.fband = 'sigma';
% [10 16]
    band_params.W           = 3;
    band_params.f_start     = 13;
    band_params.f_stop      = 13;
    band_params.window_step = 1;      % in seconds
    band_params.window_size = 1;      % in seconds
    band_params.params.pad  = -1;     % ... no zero padding.
    band_params.fband = 'sigma';
    
elseif strcmp(band,'beta')
    band_params.W           = 7.5;
    band_params.f_start     = 22.3572;
    band_params.f_stop      = 22.3572;
    band_params.window_step = 1;       % in seconds
    band_params.window_size = 1;       % in seconds
    band_params.params.pad  = 1;       % ... with zero padding.
    band_params.fband       = 'beta';
    
elseif strcmp(band, 'gamma')
    band_params.W           = 10;
    band_params.f_start     = 39.9804;
    band_params.f_stop      = 39.9804;
    band_params.window_step = 0.5;   % in seconds
    band_params.window_size = 0.5;   % in seconds
    band_params.params.pad  = -1;    % ... no zero padding.
    band_params.fband = 'gamma';
end

TW                        = band_params.window_size*band_params.W;  % Time bandwidth product.
ntapers                   = 2*TW-1;                                 % Choose the # of tapers.
band_params.params.tapers = [TW,ntapers];                           % time-bandwidth product and tapers.
band_params.movingwin     = [band_params.window_size, band_params.window_step]; % Window size and step.
end

