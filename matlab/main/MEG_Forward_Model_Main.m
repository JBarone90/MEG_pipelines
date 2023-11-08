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
[selectedSubject, selectedDate] = selectSingleSubject(idList,...
    expDateList, expIDList, subjectIndex);

% Define MEG and MRI Data Directory
subjMegDir = fullfile(dirConfig.meg_dir, selectedDate);
megFileName = sprintf(dirConfig.meg_file_pattern,...
    selectedSubject, selectedDate);
subjMegFile = fullfile(subjMegDir, megFileName);
subjMriDir = fullfile(dirConfig.mri_dir, selectedSubject);

% Define Output Directory
saveDir = fullfile(dirConfig.output_dir,...
    selectedSubject, 'forwardModel');

% Make sure Output Directory Exist
ensurePathExists(saveDir, true) 

% Check for Existence of Participant MRI 
[fileExists, filePath] =  findAndCheckFile(subjMriDir, 'T1w.nii');
if fileExists
    mriPath = filePath;
else
    mriPath = fullfile(dirConfig.fieldtrip_dir,...
        'template','headmodel','standard_mri.mat');%uses a template MRI
end

% Check for Existence of Polhemus Heashape 
[~, polhemus] =  findAndCheckFile(subjMegDir, '*.pos');

% Forward Model
cfg               = [];
cfg.polhemus      = polhemus;
cfg.mriPath       = mriPath;%MRI file
cfg.megPath       = subjMegFile;%gradiometers 
cfg.plot          = 'yes';%visually inspect co-registration
cfg.normMethod    = 'old';%select the normalisation method when warping the MR (old; new)
forwardModel      = generateForwardModel(cfg);

% Save the forward model
fileExists =  findAndCheckFile(saveDir, 'forwardModel.mat');
if ~fileExists
   save(fullfile(saveDir, 'forwardModel.mat'),'forwardModel'); 
end
