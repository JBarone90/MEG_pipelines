function [comp] = performICA(subjMegDir, subjCleanDir, resampleRate, shouldSave)
    % performICA - Conducts Independent Component Analysis (ICA) on MEG data.
    % Syntax: [comp] = performICA(subjMegDir, subjCleanDir, shouldSave, resampleRate)
    %
    % Inputs:
    %   subjMegDir (string)  - Directory containing the MEG dataset.
    %   subjCleanDir (string)- Directory where clean data should be saved.
    %   resampleRate (int)   - The rate to downsample the data to.
    %   shouldSave (boolean) - Flag to indicate whether to save the components.
    %
    % Outputs:
    %   comp (struct)        - Computed ICA components.

    % Set default values if not provided
    if nargin < 4
        shouldSave = false;
    end

    % Preprocess data for ICA
    cfg = [];
    cfg.dataset = subjMegDir;
    cfg.channel = {'MEG'};
    cfg.demean = 'yes';
    cfg.lpfilter = 'yes';
    cfg.hpfilter = 'yes';
    cfg.lpfreq = 100;
    cfg.hpfreq = 1;
    dataPreproIca = ft_preprocessing(cfg);

    % Downsample data for ICA
    cfg = [];
    cfg.resamplefs = resampleRate;
    cfg.detrend = 'no';
    dataDownsampIca = ft_resampledata(cfg, dataPreproIca);

    % Perform ICA on downsampled data
    cfg = [];
    cfg.channel = 'MEG';
    cfg.method = 'runica';
    comp = ft_componentanalysis(cfg, dataDownsampIca);

    % Optionally save ICA components
    if shouldSave
        save(fullfile(subjCleanDir, 'icaComp.mat'), 'comp');
    end
end
