function model = infer_power( model, pc, data,labelsmsg,bandsmsg)
% INFER_SOZ_COHERENCE computes power in all labels if msg = 'all', or just
% in SOZ if msg = 'SOZ'.
% If bandsmsg = 'individual', the compute power for all individual bands,
% and if = 'general', then computes generic power spectrum
OUTDATAPATH = model.OUTDATAPATH;
subnetwork_params = cfg_power(pc);

fn = fieldnames(subnetwork_params);
nk=numel(fn);


if ~isfield(model,'labels')
    model.labels=[];
end

if strcmp(labelsmsg,'aaa')
    nk = 2;
    PATH = [ OUTDATAPATH model.patient_name '/power_no_spikes.mat'];
else
    PATH = [ OUTDATAPATH model.patient_name '/power.mat'];
end


for k=1:nk
    fprintf(['...computing ' fn{k} ' power \n'])
    nodes = subnetwork_params.(fn{k}).nodes;
    
    if ~isempty(nodes)
        
        if strcmp(bandsmsg,'general')

            if ~isfield(model.labels,fn{k})
                model.labels.(fn{k}) = compute_power(model,data(nodes,:));
                save(PATH,'model')

            end
            
        elseif strcmp(bandsmsg,'individual')
            
            if ~isfield(model.labels,fn{k})
                model.labels.(fn{k})=[];
            end
            
            if ~isfield(model.labels.(fn{k}),'delta')
                fprintf(['... ... ... in delta band \n'])
                model.labels.(fn{k}).delta = compute_power_band(model,data(nodes,:),'delta');
                save([ OUTDATAPATH model.patient_name '/power_all_bands.mat'],'model')
            else
                fprintf(['... ... ... skipping delta band \n'])
            end
            
            if ~isfield(model.labels.(fn{k}),'theta')
                fprintf(['... ... ... in theta band \n'])
                model.labels.(fn{k}).theta = compute_power_band(model,data(nodes,:),'theta');
                save([ OUTDATAPATH model.patient_name '/power_all_bands.mat'],'model')
            else
                fprintf(['... ... ... skipping theta band \n'])
            end
            
            if ~isfield(model.labels.(fn{k}),'alpha')
                fprintf(['... ... ... in alpha band \n'])
                model.labels.(fn{k}).alpha = compute_power_band(model,data(nodes,:),'alpha');
                save([ OUTDATAPATH model.patient_name '/power_all_bands.mat'],'model')
            else
                fprintf(['... ... ... skipping alpha band \n'])
            end
            
%             if ~isfield(model.labels.(fn{k}),'sigma')
%                 
                fprintf(['... ... ... in sigma band \n'])
                model.labels.(fn{k}).sigma = compute_power_band(model,data(nodes,:),'sigma');
                save([ OUTDATAPATH model.patient_name '/power_all_bands.mat'],'model')
%             else
%                 fprintf(['... ... ... skipping sigma band \n'])
%             end
            
%             if ~isfield(model.labels.(fn{k}),'beta')
%                 
                fprintf(['... ... ... in beta band \n'])
                model.labels.(fn{k}).beta = compute_power_band(model,data(nodes,:),'beta');
                save([ OUTDATAPATH model.patient_name '/power_all_bands.mat'],'model')
%             else
%                 fprintf(['... ... ... skipping beta band \n'])
%             end
            
 %           if ~isfield(model.labels.(fn{k}),'gamma')
                fprintf(['... ... ... in gamma band \n'])
                model.labels.(fn{k}).gamma = compute_power_band(model,data(nodes,:),'gamma');
                save([ OUTDATAPATH model.patient_name '/power_all_bands.mat'],'model')
%             else
%                 fprintf(['... ... ... skipping gamma band \n'])
%             end
        end
        
    else
        model.labels.(fn{k}).warning_msg = 'no nodes';
    end
end

model.subnetwork_params = subnetwork_params;

end




