% removeBadTrials - Removes trials containing artifacts from the data.
%
% Syntax: dataClean = removeBadTrials(data, artifactJump, artifactMuscle, artifactEog)
%
% Inputs:
%   data (struct)         - The FieldTrip data structure.
%   artifactJump (array)  - Jump artifact matrix. Default is [].
%   artifactMuscle (array)- Muscle artifact matrix. Default is [].
%   artifactEog (array)   - EOG artifact matrix. Default is [].
%
% Outputs:
%   dataClean (struct)    - Data with bad trials removed.
%
% Example:
%   dataClean = removeBadTrials(data, artifactJump, artifactMuscle, artifactEog);
%
% Notes:
%   - The function provides an interface for FieldTrip's ft_rejectartifact.

function dataClean = removeBadTrials(data, artifactJump, artifactMuscle, artifactEog)
    % Check if mandatory 'data' argument is provided
    if nargin < 1 || isempty(data)
        error('The "data" structure must be provided.');
    end
    
    % Set default values if not provided
    if nargin < 2 || isempty(artifactJump)
        artifactJump = [];
    end
    if nargin < 3 || isempty(artifactMuscle)
        artifactMuscle = [];
    end
    if nargin < 4 || isempty(artifactEog)
        artifactEog = [];
    end

    % Configure artifact rejection settings
    cfg = [];
    cfg.artfctdef.reject = 'complete';
    cfg.artfctdef.eog.artifact = artifactEog;
    cfg.artfctdef.jump.artifact = artifactJump;
    cfg.artfctdef.muscle.artifact = artifactMuscle;
    
    % Perform artifact rejection
    dataClean = ft_rejectartifact(cfg, data);
end
