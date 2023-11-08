% MEG Preprocessing Pipeline for CTF Data
% ---------------------------------------
% This script provides a semi-automated preprocessing pipeline for MEG CTF data.
% IMPORTANT: Do not run the entire script at once. Some steps require manual inspection 
% and decision-making by the researcher.
% Manual steps include:
%   1. Setting the subject ID (isubj)
%   2. Specifying ICA components to remove (compToRemove)
%   3. Semi-interactive trial selection using ft_artifact_zvalue


% Add Custom Functions to Path
addpath('./matlab/src/utilities');
addpath('./matlab/src/preprocessing');
addpath('./matlab/src/visualisation');

% Load Configuration Files
preproConfig = readJsonFile(fullfile('./config', 'preprocessing.json'));
dirConfig = readJsonFile(fullfile('./config', 'directories.json'));

% Initialize FieldTrip
setupFieldTrip(dirConfig.fieldtrip_dir);

% Hard-Coded Variables
subjectIndex = 21;  % Subject ID
badComponentsIdx = [1, 7, 18, 22, 32];  % Components to remove
 
% Retrieve Participant List and Select One
[~, idList, expDateList, expIDList] = readParticipantList(fullfile(dirConfig.participant_dir,'subj_list.txt'));
[selectedSubject, selectedDate] = selectSingleSubject(idList,...
    expDateList, expIDList, subjectIndex);

% Define MEG Data Directory
subjMegDir = fullfile(dirConfig.meg_dir, selectedDate);
megFileName = sprintf(dirConfig.meg_file_pattern,...
    selectedSubject, selectedDate);
subjMegFile = fullfile(subjMegDir, megFileName);

% Define Output Directory
saveDir = fullfile(dirConfig.output_dir,...
    selectedSubject, 'ai', 'dataPrepro');

% Make sure Output Directory Exist
ensurePathExists(saveDir, true) 

% Perform High/Low-Pass Filtering
preprocessedData = highLowPassFilter(subjMegFile,...
    preproConfig.low_pass_freq, preproConfig.high_pass_freq);

% Perform Line Noise Reduction
preprocessedData = removeLineNoise(preprocessedData,...
    preproConfig.line_noise_freq);

% Epoching and Downsampling
downsampledData = epochAndDownsample(preprocessedData,...
    subjMegFile, preproConfig.event_type, ...
    preproConfig.event_value, preproConfig.pre_event_time,...
    preproConfig.post_event_time, preproConfig.resample_rate);

% ICA for Artifact Rejection
fileExists =  findAndCheckFile(saveDir,'icaComponents.mat');
if fileExists
    load(fullfile(saveDir, 'icaComponents.mat'));
else
    comp = runICA(subjMegFile, saveDir, preproConfig.resample_rate, true);
end

% Visual Inspection of ICA Components
plotICAComponents(comp);

% Remove Bad Components and Backproject to Data
dataIcaRemoved = removeBadComponents(comp, downsampledData, badComponentsIdx);

% Inspect Data Before and After ICA
inspectData(downsampledData, {'MLC*', 'MLF*'}, 'vertical');
inspectData(dataIcaRemoved, {'MLC*', 'MLF*'}, 'vertical');

% Semi-Automatic Artifact Rejection
[artifactJump, artifactMuscle, artifactEog] = automaticRejectionWrapper(dataIcaRemoved);

% Remove Bad Trials
cleanedData = removeBadTrials(dataIcaRemoved,...
    artifactJump, artifactMuscle, artifactEog);

% Retrieve Indices of Bad Trials
Ntrl = length(dataIcaRemoved.trial);
Fs = cleanedData.fsample;
trlLength = preproConfig.pre_event_time + preproConfig.post_event_time;
badTrlIdx = get_trl_idx(Ntrl, Fs, trlLength, artifactJump, artifactMuscle, artifactEog);

% Validation: Ensure Correct Number of Bad Trials Removed
if length(badTrlIdx) ~= (length(dataIcaRemoved.trial) - length(cleanedData.trial))
    error('<< Something went wrong in the automatic rejection >>');
end

% Save the bad components indices
fileExists =  findAndCheckFile(saveDir, 'badComponentsIdx.mat');
if ~fileExists
    save(fullfile(saveDir, 'badComponentsIdx.mat'), 'badComponentsIdx');
end

% Save the cleaned data
fileExists =  findAndCheckFile(saveDir, 'cleanedData.mat');
if ~fileExists
    save(fullfile(saveDir, 'cleanedData.mat'), 'cleanedData', '-v7.3');
end

% Save the bad trial indices
fileExists =  findAndCheckFile(saveDir, 'badTrialIdx.mat');
if ~fileExists
    save(fullfile(saveDir, 'badTrialIdx.mat'), 'badTrlIdx');
end