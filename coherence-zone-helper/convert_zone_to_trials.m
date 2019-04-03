function [ d1, d2 ] = convert_zone_to_trials( data,varargin )
% CONVERT_ZONE_TO_TRIALS shuggles data matrix such that all all
% combinations of recordings are paired with each other as a trial, e.g. 
% Sps you have 4 recordings, a,b,c,d to compute coherence between whole
% group, find all 4 choose 2 combinations of a-d and treat each as
% combination as a trial giving you d1 = [a a a b b c]; d2 = [b c d c d d].
%
% INPUTS:
%  data     = [t x channels] data matrix
%  varargin = if this is a structure containing source and targer indices,
%             then trials are made so that they are looking at connections
%             from source to target (excluding within source and target).
%             If empty, then all channels are included in trial.
%
% OUTPUTS:
%  d1,d2    = [t x (n-channels choose 2)] source and target trials to 
%             input into coherence function. 
%  
if nargin==1
    n = size(data,2);
    C = combnk(1:n,2);
elseif nargin==2
    nodes=varargin{1};
    nL = length(nodes.source);
    nR = length(nodes.target);
    C(:,1) = sort(repmat(nodes.source',1,nR));
    C(:,2) = repmat(nodes.target',1,nL);
end

d1 = data(:,C(:,1));
d2 = data(:,C(:,2));
 
end

