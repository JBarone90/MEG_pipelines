
function dataPrepro = removeLineNoise(dataPrepro, fLine)
    % removeLineNoise Removes line noise using spectral interpolation.
    %
    % Syntax: dataPrepro = removeLineNoise(dataPrepro, fLine)
    %
    % Inputs:
    %   dataPrepro (struct) - Preprocessed data structure
    %   fLine      (array)  - Array of frequencies to be removed
    %
    % Outputs:
    %   dataPrepro (struct) - Data structure with line noise removed
    %
    % Example:
    %   dataPrepro = removeLineNoise(dataPrepro, [50, 100, 150]);
    %
    % Notes:
    %   - This function uses the FieldTrip function ft_preproc_dftfilter for line noise removal.
    
    % Input validation
    if ~isstruct(dataPrepro) || isempty(dataPrepro) || ...
       ~isnumeric(fLine) || isempty(fLine)
        error('All input arguments should be non-empty and of the correct type.');
    end
    
    % Perform line noise reduction using spectral interpolation
    [filtered] = ft_preproc_dftfilter(dataPrepro.trial{1}, dataPrepro.fsample, ...
                                      fLine,'dftreplace', 'neighbour', ...
                                      'dftbandwidth', ones(1,length(fLine)), ...
                                      'dftneighbourwidth', ones(1,length(fLine)) + 1);
                                  
    % Substitute the filtered matrix back into the data structure
    dataPrepro.trial{1} = filtered;
end
