function [subjMegDir, saveDir] = defineDataDirectories(subject, date, megBaseDir, outBaseDir)
    % defineDataDirectories - Set up directory paths for subject's MEG data and output
    %
    % Syntax:
    %   [subjMegDir, saveDir] = defineDataDirectories(subject, date, megBaseDir, outBaseDir)
    %
    % Inputs:
    %   subject    (string) - Subject ID
    %   date       (string) - Date when the MEG data was collected
    %   megBaseDir (string) - Base directory where MEG data is stored
    %   outBaseDir (string) - Base directory where output should be saved
    %
    % Outputs:
    %   subjMegDir (string) - Full path to the directory containing the subject's MEG data
    %   saveDir    (string) - Full path to the directory where the outputs should be saved
    %
    % Example:
    %   [subjMegDir, saveDir] = defineDataDirectories('subj01', '2023-04-10', '/path/to/meg', '/path/to/output')
    
    % Input validation
    if ~ischar(subject) || isempty(subject) || ~ischar(date) || isempty(date) || ...
       ~ischar(megBaseDir) || isempty(megBaseDir) || ~ischar(outBaseDir) || isempty(outBaseDir)
        error('All input arguments should be non-empty strings.');
    end

    % Define the directory for the MEG data
    subjMegFileName = [subject, '_Motor_', date, '_AI.ds'];
    subjMegDir = fullfile(megBaseDir, date, subjMegFileName);

    % Check if the MEG directory exists
    if ~exist(subjMegDir, 'dir')
        error(['MEG directory not found: ', subjMegDir, '. Please ensure the path is correct.']);
    end

    % Define the output directory
    outDir = fullfile(outBaseDir, subject);

    % Create the output directory if it does not exist
    if ~exist(outDir, 'dir')
        mkdir(outDir);
        disp(['Output directory created: ', outDir]);
    end

    % Define the directory to save the data
    saveDir = fullfile(outDir, 'ai', 'prepro_data');

    % Create the save directory if it does not exist
    if ~exist(saveDir, 'dir')
        mkdir(saveDir);
        disp(['Save directory created: ', saveDir]);
    end
end

