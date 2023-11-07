function result = loadAndAlignMRI(mriPath, inputHeadshape, targetUnit, plotFlag)
    % Load MRI and perform coregistration.
    %
    % Parameters:
    %   mriPath: string containing MRI path
    %   inputHeadshape: headshape data
    %   targetUnit: the target unit for conversion ('cm' or 'mm')
    %   plotFlag: boolean flag to control plotting of scalp mesh and headshape
    %
    % Returns:
    %   result: struct containing coregistered MRI and scalp mesh

    % Validate and parse function arguments
    narginchk(3, 4); % Checks for minimum 3 arguments and maximum 4
    if nargin < 4
        plotFlag = false; % Default is not to plot
    end

    % Load MRI
    mriOriginal = ft_read_mri(mriPath);
    mriOriginal = ft_convert_units(mriOriginal, targetUnit);

    % Initial coregistration
    cfgInteractive = [];
    cfgInteractive.method = 'interactive';
    cfgInteractive.coordsys = 'ctf';
    mriInteractiveAligned = ft_volumerealign(cfgInteractive, mriOriginal);
    mriInteractiveAligned = ft_convert_units(mriInteractiveAligned, targetUnit);

    % Further coregistration using Polhemus data if available
    if ~isempty(inputHeadshape)
        cfgHeadshape = [];
        cfgHeadshape.method = 'headshape';
        cfgHeadshape.headshape.headshape = inputHeadshape;
        cfgHeadshape.headshape.interactive = 'no';
        cfgHeadshape.headshape.icp = 'yes';
        cfgHeadshape.coordsys = 'ctf';
        mriHeadshapeAligned = ft_volumerealign(cfgHeadshape, mriInteractiveAligned);
        mriHeadshapeAligned = ft_convert_units(mriHeadshapeAligned, targetUnit);

        % Manual correction
        cfgHeadshape.headshape.interactive = 'yes';
        mriFinalAligned = ft_volumerealign(cfgHeadshape, mriHeadshapeAligned);
    else
        mriFinalAligned = mriInteractiveAligned;
    end

    % Scalp segmentation
    cfgScalpSegment = [];
    cfgScalpSegment.output = 'scalp';
    cfgScalpSegment.spmversion = 'spm8';
    cfgScalpSegment.scalpsmooth = 2;
    cfgScalpSegment.scalpthreshold = 0.1000;
    scalpSegment = ft_volumesegment(cfgScalpSegment, mriFinalAligned);

    % Prepare scalp mesh
    cfgScalpMesh = [];
    cfgScalpMesh.tissue = 'scalp';
    cfgScalpMesh.method = 'projectmesh';
    cfgScalpMesh.spmversion = 'spm8';
    cfgScalpMesh.numvertices = 20000;
    scalpMesh = ft_prepare_mesh(cfgScalpMesh, scalpSegment);

    % Store results in output struct
    result.mriCoreg = mriFinalAligned;
    result.scalpMesh = scalpMesh;
    % Plot scalp mesh and headshape if shouldPlot is true
    if plotFlag
        figure;
        ft_plot_mesh(result.scalpMesh, 'facecolor', 'skin');
        lighting phong;
        camlight left;
        camlight right;
        material dull;
        alpha 0.5;
        if ~isempty(inputHeadshape)
            ft_plot_headshape(inputHeadshape, 'vertexcolor', 'k');
        end
    end
end
