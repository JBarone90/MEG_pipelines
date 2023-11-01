% inspectData - Inspects MEG/EEG data using FieldTrip's ft_databrowser.
%
% Syntax: inspectData(data, channel, viewmode)
%
% Inputs:
%   data (struct)     - The FieldTrip data structure.
%   channel (string)  - Specifies which channels to display. Default is 'all'.
%   viewmode (string) - Specifies the viewing mode. Default is 'vertical'.
%
% Outputs:
%   None. Opens an interactive data browser.
%
% Example:
%   inspectData(dataPrepro, 'MEG', 'vertical');
%
% Notes:
%   - The function provides a wrapper around FieldTrip's ft_databrowser for easier data inspection.

function inspectData(data, channel, viewmode)
    % Check if mandatory 'data' argument is provided
    if nargin < 1 || isempty(data)
        error('The "data" structure must be provided.');
    end

    % Set default values if not provided
    if nargin < 2 || isempty(channel)
        channel = 'all';
    end
    if nargin < 3 || isempty(viewmode)
        viewmode = 'vertical';
    end

    % Validation for 'channel' and 'viewmode'
    if ~ischar(channel) || ~ischar(viewmode)
        error('"channel" and "viewmode" should be strings.');
    end
    
    % Configure databrowser settings
    cfg = [];
    cfg.channel = channel;
    cfg.viewmode = viewmode;
    
    % Open the databrowser
    ft_databrowser(cfg, data);
end
