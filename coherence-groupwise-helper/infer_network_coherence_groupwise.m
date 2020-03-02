function model = infer_network_coherence_groupwise( model, data, pc,path)
% INFER_SOZ_COHERENCE computes zone coherence in left SOZ, right SOZ and
% left to right SOZ

subnetwork_params = cfg_power(pc);

fn = fieldnames(subnetwork_params);
for k=1:numel(fn)
    fprintf(['...computing ' fn{k} ' coherence \n'])
    nodes = subnetwork_params.(fn{k}).nodes;
    if ~isfield(model,fn{k})
        if size(nodes,1) > 1
            dataN = data(nodes,:);
            model.(fn{k}) = compute_coherence_groupwise(model,dataN);
            model.(fn{k}).nodes = nodes;
            save(path,'model','-v7.3')
        else
            model.(fn{k}).nodes = nodes;
            model.(fn{k}).warning_msg = 'Too few nodes to compute.';
        end
    end
end

model.subnetwork_params = subnetwork_params;

end




