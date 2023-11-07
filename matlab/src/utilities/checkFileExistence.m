function fileExists = checkFileExistence(filePath)
%CHECKFILEEXISTENCE Check if a specified file exists in the directory.
%
% Syntax:
%   fileExists = checkFileExistence(filePath)
%
% Inputs:
%   filePath (string) - The full path to the file to check for existence.
%
% Outputs:
%   fileExists (logical) - A boolean value indicating the existence of the file.
%
% Example:
%   fileExists = checkFileExistence('/path/to/file.ext')
%
% Notes:
%   The function will return true if the file exists, and false otherwise. It will also
%   print a message indicating the result.

    % Initialize return variable
    fileExists = false;

    % Check if the file exists
    if exist(filePath, 'file') == 2
        fprintf('The file "%s" exists.\n', filePath);
        fileExists = true;
    else
        fprintf('The file "%s" does not exist.\n', filePath);
    end
end
