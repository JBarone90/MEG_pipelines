function sourcemodel = warpSourceModel(mriCoreg, templateSourcemodel, hdm, normMethod, targetUnit)
    % Compute and warp the sourcemodel based on the specified normalization method.
    %
    % Parameters:
    %   mriCoreg: coregistered MRI data
    %   templateSourcemodel: template sourcemodel to warp to
    %   hdm: headmodel for visualization
    %   normMethod: method for normalization ('old' or 'new')
    %   targetUnit: unit of the source model (default: 'cm')
    %
    % Returns:
    %   sourcemodel: the warped sourcemodel
    
    if nargin < 5
        targetUnit = 'cm'; % Default unit if not specified
    end

    if strcmp(normMethod, 'old')
        cfg = [];
        cfg.grid.warpmni = 'yes';
        cfg.grid.template = templateSourcemodel;
        cfg.grid.nonlinear = 'yes';
        cfg.mri = mriCoreg;
        cfg.unit = targetUnit;
        sourcemodel = ft_prepare_sourcemodel(cfg);
    elseif strcmp(normMethod, 'new')   % if normalization did not work previously redo with spm12
        cfg = [];
        cfg.grid.warpmni = 'yes';
        cfg.grid.template = templateSourcemodel;
        cfg.grid.nonlinear = 'yes';
        cfg.mri = mriCoreg;
        cfg.spmversion = 'spm12';
        cfg.spmmethod = 'new'; % default is 'old'
        cfg.unit = targetUnit;
        sourcemodel = ft_prepare_sourcemodel(cfg);
    else
        error('<< Please select the correct normalization: old or new >>');
    end

    % Visualize to check if warping worked
    figure;
    ft_plot_vol(hdm, 'edgecolor', 'none', 'facealpha', 0.4, 'facecolor', 'b');
    ft_plot_mesh(sourcemodel.pos(sourcemodel.inside,:));
end
