function [ data ] = remove_bad_channels( model )
% Removes all noisy channels noted by eye. Mark as NaN values.
if isfield(model,'bad_channels')
    bad_channels = model.bad_channels;
    data = model.data;
    data(bad_channels,:) = NaN(length(bad_channels),size(data,2));
else
    data=model.data;
end

end

