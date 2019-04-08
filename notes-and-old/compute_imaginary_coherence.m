

function [icohr,t,f] = compute_imaginary_coherence(data1, data2, movingwin, params)

  [~,~,S12,S1,S2,t,f]=cohgramc_MAK(data1,data2,movingwin,params);
  icohr = imag(S12(1,:)) ./ sqrt( S1(1,:) ) ./ sqrt( S2(1,:) );
  
end