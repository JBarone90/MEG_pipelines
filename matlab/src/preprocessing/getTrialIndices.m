function badTrialIdx = getTrialIndices(numTrials, samplingFreq, trialLength, artifactJump, artifactMuscle, artifactEog)
    % Function to get the indices of bad trials removed by ft_rejectartifact.
    %
    % Parameters:
    %   - numTrials: Number of trials
    %   - samplingFreq: Sampling frequency
    %   - trialLength: Length of a trial
    %   - artifactJump: Time stamps of jump artifacts
    %   - artifactMuscle: Time stamps of muscle artifacts
    %   - artifactEog: Time stamps of EOG artifacts
    %
    % Returns:
    %   - badTrialIdx: Indices of bad trials

    % Initialize an empty array to hold bad trials
    badTrials = [];

    % Helper function to add bad trials for a specific artifact type
    function addBadTrials(artifactTimes)
        % Skip if no artifacts are present
        if isempty(artifactTimes)
            return;
        end
        % Convert artifact times to match the sampling frequency
        artifactTimes = round(artifactTimes / samplingFreq, 2);
        % Initialize an empty array to store trial masks
        trialMask = [];
        
        % Check for artifacts that span multiple consecutive trials
        if any(diff(artifactTimes') > trialLength)
            % Split those artifacts into separate trials
            trialMask = splitTrials(artifactTimes, trialLength);
        end
        % Concatenate new and existing bad trials
        newBadTrials = [artifactTimes(~(diff(artifactTimes') > trialLength), :); trialMask];
        badTrials = [badTrials; newBadTrials];
    end

    % Identify bad trials for each artifact type
    addBadTrials(artifactJump);
    addBadTrials(artifactMuscle);
    addBadTrials(artifactEog);

    % Remove duplicates from the bad trials list
    badTrials = unique(badTrials, 'rows');

    % Generate the time list for all trials
    trialTimes = 0:trialLength:trialLength * numTrials - trialLength;
    % Create intervals for each trial
    trialIntervals = [trialTimes', trialTimes' + trialLength];
    
    % Identify the indices of the trials that match the bad trials
    [~, badTrialIdx] = intersect(trialIntervals, badTrials, 'rows');
end

% Sub-function to split consecutive trials into separate trials
function trialMask = splitTrials(artifactTimes, trialLength)
    % Initialize an empty array for storing split trials
    trialMask = [];
    
    % Find artifacts that last longer than one trial
    longArtifacts = artifactTimes(diff(artifactTimes') > trialLength, :);
    % Calculate the number of consecutive trials for each instance
    numConsecutiveTrials = diff(longArtifacts') / trialLength;
    
    % Loop through each set of long artifacts
    for idx = 1:length(numConsecutiveTrials)
        % Generate a list of bad trials by splitting the consecutive trials
        consecutiveTrials = zeros(numConsecutiveTrials(idx), 1) + (0:trialLength:trialLength * (numConsecutiveTrials(idx) - 1))';
        consecutiveTrials = [consecutiveTrials, consecutiveTrials + trialLength];
        % Offset by the start time of the original long artifact
        consecutiveTrials = consecutiveTrials + longArtifacts(idx, 1);
        % Add these new trials to the mask
        trialMask = [trialMask; consecutiveTrials];
    end
end
