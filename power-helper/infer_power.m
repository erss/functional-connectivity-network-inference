function model = infer_power( model, pc, data,labelsmsg,bandsmsg)
% INFER_SOZ_COHERENCE computes power in all labels if msg = 'all', or just
% in SOZ if msg = 'SOZ'.
% If bandsmsg = 'individual', the compute power for all individual bands,
% and if = 'general', then computes generic power spectrum

subnetwork_params = cfg_power(pc);

fn = fieldnames(subnetwork_params);

if strcmp(labelsmsg,'all')
    nk=numel(fn);
elseif strcmp(labelsmsg,'SOZ')
    nk=2;
end



for k=1:nk
    fprintf(['...computing ' fn{k} ' power \n'])
    nodes = subnetwork_params.(fn{k}).nodes;
    
    if ~isempty(nodes)
        
        if strcmp(bandsmsg,'general')
           model.labels.(fn{k}) = compute_power(model,data(nodes,:));

        elseif strcmp(bandsmsg,'individual')
            fprintf(['... ... ... in delta band \n'])
            model.labels.(fn{k}).delta = compute_power_band(model,data(nodes,:),'delta');
            fprintf(['... ... ... in theta band \n'])
            model.labels.(fn{k}).theta = compute_power_band(model,data(nodes,:),'theta');
            fprintf(['... ... ... in alpha band \n'])
            model.labels.(fn{k}).alpha = compute_power_band(model,data(nodes,:),'alpha');
            fprintf(['... ... ... in sigma band \n'])
            model.labels.(fn{k}).sigma = compute_power_band(model,data(nodes,:),'sigma');
            fprintf(['... ... ... in beta band \n'])
            model.labels.(fn{k}).beta  = compute_power_band(model,data(nodes,:),'beta');
            fprintf(['... ... ... in gamma band \n'])
            model.labels.(fn{k}).gamma = compute_power_band(model,data(nodes,:),'gamma');
        end
        
    else
        model.labels.(fn{k}).warning_msg = 'no nodes';
    end
end

model.subnetwork_params = subnetwork_params;

end




