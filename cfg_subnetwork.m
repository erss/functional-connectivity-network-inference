function subnetwork = cfg_subnetwork( patient_coordinates )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

[LN,RN] = find_subnetwork_coords(patient_coordinates);

%%%% 1) Left SOZ

 subnetwork.leftSOZ.nodes = LN;

%%%% 2) Right SOZ

subnetwork.rightSOZ.nodes = RN;

%%%% 3) From Left to Right SOZ

subnetwork.acrossSOZ.nodes.source = LN;
subnetwork.acrossSOZ.nodes.target = RN;



end

