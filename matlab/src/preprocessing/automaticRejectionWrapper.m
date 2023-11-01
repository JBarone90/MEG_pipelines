function [artifactJump, artifactMuscle, artifactEOG] = automaticRejectionWrapper(data)
% automaticRejectionWrapper Automatically rejects artifacts using z-value
%
% Syntax:
%   [artifactJump, artifactMuscle, artifactEOG] = automaticRejectionWrapper(data)
%
% Inputs:
%   data (struct) - Preprocessed MEG data in FieldTrip structure format
%
% Outputs:
%   artifactJump (Nx2 double)  - Indices of detected jump artifacts
%   artifactMuscle (Nx2 double)- Indices of detected muscle artifacts
%   artifactEOG (Nx2 double)   - Indices of detected EOG artifacts
%
% Example:
%   [artifactJump, artifactMuscle, artifactEOG] = automaticRejectionWrapper(data);
%
% Notes:
%   - Ensure the data is preprocessed before applying this function.

    % Validate mandatory input
    if nargin < 1
        error('Input argument "data" is required.');
    end

    % Common cfg setup
    commonCfg = [];
    commonCfg.continuous = 'no';
    commonCfg.artfctdef.zvalue.trlpadding = 0;
    commonCfg.artfctdef.zvalue.fltpadding = 0;
    commonCfg.artfctdef.zvalue.interactive = 'yes';

    % Configuration and Detection of Jump Artifact
    jumpCfg = commonCfg;
    jumpCfg.artfctdef.zvalue.channel = 'MEG';
    jumpCfg.artfctdef.zvalue.cutoff = 50;
    jumpCfg.artfctdef.zvalue.artpadding = 0;
    jumpCfg.artfctdef.zvalue.cumulative = 'yes';
    jumpCfg.artfctdef.zvalue.medianfilter = 'yes';
    jumpCfg.artfctdef.zvalue.medianfiltord = 9;
    jumpCfg.artfctdef.zvalue.absdiff = 'yes';
    [~, artifactJump] = ft_artifact_zvalue(jumpCfg, data);

    % Configuration and Detection of Muscle Artifact
    muscleCfg = commonCfg;
    muscleCfg.artfctdef.zvalue.channel = {'MRT*', 'MLT*'};
    muscleCfg.artfctdef.zvalue.cutoff = 8;
    muscleCfg.artfctdef.zvalue.artpadding = 0.1;
    muscleCfg = setAlgorithmicParams(muscleCfg, 'yes', [110 140], 9, 'yes', 0.2);
    [~, artifactMuscle] = ft_artifact_zvalue(muscleCfg, data);

    % Configuration and Detection of EOG Artifact
    EOGCfg = commonCfg;
    EOGCfg.artfctdef.zvalue.channel = {'MLF*', 'MRF*'};
    EOGCfg.artfctdef.zvalue.cutoff = 30;
    EOGCfg.artfctdef.zvalue.artpadding = 0.1;
    EOGCfg = setAlgorithmicParams(EOGCfg, 'yes', [2 15], 4, 'yes');
    [~, artifactEOG] = ft_artifact_zvalue(EOGCfg, data);
end

function cfg = setAlgorithmicParams(cfg, bpfilter, bpfreq, bpfiltord, hilbert, boxcar)
% setAlgorithmicParams Set parameters for artifact detection algorithms
%
% Inputs:
%   cfg       - Current configuration
%   bpfilter  - Bandpass filter flag ('yes' or 'no')
%   bpfreq    - Bandpass filter frequency range
%   bpfiltord - Bandpass filter order
%   hilbert   - Hilbert transform flag ('yes' or 'no')
%   boxcar    - Boxcar smoothing window length (in seconds)
%
% Outputs:
%   cfg - Updated configuration
%
    cfg.artfctdef.zvalue.bpfilter = bpfilter;
    cfg.artfctdef.zvalue.bpfreq = bpfreq;
    cfg.artfctdef.zvalue.bpfiltord = bpfiltord;
    cfg.artfctdef.zvalue.hilbert = hilbert;
    if exist('boxcar', 'var')
        cfg.artfctdef.zvalue.boxcar = boxcar;
    end
end
  