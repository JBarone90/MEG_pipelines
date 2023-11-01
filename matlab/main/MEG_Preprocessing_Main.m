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
iSubj = 21;  % Subject ID
compToRemove = [1, 7, 18, 22, 32];  % Components to remove
 
% Retrieve Participant List and Select One
[~, idList, expDateList] = readParticipantList(fullfile(dirConfig.participant_dir,'subj_list.txt'));
[selectedSubject, selectedDate] = selectSingleSubject(idList, expDateList, iSubj);

% Define Data Directories
[subjMegDir, saveDir] = defineDataDirectories(selectedSubject, selectedDate,...
    dirConfig.meg_dir, dirConfig.output_dir);

% Check for Existing Output Files
checkForExistingOutput(saveDir);

% Perform High/Low-Pass Filtering
dataPrepro = highLowPassFilter(subjMegDir, preproConfig.low_pass_freq, preproConfig.high_pass_freq);

% Perform Line Noise Reduction
dataPrepro = removeLineNoise(dataPrepro, preproConfig.line_noise_freq);

% Epoching and Downsampling
dataDownsamp = epochAndDownsample(dataPrepro, subjMegDir, preproConfig.event_type, ...
    preproConfig.event_value, preproConfig.pre_event_time, preproConfig.post_event_time, preproConfig.resample_rate);

% ICA for Artifact Rejection
if exist(fullfile(saveDir, 'ica_comp.mat'), 'file')
    load(fullfile(saveDir, 'ica_comp.mat'));
else
    comp = performICA(subjMegDir, saveDir, preproConfig.resample_rate, true);
end

% Visual Inspection of ICA Components
plotICAComponents(comp);

% Remove Bad Components and Backproject to Data
dataIcaRemoved = removeBadComponents(comp, dataDownsamp, compToRemove);

% Inspect Data Before and After ICA
inspectData(dataDownsamp, {'MLC*', 'MLF*'}, 'vertical');
inspectData(dataIcaRemoved, {'MLC*', 'MLF*'}, 'vertical');

% Semi-Automatic Artifact Rejection
[artifactJump, artifactMuscle, artifactEog] = automaticRejectionWrapper(dataIcaRemoved);

% Remove Bad Trials
dataClean = removeBadTrials(dataIcaRemoved, artifactJump, artifactMuscle, artifactEog);

% Retrieve Indices of Bad Trials
Ntrl = length(dataIcaRemoved.trial);
Fs = dataClean.fsample;
trlLength = preproConfig.pre_event_time + preproConfig.post_event_time;
badTrlIdx = get_trl_idx(Ntrl, Fs, trlLength, artifactJump, artifactMuscle, artifactEog);

% Validation: Ensure Correct Number of Bad Trials Removed
if length(badTrlIdx) ~= (length(dataIcaRemoved.trial) - length(dataClean.trial))
    error('<< Something went wrong in the automatic rejection >>');
end

% Check if the file doesn't already exist, then save
if ~exist(fullfile(saveDir, 'bad_comp_idx.mat'), 'file')
    save(fullfile(saveDir, 'bad_comp_idx.mat'), 'compToRemove');
end

if ~exist(fullfile(saveDir, 'data_clean.mat'), 'file')
    save(fullfile(saveDir, 'data_clean.mat'), 'dataClean');
end

if ~exist(fullfile(saveDir, 'bad_trl_idx.mat'), 'file')
    save(fullfile(saveDir, 'bad_trl_idx.mat'), 'bad_trl_idx');
end