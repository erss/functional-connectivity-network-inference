function regions = cfg_power( patient_coordinates )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

%%%% 1) Left and right SOZ
[LN,RN] = find_subnetwork_coords(patient_coordinates);
regions.leftSOZ.nodes = LN;
regions.rightSOZ.nodes = RN;


%%%% 2) Pre to post CG left and right
pctemp = patient_coordinates;
pctemp.hand = 'left';
[ PreRN,PostRN,PreUpperRN,PostUpperRN ] = find_subnetwork_prepost( pctemp);
pctemp.hand = 'right';
[ PreLN,PostLN,PreUpperLN,PostUpperLN ] = find_subnetwork_prepost( pctemp);

regions.leftMotorNetwork.nodes  = [PreLN;PostLN];
regions.rightMotorNetwork.nodes = [PreRN;PostRN];

%%%% 3) Pre to post CG upper coords left and right

regions.leftMotorNetworkUpper.nodes  = [PreUpperLN;PostUpperLN];
regions.rightMotorNetworkUpper.nodes = [PreUpperRN;PostUpperRN];

%%%% 4) SOZ + Superior temporal lobe
[LNst,RNst] = find_subnetwork_str( patient_coordinates,'superiortemporal');
[LN,RN]     = find_subnetwork_coords(patient_coordinates);

regions.leftLangNetwork.nodes  = [LN;LNst];
regions.rightLangNetwork.nodes = [RN;RNst];

%%%% 5) Superior temporal lobe
regions.leftSuperiorTemporal.nodes  = LNst;
regions.rightSuperiorTemporal.nodes = RNst;

%%%% 6) Middle temporal lobe
[LN,RN] = find_subnetwork_str( patient_coordinates,'middletemporal');
regions.leftMedialTemp.nodes  = LN;
regions.rightMedialTemp.nodes = RN;

%%%% 7) Inferior temporal
[LN,RN]=find_subnetwork_str( patient_coordinates,'inferiortemporal');
regions.leftInfTemp.nodes  = LN;
regions.rightInfTemp.nodes = RN;

%%%% 8) lateral occipital
[LN,RN]=find_subnetwork_str( patient_coordinates,'lateraloccipital');
regions.leftLateralOccip.nodes  = LN;
regions.rightLateralOccip.nodes = RN;

%%%% 9) inferior parietal
[LN,RN]=find_subnetwork_str( patient_coordinates,'inferiorparietal');
regions.leftInfParietal.nodes  = LN;
regions.rightInfParietal.nodes = RN;

%%%% 10) supramarginal
[LN,RN]=find_subnetwork_str( patient_coordinates,'supramarginal');
regions.leftSupraMarginal.nodes  = LN;
regions.rightSupraMarginal.nodes = RN;

%%%% 11) superior parietal
[LN,RN]=find_subnetwork_str( patient_coordinates,'superiorparietal');
regions.leftSuperiorParietal.nodes  = LN;
regions.rightSuperiorParietal.nodes = RN;

%%%% 12) insula
[LN,RN]=find_subnetwork_str( patient_coordinates,'insula');
regions.leftInsula.nodes  = LN;
regions.rightInsula.nodes = RN;

%%%% 13) opercularis
[LN,RN]=find_subnetwork_str( patient_coordinates,'parsopercularis');
regions.leftOpercularis.nodes  = LN;
regions.rightOpercularis.nodes = RN;

%%%% 14) caudal middle frontal
[LN,RN]=find_subnetwork_str( patient_coordinates,'caudalmiddlefrontal');
regions.leftCaudalMiddleFrontal.nodes  = LN;
regions.rightCaudalMiddleFrontal.nodes = RN;


%%%% 15) superior frontal
[LN,RN]=find_subnetwork_str( patient_coordinates,'superiorfrontal');
regions.leftSuperiorFrontal.nodes  = LN;
regions.rightSuperiorFrontal.nodes = RN;

%%%% 16) rostral middle frontal
[LN,RN]=find_subnetwork_str( patient_coordinates,'rostralmiddlefrontal');
regions.leftRostralMiddleFrontal.nodes  = LN;
regions.rightRostralMiddleFrontal.nodes = RN;

%%%% 17) triangularis
[LN,RN]=find_subnetwork_str( patient_coordinates,'parstriangularis');
regions.leftTriangularis.nodes  = LN;
regions.rightTriangularis.nodes = RN;

%%%% 18) orbitalis
[LN,RN]=find_subnetwork_str( patient_coordinates,'parsorbitalis');
regions.leftOrbitalis.nodes  = LN;
regions.rightOrbitalis.nodes = RN;

%%%% 19) lateral orbitofrontal
[LN,RN]=find_subnetwork_str( patient_coordinates,'lateralorbitofrontal');
regions.leftLateralOrbitoFrontal.nodes  = LN;
regions.rightLateralOrbitoFrontal.nodes = RN;

%%%% 20) paracentral
[LN,RN]=find_subnetwork_str( patient_coordinates,'paracentral');
regions.leftParacentral.nodes  = LN;
regions.rightParacentral.nodes = RN;

