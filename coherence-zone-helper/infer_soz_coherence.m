function model = infer_soz_coherence( model, pc)
% INFER_SOZ_COHERENCE computes zone coherence in left SOZ, right SOZ and
% left to right SOZ
[LN,RN] = find_subnetwork_coords(pc);
fprintf(['...computing left SOZ coherence \n'])
model.left = compute_soz_coherence(model,LN);
fprintf(['...computing right SOZ coherence \n'])
model.right = compute_soz_coherence(model,RN);
nodes.source = LN;
nodes.target = RN;
fprintf(['...computing left to right SOZ coherence \n'])
model.across = compute_soz_coherence(model,nodes);


[LNp,RNp] = find_subnetwork_lobe( pc,'parietal');
[LNt,RNt] = find_subnetwork_lobe( pc,'temporal');
[LNo,RNo] = find_subnetwork_lobe( pc,'occipital');
[LNf,RNf] = find_subnetwork_lobe( pc,'frontal');

LNt = setdiff(LNt,LN);
RNt = setdiff(RNt,RN);
LNp = setdiff(LNp,LN);
RNp = setdiff(RNp,RN);
fprintf(['...computing left temporal coherence \n'])
model.temporal_left  = compute_soz_coherence(model,LNt);
fprintf(['...computing right temporal coherence \n'])
model.temporal_right  = compute_soz_coherence(model,RNt);

fprintf(['...computing left occipital coherence \n'])
model.occipital_left  = compute_soz_coherence(model,LNo);
fprintf(['...computing right occipital coherence \n'])
model.occipital_right = compute_soz_coherence(model,RNo);
ç
fprintf(['...computing left frontal coherence \n'])
model.frontal_left   = compute_soz_coherence(model,LNf);

fprintf(['...computing right frontal coherence \n'])
model.frontal_right  = compute_soz_coherence(model,RNf);

fprintf(['...computing left parietal coherence \n'])
model.parietal_left  = compute_soz_coherence(model,LNp);
fprintf(['...computing right parietal coherence \n'])
model.parietal_right = compute_soz_cohernece(model,RNp);

end

