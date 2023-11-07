function forwardModel = generateForwardModel(cfg)
%GENERATEFORWARDMODEL Generates a forward model for MEG data analysis.
%
% This function generates a forward model structure that includes co-registered
% MRI, a head model, a template source model, a warped source model, gradiometers,
% and leadfields.
%
% Inputs:
%   - cfg: A struct with configurations for generating the forward model. 
%          Required fields are 'mriPath' and 'megPath'. Optional fields are 
%          'polhemus' (default: []), 'sourcemodel' (default: 'standard_sourcemodel3d4mm.mat'), 
%          'normMethod' (default: 'old'), and 'plot' (default: 'no').
%
% Outputs:
%   - forwardModel: A struct containing the generated forward model components,
%                    including MRI, head model (hdm), gradiometers (grad), warped
%                    source model, and leadfield matrices.

    % Check for mandatory fields
    mandatoryFields = {'mriPath', 'megPath'};
    for iField = 1:length(mandatoryFields)
        field = mandatoryFields{iField};
        if ~isfield(cfg, field) || isempty(cfg.(field))
            error('generateForwardModel:MissingField', ...
                  'The mandatory field "%s" is missing or empty.', field);
        end
    end
    
    % Initialize optional fields with default values
    cfg = setDefaultField(cfg, 'sourcemodel', 'standard_sourcemodel3d4mm.mat');
    cfg = setDefaultField(cfg, 'polhemus', []);
    cfg = setDefaultField(cfg, 'normMethod', 'old');
    cfg = setDefaultField(cfg, 'plot', 'no');
    
    % Load Polhemus shape, Gradiometers, and Template Sourcemodel
    dataComponents = loadDataComponents(cfg, 'cm');
    
    % Load MRI and Co-Register
    mriData = loadAndAlignMRI(cfg.mriPath, dataComponents.headshape, 'cm', true);
    
    % Segment MRI and Create Head Model
    [mriSegmented, hdm] = createHeadModel(mriData.mriCoreg, 'cm');
    
    % Warp Source Model
    sourceModel = warpSourceModel(mriData.mriCoreg,...
        dataComponents.templateSourcemodel, hdm, cfg.normMethod, 'cm');
    
    % Compute Leadfield
    leadField = computeLeadfield(dataComponents.grad, sourceModel, hdm);
    
    % Store Results in Struct
    forwardModel.mri = mriData.mriCoreg;
    forwardModel.hdm = hdm;
    forwardModel.grad = dataComponents.grad;
    forwardModel.sourceModel = sourceModel;
    forwardModel.templateSourcemodel = dataComponents.templateSourcemodel;
    forwardModel.leadField = leadField;

    % Optional: Check Co-registration Quality
    if strcmp(cfg.plot, 'yes')
        checkCoregistrationQuality(dataComponents.grad, ...
            dataComponents.headshape, mriData.mriCoreg, ...
            mriSegmented, hdm, 'cm');
    end
end

function cfg = setDefaultField(cfg, fieldName, defaultValue)
%SETDEFAULTFIELD Helper function to set default values for missing fields.
%
% This function checks if the specified field is present and not empty
% in the configuration struct, and if not, sets it to the default value.
%
% Inputs:
%   - cfg: Configuration struct.
%   - fieldName: Name of the field to check and set.
%   - defaultValue: Default value to assign if the field is not set.
%
% Outputs:
%   - cfg: Updated configuration struct with the default values set.

    if ~isfield(cfg, fieldName) || isempty(cfg.(fieldName))
        cfg.(fieldName) = defaultValue;
    end
end
