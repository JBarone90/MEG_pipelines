function [selectedSubject, selectedDate, selectedExpID] = selectSingleSubject(subjectIDs, experimentDates, experimentID, subjectIndex)
    % selectSingleSubject - Selects a single subject's information based on index from a list of subject IDs and dates.
    %
    % Syntax: [selectedSubject, selectedDate, selectedExpID] = selectSingleSubject(subjectIDs, experimentDates, experimentID, subjectIndex)
    %
    % Inputs:
    %   subjectIDs (cell array or numeric array)        - A list of subject IDs.
    %   experimentDates (cell array or numeric array)   - A list of dates.
    %   experimentID (cell array or numeric array)      - A list of experiment IDs.
    %   subjectIndex (integer)                          - The index of the subject to be selected.
    %
    % Outputs:
    %   selectedSubject (string) - The ID of the selected subject, converted to a string.
    %   selectedDate (string)    - The date of the selected subject's data, converted to a string.
    %   selectedExpID (string)   - The experiment ID of the selected subject's data, converted to a string.
    %
    % Example:
    %   [selectedSubject, selectedDate, selectedExpID] = selectSingleSubject({'s1','s2','s3'}, {'2021-01-01','2021-01-02','2021-01-03'}, {'E1', 'E2', 'E3'}, 2);
    %   This will return selectedSubject = 's2', selectedDate = '2021-01-02', and selectedExpID = 'E2'.
    
    % Input validation
    if ~isnumeric(subjectIndex) || subjectIndex <= 0 || subjectIndex > length(subjectIDs)
        error('Invalid subject index. It should be a positive integer within the range of the subject list.');
    end
    
    if length(subjectIDs) ~= length(experimentDates) || length(subjectIDs) ~= length(experimentID)
        error('Length of subjectIDs, experimentDates, and experimentID must be the same.');
    end
    
    % Convert subjectIDs, experimentDates, and experimentID to cell arrays if they are not already.
    if ~iscell(subjectIDs)
        subjectIDs = num2cell(subjectIDs);
    end
    if ~iscell(experimentDates)
        experimentDates = num2cell(experimentDates);
    end
    if ~iscell(experimentID)
        experimentID = num2cell(experimentID);
    end
    
    % Convert the selected subject's ID, date, and experiment ID to string format.
    selectedSubject = num2str(subjectIDs{subjectIndex});
    selectedDate = num2str(experimentDates{subjectIndex});
    selectedExpID = num2str(experimentID{subjectIndex});
end
