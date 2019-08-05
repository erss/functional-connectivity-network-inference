function model = infer_power( model, pc, data)
% INFER_SOZ_COHERENCE computes power in all labels

subnetwork_params = cfg_power(pc);

fn = fieldnames(subnetwork_params);
for k=1:numel(fn)
    fprintf(['...computing ' fn{k} ' power \n'])
    nodes = subnetwork_params.(fn{k}).nodes;
    
    if ~isempty(nodes)
        model.labels.(fn{k}) = compute_power(model,data(nodes,:));
        
    else
        model.labels.(fn{k}).warning_msg = 'no nodes';
    end
end

model.subnetwork_params = subnetwork_params;

end




