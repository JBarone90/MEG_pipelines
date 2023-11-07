% MEG Forward Model Pipeline
% ---------------------------------------
% This script generates a forward model for a single subject. It will
% co-register MRI, create head models, gradiometers, source models, and
% template source models.
% Make sure to set the 'subjectIndex' to choose the subject for the forward model.
%
% Output: The forward model is saved to the specified directory.

% Add Custom Functions to Path
addpath('./matlab/src/utilities');
addpath('./matlab/src/forward_model');

% Load Configuration Files
dirConfig = readJsonFile(fullfile('./config', 'directories.json'));

% Initialize FieldTrip
setupFieldTrip(dirConfig.fieldtrip_dir);

% Hard-Coded Variables
subjectIndex = 21;  % Subject ID

% Retrieve Participant List and Select One
[~, idList, expDateList, expIDList] = readParticipantList(fullfile(dirConfig.participant_dir,'subj_list.txt'));
[selectedSubject, selectedDate] = selectSingleSubject(idList, expDateList, expIDList, subjectIndex);

% Define MEG Data Directory
subjMegDir = fullfile(dirConfig.meg_dir, selectedDate);
megFileName = sprintf(dirConfig.meg_file_pattern,...
    selectedSubject, selectedDate);
subjMegFile = fullfile(subjMegDir, megFileName);

% Define Output Directory
saveDir = fullfile(dirConfig.output_dir,...
    selectedSubject, 'forwardModel');
ensurePathExist(saveDir, true) 

% Check for Existence of Polhemus Heashape 
polhemus = findFile(subjMegDir, '*.pos');

% Forward Model
cfg               = [];
cfg.polhemus      = polhemus;
cfg.mriPath       = fullfile(dirConfig.mri_dir, selectedSubject,'T1w.nii');%MRI file
cfg.megPath       = subjMegFile;%gradiometers 
cfg.plot          = 'yes';%visually inspect co-registration
cfg.normMethod    = 'old';%select the normalisation method when warping the MR 
forwardModel      = generateForwardModel(cfg);

% Save files
save(fullfile(saveDir,'forwardModel.mat'),'forwardModel');
