function [mriSegmented, headModel] = createHeadModel(mriCoreg, targetUnit)
    %CreateHeadModel Segments the MRI and computes the head model.
    %
    % This function segments the provided co-registered MRI data into 
    % brain, skull, and scalp components. It then computes a single-shell 
    % head model from the segmented MRI. The units for the head model are 
    % ensured to be consistent, as specified by the targetUnit parameter.
    %
    % Usage:
    % [mriSegmented, headModel] = CreateHeadModel(mriCoreg, targetUnit)
    %
    % Inputs:
    % mriCoreg - A structure containing co-registered MRI data.
    % targetUnit - A string specifying the target unit (default is 'cm').
    %
    % Outputs:
    % mriSegmented - A structure containing segmented MRI data.
    % headModel - A structure containing the head model in the target unit.
    
    % Check if the targetUnit parameter is supplied
    if nargin < 2
        targetUnit = 'cm'; % Default unit if none specified
    end
    
    % Segment the MRI into brain, skull, and scalp
    cfg = [];
    cfg.output = {'brain', 'skull', 'scalp'};
    mriSegmented = ft_volumesegment(cfg, mriCoreg);
    
    % Add anatomical information to the segmentation
    mriSegmented.anatomy = mriCoreg.anatomy;
    
    % Compute the head model
    cfg = [];
    cfg.method = 'singleshell';
    headModel = ft_prepare_headmodel(cfg, mriSegmented);
    
    % Convert the head model to the specified unit for consistency
    headModel = ft_convert_units(headModel, targetUnit);
end
