function ensurePathExists(targetPath, saveFlag)
    % ensurePathExists Checks if a path exists and optionally creates it.
    %
    % This function checks the existence of a given directory path. If the path
    % does not exist and the optional save flag is true (default is false), the
    % function will create the path along with all necessary intermediate
    % directories.
    %
    % Inputs:
    %   targetPath - A string representing the directory path to check/create.
    %   saveFlag   - (Optional) A boolean flag determining whether to create the
    %                path if it does not exist. Default is false.
    %
    % Example usage:
    %   ensurePathExists('C:/my/folder/structure', true);
    %   ensurePathExists('C:/my/folder/structure'); % saveFlag is false by default

    % Set default value for saveFlag if not provided
    if nargin < 2
        saveFlag = false;
    end

    % Check if the provided path exists
    if ~exist(targetPath, 'dir')
        fprintf('The path %s does not exist.\n', targetPath);

        % If the save flag is true, create the path
        if saveFlag
            fprintf('Creating the path %s...\n', targetPath);
            mkdir(targetPath); % This function will recursively create all the required folders
            fprintf('Path created successfully.\n');
        end
    else
        fprintf('The path %s already exists.\n', targetPath);
    end
end
