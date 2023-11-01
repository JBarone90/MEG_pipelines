% plotICAComponents - Plots the ICA components for visual inspection.
% This function generates topographical plots and a data browser view for ICA components.
%
% Syntax: plotICAComponents(comp, numComponents, layoutFile)
%
% Inputs:
%   comp (struct)         - The ICA components.
%   numComponents (array) - Array specifying the components to plot. Default is 1:40.
%   layoutFile (string)   - Layout file for plotting. Default is 'CTF151.lay'.
%
% Outputs:
%   None. Generates plots of the ICA components.
%
% Example:
%   plotICAComponents(comp, 1:20, 'CTF151.lay');
%
% Notes:
%   - Use the following filter settings in the interactive interpreter for specific artifacts:
%     - EOG: cfg.preproc.bpfreq = [1.5 15];
%     - ECG: cfg.preproc.bpfreq = [10 40];
%     - Muscle activity: cfg.preproc.bpfreq = [40 140]; 

function plotICAComponents(comp, numComponents, layoutFile)
    % Check if the comp structure is provided
    if nargin < 1
        error('The comp structure must be provided.');
    end
    
    % Set default values if not provided
    if nargin < 2
        numComponents = 1:40;
    end
    if nargin < 3
        layoutFile = 'CTF151.lay';
    end
    
    % Topographical Plot
    cfg                     = [];
    cfg.component           = numComponents; % specify the component(s) that should be plotted
    cfg.layout              = layoutFile;    % specify the layout file
    cfg.comment             = 'no';
    ft_topoplotIC(cfg, comp);
    
    % Data Browser View
    cfg                     = [];
    cfg.blocksize           = 20;
    cfg.layout              = layoutFile;    
    cfg.viewmode            = 'component';
    ft_databrowser(cfg, comp);
end
