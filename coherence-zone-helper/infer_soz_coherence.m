function model = infer_soz_coherence( model, pc)
% INFER_SOZ_COHERENCE computes zone coherence in left SOZ, right SOZ and
% left to right SOZ

[LN,RN] = find_subnetwork_coords(pc);
fprintf('...computing left SOZ coherence \n')
model.left = compute_soz_coherence(model,LN);

fprintf('...computing right SOZ coherence \n')
model.right = compute_soz_coherence(model,RN);
nodes.source = LN;
nodes.target = RN;

fprintf('...computing left to right SOZ coherence \n')
model.across = compute_soz_coherence(model,nodes);

fprintf('...computing dom pre-post SOZ coherence \n')
[PreN,PostN] = find_subnetwork_prepost(pc);
nodes.source = PreN;
nodes.target = PostN;
model.prepost = compute_soz_coherence(model,nodes);

[ LNstl,RNstl ] = find_subnetwork_str( pc,'superiortemporal');
fprintf('...computing SOZ to superior temporal lobe coherence left \n')
nodes.source = LN;
nodes.target = LNstl;
model.phoneme_left =compute_soz_coherence(model,nodes);

fprintf('...computing SOZ to superior temporal lobe coherence right \n')
nodes.source = RN;
nodes.target = RNstl;
model.phoneme_right =compute_soz_coherence(model,nodes);



end

