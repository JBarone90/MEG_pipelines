function data = readJsonFile(filePath)
    % Check if the file exists
    if ~exist(filePath, 'file')
        error('File not found.');
    end
    
    % Open the file
    fid = fopen(filePath, 'r');
    
    % Check if the file was opened successfully
    if fid == -1
        error('Could not open the file.');
    end
    
    % Read the file data
    rawData = fread(fid, inf, '*char');
    
    % Close the file
    fclose(fid);
    
    % Convert the char array to a character vector
    jsonString = char(rawData');
    
    % Decode the JSON string
    data = jsondecode(jsonString);
end
