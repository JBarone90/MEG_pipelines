function dataDownsamp = epochAndDownsample(dataPrepro, subjMegDir, eventType, eventValue, preStim, postStim, resampleRate)
    % epochAndDownsample - Epochs and downsamples the data.
    %
    % Syntax: dataDownsamp = epochAndDownsample(dataPrepro, subjMegDir, eventType, eventValue, preStim, postStim, resampleRate)
    %
    % Inputs:
    %   dataPrepro (struct)  - The preprocessed data.
    %   subjMegDir (string)  - The directory containing the MEG dataset.
    %   eventType (string)   - Type of the event to consider for epoching.
    %   eventValue (float)   - Value of the event to consider for epoching.
    %   preStim (float)      - Time before trigger in seconds.
    %   postStim (float)     - Time after trigger in seconds.
    %   resampleRate (int)   - The rate to downsample the data to.
    %
    % Outputs:
    %   dataDownsamp (struct) - The epoched and downsampled data.
    
    % Define trials for epoching
    cfg = [];
    cfg.dataset = subjMegDir;
    cfg.trialfun = 'ft_trialfun_general'; % this is the default
    cfg.trialdef.eventtype = eventType;
    cfg.trialdef.eventvalue = eventValue;
    cfg.trialdef.prestim = preStim;
    cfg.trialdef.poststim = postStim;
    
    % Run trial definition to get configuration with trial info
    cfgTrl = ft_definetrial(cfg);
   
    % Segment the data into trials using the trial info
    dataTrl = ft_redefinetrial(cfgTrl, dataPrepro);

    % Downsample the data
    cfg = [];
    cfg.resamplefs = resampleRate;
    cfg.detrend = 'no';
    
    % Create downsampled data
    dataDownsamp = ft_resampledata(cfg, dataTrl);
end
