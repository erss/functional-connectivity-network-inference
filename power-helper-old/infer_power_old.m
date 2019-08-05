function model = infer_power_old( model, pc, data_cell)
% INFER_SOZ_COHERENCE computes power in all labels

subnetwork_params = cfg_power(pc,model.f0);

fn = fieldnames(subnetwork_params);
for k=1:numel(fn)
    fprintf(['...computing ' fn{k} ' coherence \n'])
    nodes = subnetwork_params.(fn{k}).nodes;
    model.(fn{k}) = compute_power_old(model,nodes,data_cell);
end

model.subnetwork_params = subnetwork_params;

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


% %%% ----- Normalize by other brain region left and right ------------------
% 
% [ LNf,RNf] = find_subnetwork_str( pc,'superiorfrontal');
% fprintf('...computing left superior frontal lobe coherence \n');
% if length(LN) < length(LNf)
%     i = randperm(length(LNf),length(LN));
%     nodes = LNf(i);
% else
%     nodes = LNf;
% end
% model.superior_frontal_left = compute_soz_coherence(model,nodes);
% model.superior_frontal_left.nodes =nodes;
% model.superior_frontal_left.LNf =LNf;
% fprintf('...computing left superior fromtal lobe coherence \n');
% if length(RN) < length(RNf)
%     i = randperm(length(RNf),length(RN));
%     nodes = RNf(i);
% else
%     nodes = RNf;
% end
% model.superior_frontal_right = compute_soz_coherence(model,nodes);
% model.superior_frontal_right.nodes =nodes;
% model.superior_frontal_right.RNf =RNf;

end




