function [selectedSubject, selectedDate] = selectSingleSubject(subjectIDs, experimentDates, subjectIndex)
    % selectSingleSubject - Selects a single subject's information based on index from a list of subject IDs and dates.
    %
    % Syntax: [selectedSubject, selectedDate] = selectSingleSubject(subjectIDs, experimentDates, subjectIndex)
    %
    % Inputs:
    %   subjectIDs (cell array or numeric array)        - A list of subject IDs.
    %   experimentDates (cell array or numeric array)   - A list of dates.
    %   subjectIndex (integer)                          - The index of the subject to be selected.
    %
    % Outputs:
    %   selectedSubject (string) - The ID of the selected subject, converted to a string.
    %   selectedDate (string)    - The date of the selected subject's data, converted to a string.
    %
    % Example:
    %   [selectedSubject, selectedDate] = selectSingleSubject({'s1','s2','s3'}, {'2021-01-01','2021-01-02','2021-01-03'}, 2);
    %   This will return selectedSubject = 's2' and selectedDate = '2021-01-02'.
    
    % Input validation
    if ~isnumeric(subjectIndex) || subjectIndex <= 0 || subjectIndex > length(subjectIDs)
        error('Invalid subject index. It should be a positive integer within the range of the subject list.');
    end
    
    % Convert subjectIDs and experimentDates to cell arrays if they are not already.
    if ~iscell(subjectIDs)
        subjectIDs = num2cell(subjectIDs);
    end
    if ~iscell(experimentDates)
        experimentDates = num2cell(experimentDates);
    end
    
    % Convert the selected subject's ID and date to string format.
    selectedSubject = num2str(subjectIDs{subjectIndex});
    selectedDate = num2str(experimentDates{subjectIndex});
end
