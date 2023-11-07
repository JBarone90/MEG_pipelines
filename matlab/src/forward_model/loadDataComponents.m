function dataComponents = loadDataComponents(cfg, targetUnit)
    % LoadDataComponents loads necessary data components: Polhemus shape,
    % Gradiometers, and Template Sourcemodel.
    %
    % Input:
    %   cfg: A configuration struct with required fields:
    %       - polhemus: File path to the Polhemus data (can be empty)
    %       - megPath: File path to the MEG data
    %       - sourcemodel: File path to the sourcemodel
    %   targetUnit: A string specifying the unit ('cm' or 'mm')
    %
    % Output:
    %   dataComponents: A struct containing loaded elements:
    %       - headshape: Polhemus headshape (if available)
    %       - grad: Gradiometers
    %       - templateSourcemodel: Template Sourcemodel

    % Initialize an empty struct to hold data components
    dataComponents = struct();

    % Check if the unit parameter is provided; if not, set it to 'cm' as default
    if nargin < 2
        targetUnit = 'cm';
    end

    % Load Polhemus shape if available
    if ~isempty(cfg.polhemus)
        dataComponents.headshape = ft_read_headshape(cfg.polhemus);
        dataComponents.headshape = ft_convert_units(dataComponents.headshape, targetUnit);
    else
        dataComponents.headshape = [];
    end

    % Load Gradiometers
    hdr = ft_read_header(cfg.megPath);
    dataComponents.grad = hdr.grad;
    dataComponents.grad = ft_convert_units(dataComponents.grad, targetUnit);

    % Load template sourcemodel
    load(cfg.sourcemodel);
    dataComponents.templateSourcemodel = sourcemodel;
    dataComponents.templateSourcemodel = ft_convert_units(dataComponents.templateSourcemodel, targetUnit);
end
