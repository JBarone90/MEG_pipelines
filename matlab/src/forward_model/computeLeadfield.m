function leadField = computeLeadfield(grad, sourcemodel, hdm)
    % Compute the leadfield matrix for MEG data.
    %
    % Parameters:
    %   grad: gradiometer information from MEG data
    %   sourcemodel: source model obtained from the warped MRI
    %   hdm: headmodel for leadfield computation
    %
    % Returns:
    %   leadField: computed leadfield matrix
    
    cfg = [];
    cfg.channel = {'MEG'};
    cfg.grid = sourcemodel;
    cfg.headmodel = hdm;
    cfg.grad = grad;
    cfg.normalize = 'no'; 
    leadField = ft_prepare_leadfield(cfg);
end
