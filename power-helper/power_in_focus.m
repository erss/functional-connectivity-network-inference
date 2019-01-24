function pwr_spec_density = power_in_focus( model,pc )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

[LNf,RNf] = find_subnetwork_coords(pc);

% S= model.kPower;
% figure;imagesc(squeeze(S(:,1,:)))

pwr = nanmean(model.kPower,3); %%% collapse over time
% figure;plot(pwr(:,1))

total_power = sum(pwr,2);
pwr = pwr./total_power;
pwrF = pwr([LNf;RNf],:);
pwr_spec_density.power_combined = mean(pwrF,1);
pwrF = pwr(LNf,:);
pwr_spec_density.power_left = mean(pwrF,1);
pwrF = pwr(RNf,:);
pwr_spec_density.power_right = mean(pwrF,1);


end