%%%% 21) precuneus
[LN,RN]=find_subnetwork_str( patient_coordinates,'precuneus');
regions.leftPrecuneus.nodes  = LN;
regions.rightPrecuneus.nodes = RN;

%%%% 22) cuneus
[LN,RN]=find_subnetwork_str( patient_coordinates,'cuneus');
regions.leftCuneus.nodes  = LN;
regions.rightCuneus.nodes = RN;

%%%% 23) pericalcarine
[LN,RN]=find_subnetwork_str( patient_coordinates,'pericalcarine');
regions.leftPericalarine.nodes = LN;
regions.rightPericalarine.nodes = RN;

%%%% 24) lingual
[LN,RN]=find_subnetwork_str( patient_coordinates,'lingual');
regions.leftLingual.nodes  = LN;
regions.rightLingual.nodes = RN;


%%%% 25) isthmus cingulate
[LN,RN]=find_subnetwork_str( patient_coordinates,'isthmuscingulate');
regions.leftIsthmuscingulate.nodes  = LN;
regions.rightIsthmuscingulate.nodes = RN;

%%%% 26) posterior cingulate
[LN,RN]=find_subnetwork_str( patient_coordinates,'posteriorcingulate');
regions.leftPosteriorCingulate.nodes  = LN;
regions.rightPosteriorCingulate.nodes = RN;

%%%% 27) caudal anterior cingulate
[LN,RN]=find_subnetwork_str( patient_coordinates,'caudalanteriorcingulate');
regions.leftCaudalAnteriorCingulate.nodes  = LN;
regions.rightCaudalAnteriorCingulate.nodes = RN;

%%%% 28) rostral anterior cingulate
[LN,RN] = find_subnetwork_str( patient_coordinates,'rostralanteriorcingulate');
regions.leftRostralAnteriorCingulate.nodes  = LN;
regions.rightRostralAnteriorCingulate.nodes = RN;

%%%% 29) medialorbito frontal
[LN,RN] = find_subnetwork_str( patient_coordinates,'medialorbitofrontal');
regions.leftMedialOrbitoFrontal.nodes  = LN;
regions.rightMedialOrbitoFrontal.nodes = RN;

%%%% 30) parahippocampal
[LN,RN] = find_subnetwork_str( patient_coordinates,'parahippocampal');
regions.leftParahippocampal.nodes  = LN;
regions.rightParahippocampal.nodes = RN;

%%%% 31) entorhinal
[LN,RN] = find_subnetwork_str( patient_coordinates,'entorhinal');
regions.leftEntorhinal.nodes  = LN;
regions.rightEntorhinal.nodes = RN;

%%%% 32) fusiform
[LN,RN] = find_subnetwork_str( patient_coordinates,'fusiform');
regions.leftFusiform.nodes  = LN;
regions.rightFusiform.nodes = RN;

end



% fprintf('...computing dom pre-post SOZ coherence \n')
% [PreN,PostN,PrUp,PoUp] = find_subnetwork_prepost(pc);
% nodes.source = PreN;
% nodes.target = PostN;
% model.prepost = compute_soz_coherence(model,nodes);
%
% fprintf('...computing dom pre-post in upper SOZ coherence \n')
% nodes.source = PrUp;
% nodes.target = PoUp;
% model.prepost_upper = compute_soz_coherence(model,nodes);
%
%
% fprintf('...computing dom pre & post SOZ coherence \n')
% model.prepost_all = compute_soz_coherence(model,[PreN; PostN]);
%
% fprintf('...computing dom pre & post upper SOZ coherence \n')
% model.prepost_all_upper = compute_soz_coherence(model,[PrUp; PoUp]);
%
% % ----- Find other pre to post coherence -----------------------------
% pc_temp =pc;
% hand = pc.hand;
% if strcmp(hand,'right')
%    pc_temp.hand = 'left';
% end
%
% if strcmp(hand,'left')
%     pc_temp.hand = 'right';
% end
%
% fprintf('...computing non dom pre-post SOZ coherence \n')
% [PreN,PostN,PrUp,PoUp] = find_subnetwork_prepost(pc_temp);
% nodes.source = PreN;
% nodes.target = PostN;
% model.prepost_nondom = compute_soz_coherence(model,nodes);
%
% fprintf('...computing non dom pre-post in upper SOZ coherence \n')
% nodes.source = PrUp;
% nodes.target = PoUp;
% model.prepost_upper_nondom = compute_soz_coherence(model,nodes);
%
%
% fprintf('...computing non dom pre & post SOZ coherence \n')
% model.prepost_all_nondom = compute_soz_coherence(model,[PreN; PostN]);
%
% fprintf('...computing non dom pre & post upper SOZ coherence \n')
% model.prepost_all_upper_nondom = compute_soz_coherence(model,[PrUp; PoUp]);
%
% [ LNstl,~ ] = find_subnetwork_str( pc,'superiortemporal');
% fprintf('...computing SOZ to superior temporal lobe coherence left \n')
% nodes.source = LN;
% nodes.target = LNstl;
% model.phoneme_left =compute_soz_coherence(model,nodes);
%
% fprintf('...computing within left superior temporal lobe coherence \n')
% model.left_stl =compute_soz_coherence(model,LNstl);


