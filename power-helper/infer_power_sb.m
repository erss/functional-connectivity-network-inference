function model = infer_power_sb( model, pc, data,SAVEPATH)
% INFER_SOZ_COHERENCE computes power in all labels if msg = 'all', or just
% in SOZ if msg = 'SOZ'.
% If bandsmsg = 'individual', the compute power for all individual bands,
% and if = 'general', then computes generic power spectrum
OUTDATAPATH = model.OUTDATAPATH;
subnetwork_params = cfg_power(pc);

fn = fieldnames(subnetwork_params);
nk=numel(fn);


for k=1:2%nk
    fprintf(['...computing ' fn{k} ' power \n'])
    nodes = subnetwork_params.(fn{k}).nodes;
    
    if ~isempty(nodes)
        if ~isfield(model,'labels')
            model.labels=[];
        end
        
%         if ~isfield(model.labels,fn{k})
%             model.labels.(fn{k})=[];
%         end
        
        if ~isfield(model.labels,fn{k})
            model.labels.(fn{k}) = compute_power_rem_nan(model,data(nodes,:));
            save(SAVEPATH,'model')
            
        end
        
        
        
    else
        model.labels.(fn{k}).warning_msg = 'no nodes';
    end
end

model.subnetwork_params = subnetwork_params;

end




