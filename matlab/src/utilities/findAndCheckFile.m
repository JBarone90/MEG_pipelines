function [fileExists, filePath] = findAndCheckFile(fileDir, fileNamePattern)
    %FINDANDCHECKFILE Searches for a file with a given name pattern and checks existence.
    %
    % Parameters:
    %   fileDir - The directory to search in.
    %   fileNamePattern - The pattern of the file name to search for.
    %
    % Returns:
    %   fileExists - A boolean flag indicating the existence of the file.
    %   filePath - The full path to the found file or empty if not found.

    files = dir(fullfile(fileDir, fileNamePattern));
    fileExists = ~isempty(files);
    if fileExists
        filePath = fullfile(files(1).folder, files(1).name);
        fprintf('The file "%s" exists.\n', filePath);
    else
        filePath = [];
        fprintf('No file matching "%s" exists in "%s".\n', fileNamePattern, fileDir);
    end
end
