% removeBadComponents - Removes specified bad components from the data.
%
% Syntax: [dataIcaRemoved] = removeBadComponents(comp, data_downsamp, compToRemove)
%
% Inputs:
%   comp (struct)         - The ICA components.
%   dataDownsamp (struct) - The downsampled data.
%   compToRemove (array)  - Array specifying which components to remove.
%
% Outputs:
%   dataIcaRemoved (struct) - The data with specified components removed.
%
% Example:
%   dataIcaRemoved = removeBadComponents(comp, dataDownsamp, [1, 5, 6]);
%
% Notes:
%   Make sure that the bad components are identified accurately via visual inspection.

function [dataIcaRemoved] = removeBadComponents(comp, dataDownsamp, compToRemove)
    % Check for mandatory inputs
    if nargin < 3
        error('All input arguments (comp, data_downsamp, compToRemove) must be provided.');
    end
    
    % Validate the components to remove
    if isempty(compToRemove) || ~isnumeric(compToRemove)
        error('compToRemove must be a numeric array specifying which components to remove.');
    end

    % Configuration for removing the components
    cfg                     = [];
    cfg.component           = compToRemove;  % specify the component(s) to be removed
    dataIcaRemoved          = ft_rejectcomponent(cfg, comp, dataDownsamp);
    
end
