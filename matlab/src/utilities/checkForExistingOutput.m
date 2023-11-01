function checkForExistingOutput(saveDir)
% checkForExistingOutput Check if the output files already exist
%
% Syntax:
%   checkForExistingOutput(saveDir)
%
% Inputs:
%   saveDir (string) - The directory where the output files are expected to be saved
%
% Outputs:
%   None. Throws an error if output files already exist.
%
% Example:
%   checkForExistingOutput('/path/to/saveDir')
%
% Notes:
%   The function will terminate the script if it finds that the output file 'data_clean.mat' already exists in the specified directory.

    % Check if the output file 'data_clean.mat' already exists in the save directory
    existingFiles = dir(saveDir);
    if any(strcmp('data_clean.mat', {existingFiles.name}))
        error('Output file "data_clean.mat" already exists in the specified directory.');
    end
end

