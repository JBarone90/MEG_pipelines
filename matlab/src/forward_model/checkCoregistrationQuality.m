function checkCoregistrationQuality(grad, headshape, mriCoreg, mriSegmented, hdm, targetUnit)
    % Check the quality of MRI coregistration with sensor and headshape data
    %
    % Parameters:
    %   grad: gradiometer or sensor information
    %   headshape: headshape data for alignment
    %   mriCoreg: coregistered MRI data
    %   mriSegmented: segmented MRI data
    %   hdm: headmodel for visualization
    %   targetUnit: unit to use for the visualizations ('cm', 'mm', etc.)
    %
    % This function visualizes the sensor layout, headshape, segmented MRI,
    % and the headmodel for assessing the coregistration quality.

    if nargin < 6
        targetUnit = 'cm';  % Set default unit to 'cm' if not provided
    end

    % Plot sensors and headshape
    figure;
    ft_plot_sens(grad, 'unit', targetUnit);
    ft_plot_headshape(headshape, 'unit', targetUnit);
    ft_plot_vol(hdm, 'unit', targetUnit);
    ft_plot_axes([], 'unit', targetUnit);
    
    % MRI anatomy and brain segmentation
    cfg = [];
    cfg.anaparameter = 'anatomy';
    cfg.funparameter = 'brain';
    cfg.location = 'center';
    cfg.unit = targetUnit;
    ft_sourceplot(cfg, mriSegmented);
    
    % MRI scalp surface and polhemus headshape
    cfg = [];
    cfg.tissue = 'scalp';
    cfg.method = 'isosurface';
    cfg.numvertices = 10000;
    cfg.unit = targetUnit;
    scalp = ft_prepare_mesh(cfg, mriSegmented);

    % Plot MRI scalp surface
    figure;
    ft_plot_mesh(scalp, 'facecolor', 'skin', 'unit', targetUnit);
    lighting phong;
    camlight left;
    camlight right;
    material dull;
    alpha 0.5;
    ft_plot_headshape(headshape, 'vertexcolor', 'k', 'unit', targetUnit);
    
    % MRI and anatomical landmarks
    figure;
    for i = 1:3
        subplot(2, 2, i);
        title(headshape.fid.label{i});
        location = headshape.fid.pos(i, :);
        ft_plot_ortho(mriCoreg.anatomy, 'transform', mriCoreg.transform, 'style', ...
            'intersect', 'location', location, 'plotmarker', location, 'markersize', 5, 'markercolor', 'y', 'unit', targetUnit);
    end
    
    % MRI scalp surface and anatomical landmarks
    figure;
    ft_plot_mesh(scalp, 'facecolor', 'skin', 'unit', targetUnit);
    lighting phong;
    camlight left;
    camlight right;
    material dull;
    alpha 0.3;
    ft_plot_mesh(headshape.fid, 'vertexcolor', 'k', 'vertexsize', 10, 'unit', targetUnit);

end
