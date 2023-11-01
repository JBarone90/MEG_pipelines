function dataPrepro = highLowPassFilter(subjMegDir, lowPassFreq, highPassFreq)
    % highLowPassFilter - Apply high and low pass filters to MEG data
    %
    % Syntax:
    %   dataPrepro = highLowPassFilter(subjMegDir, lowPassFreq, highPassFreq)
    %
    % Inputs:
    %   subjMegDir (string)  - Full path to the directory containing the subject's MEG data
    %   lowPassFreq  (numeric) - Low-pass filter frequency
    %   highPassFreq (numeric) - High-pass filter frequency
    %
    % Outputs:
    %   dataPrepro (struct) - Preprocessed data structure containing filtered MEG data
    %
    % Example:
    %   dataPrepro = highLowPassFilter('/path/to/meg/data', 40, 0.1)
    %
    % Note:
    %   - This function uses the FieldTrip function ft_preprocessing for filtering.
    
    % Input validation
    if ~ischar(subjMegDir) || isempty(subjMegDir) || ...
       ~isnumeric(lowPassFreq) || isempty(lowPassFreq) || ...
       ~isnumeric(highPassFreq) || isempty(highPassFreq)
        error('All input arguments should be non-empty and of the correct type.');
    end

    % Configuration for preprocessing
    cfg = [];
    cfg.dataset = subjMegDir;
    cfg.channel = {'MEG'};
    cfg.demean = 'yes';
    cfg.lpfilter = 'yes';
    cfg.hpfilter = 'yes';
    cfg.lpfreq = lowPassFreq;
    cfg.hpfreq = highPassFreq;

    % Apply preprocessing
    dataPrepro = ft_preprocessing(cfg);
end
