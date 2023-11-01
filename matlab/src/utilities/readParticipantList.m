function [subjectTable, idList, expDateList, expIDList] = readParticipantList(filePath)
    % readParticipantList - Reads a text file containing participant information.
    %
    % Syntax: [subjectTable, idList, expDateList, expIDList] = readParticipantList(filePath)
    %
    % Inputs:
    %   filePath (string) - Path to the text file containing participant information.
    %
    % Outputs:
    %   subjectTable (table)  - The full table containing all subject information.
    %   idList (cell array)   - List of participant IDs.
    %   expDateList (cell array) - List of experiment dates.
    %   expIDList (cell array)   - List of experiment IDs.
    %
    % Example:
    %   [subjectTable, idList, expDateList, expIDList] = readParticipantList('path/to/file.csv');
    %
    % Notes:
    %   - Make sure the file exists and is formatted correctly.
    
    % Check for the existence of the file
    if ~exist(filePath, 'file')
        error('File does not exist. Please provide a valid file path.');
    end
    
    % Read the table
    subjectTable = readtable(filePath);
    
    % Extract necessary columns
    idList = subjectTable.ID;
    expDateList = subjectTable.date;
    expIDList = subjectTable.exp_ID;
end
