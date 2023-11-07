function filePath = findFile(fileDir, fileNamePattern)
    %FINDFILE Searches for a file with a given name pattern in a directory.
    % If a file is found, it returns the full path, otherwise, it returns empty.
    %
    % Parameters:
    %   fileDir - The directory to search in.
    %   fileNamePattern - The pattern of the file name to search for,
    %                     which can include wildcards, e.g., '*.txt', 'file_*'.
    %
    % Returns:
    %   filePath - The full path to the found file or empty if not found.

    files = dir(fullfile(fileDir, fileNamePattern));
    if ~isempty(files)
        filePath = fullfile(files(1).folder, files(1).name);
    else
        filePath = [];
    end
end
