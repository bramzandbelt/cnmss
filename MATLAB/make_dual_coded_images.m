function make_dual_coded_images(glm_dir, figure_dir, inference, t1img, dualmap_ix, contour_significance, cmap, save_fig, varargin)
%
% DESCRIPTION
%
% SYNTAX
% glm_dir               - directory containing 2nd-level one-sample t-test data
% figure_dir            - directory where figures will be written
% inference             - 'voxel' or 'cluster'
% t1img                 - T1-weighted image on which to plot results
% dualmap_ix            - index of T-contrast for which to display dual map
% contour_significance  - img filename, treated as contour image
% cmap                  - colormap variable
% save_fig              - whether or not to save dual-coded image
% other inputs          - img filenames, treated as contour images
%
% ......................................................................... 
% November, 2017
% Bram Zandbelt (bramzandbelt@gmail.com), Radboud University

% Assertions ==============================================================
assert(exist(glm_dir,'dir') == 7, 'The directory glm_dir does not exist');
assert(exist(fullfile(glm_dir,'SPM.mat'),'file') == 2, 'The directory glm_dir should contain an SPM.mat file');
assert(exist(t1img,'file') == 2, 'The file t1img does not exist');
assert(exist(fullfile(glm_dir,sprintf('con_%.4d.nii',dualmap_ix)),'file') == 2, sprintf('The file con_%.4d.nii does not exist in glm_dir', dualmap_ix));
assert(exist(fullfile(glm_dir,sprintf('spmT_%.4d.nii',dualmap_ix)),'file') == 2, sprintf('The file spmT_%.4d.nii does not exist in glm_dir', dualmap_ix));
% assert(exist(contour_significance,'file') == 2, sprintf('The contour_significance file (%s) does not exist', contour_significance));
if nargin > 8
    for i_contour = 1:length(varargin)-2
        assert(exist(varargin{i_contour},'file') == 2, sprintf('The file %s does not exist', varargin{i_contour}));
    end
end
assert(any(strncmp(inference,{'voxel','cluster'},10)), 'The variable inference should be ''voxel'' (voxel-level inference) or ''cluster'' (cluster-level inference)')

% Load results ============================================================

job_get_fmri_results{1}.spm.stats.results.spmmat = cellstr(fullfile(glm_dir,'SPM.mat'));
job_get_fmri_results{1}.spm.stats.results.conspec(1).titlestr = '';
job_get_fmri_results{1}.spm.stats.results.conspec(1).contrasts = dualmap_ix;
switch lower(inference)
    case 'voxel'
        job_get_fmri_results{1}.spm.stats.results.conspec(1).threshdesc = 'FWE';
        job_get_fmri_results{1}.spm.stats.results.conspec(1).thresh = 0.05;
        job_get_fmri_results{1}.spm.stats.results.conspec(1).extent = 0;
    case 'cluster'
        load(fullfile(glm_dir,'SPM.mat'))
        job_get_fmri_results{1}.spm.stats.results.conspec(1).threshdesc = 'none';
        job_get_fmri_results{1}.spm.stats.results.conspec(1).thresh = 0.001;
        job_get_fmri_results{1}.spm.stats.results.conspec(1).extent = CorrClusTh(SPM, 0.001, 0.05);
end
job_get_fmri_results{1}.spm.stats.results.conspec(1).mask.none = 1;
job_get_fmri_results{1}.spm.stats.results.units = 1;
job_get_fmri_results{1}.spm.stats.results.print = false;
job_get_fmri_results{1}.spm.stats.results.write.none = 1;

% Run the job -------------------------------------------------------------

% N.B. This also puts the variables xSPM, SPM, among others, in base workspace
spm_jobman('run', job_get_fmri_results)
xSPM = evalin('base', 'xSPM');
SPM = evalin('base', 'SPM');

% Display dual-coded images ===============================================

% Initialize empty layers and settings variables
if nargin > 8
    if ~isempty(contour_significance)
        layers  = sd_config_layers('init',[{'truecolor','dual','contour', 'contour'}, repmat({'contour'},1,length(varargin)-2)]);
    else
        layers  = sd_config_layers('init',[{'truecolor','dual','contour'}, repmat({'contour'},1,length(varargin)-2)]);
    end
else
    if ~isempty(contour_significance)
        layers                      = sd_config_layers('init',{'truecolor','dual','contour','contour'});
    else
        layers                      = sd_config_layers('init',{'truecolor','dual','contour'});
    end
end
settings                    = sd_config_settings('init');

% Specify layers
layers(1).color.file        = t1img;
layers(1).color.map         = gray(256);

layers(2).color.file        = spm_select('FPList',glm_dir,sprintf('^con_%.4d.nii',dualmap_ix));
layers(2).color.map         = cmap;
layers(2).color.label       = '\beta (a.u.)';
layers(2).color.range       = [-6 6];
layers(2).opacity.file      = spm_select('FPList',glm_dir,sprintf('^spmT_%.4d.nii',dualmap_ix));
layers(2).opacity.label     = '| t |';
layers(2).opacity.range     = [0 xSPM.u];

layers(3).color.file        = fullfile(glm_dir,'mask.nii');
layers(3).color.map         = [0 0 0];
layers(3).color.line_style  = ':';

if ~isempty(contour_significance)
    layers(4).color.file        = contour_significance;
    layers(4).color.map         = [2/3 2/3 2/3];
    layers(4).color.line_style  = '-';
    
    contour_tag = 'contours_significance';
    ix_start_other_layers = 4;
else
    contour_tag = '';
    ix_start_other_layers = 3;
end

if nargin > 8
    
    nvarargin = length(varargin);
    
    clrs = varargin{nvarargin - 1}
    lnstl = varargin{nvarargin};
    
    for i_file = 1:length(varargin)-2
        layers(ix_start_other_layers + i_file).color.file        = varargin{i_file};
        
        
        [~, contour_map_name] = fileparts(varargin{i_file});
        contour_tag = sprintf('%s_%s',contour_tag,contour_map_name);
        
        layers(ix_start_other_layers + i_file).color.map         = clrs{i_file};
        layers(ix_start_other_layers + i_file).color.line_style  = lnstl{i_file};
    end
end

% Specify settings
settings.slice.orientation  = 'coronal';
settings.slice.disp_slices  = [-64, -24, -2, 8, 16, 36];
settings.fig_specs.n.slice_column = 6;
settings.fig_specs.title    = SPM.xCon(dualmap_ix).name;
settings.fig_specs.width.figure = 190;

% Display the t-map overlaid on the anatomical MRI
[settings, p] = sd_display(layers,settings);


if save_fig
    [~, glm_name] = fileparts(glm_dir);
    
    % Ensure WYSIWYG
    set(p.figure.Number,'PaperPositionMode','auto')
    ppos = get(p.figure.Number,'PaperPosition');
    su = get(p.figure.Number,'Units');
    pu = get(p.figure.Number,'PaperUnits');  
    set(p.figure.Number,'Units',pu);
    spos = get(p.figure.Number,'Position');
    set(p.figure.Number,'Position',[spos(1) spos(2) ppos(3) ppos(4)])
    set(p.figure.Number,'Units',su)
    
    fig = gcf;
    fig.InvertHardcopy = 'off';
    saveas(gcf,fullfile(figure_dir,[sprintf('%s-level_dir_', inference),glm_name,'_con_',strrep(xSPM.title,' ','_'),sprintf('_%s', contour_tag),'.pdf']))
    
    close;
    
%     % Switching off InvertHardcopy so text is printed in WYSIWYG fashion, doesn't work with set.
%     fig = get(p.figure.Number);
%     fig.InvertHardcopy = 'off';
% 
%     % Save as PDF
%     print(p.figure.Number, '-r600', '-dpdf', fullfile(figure_dir,[sprintf('%s-level_', inference),glm_name]))
%     saveas(gcf,fullfile(figure_dir,[sprintf('%s-level_', inference),glm_name,'_bla']))
    
    
%     % Save as EPS
%     print('-r600', '-depsc', fullfile(figure_dir,[sprintf('%s-level_', inference),glm_name]))
    
%     p.export(... 
%         fullfile(figure_dir,[sprintf('%s-level_', inference),glm_name]), ...
%         sprintf('-w%s',int2str(settings.fig_specs.width.figure)), ...
%         '-rp', ...
%         '-oeps')
%     
%     % Save as SVG
%     p.export(... 
%         fullfile(figure_dir,[sprintf('%s-level_', inference),glm_name]), ...
%         sprintf('-w%s',int2str(settings.fig_specs.width.figure)), ...
%         '-rp', ...
%         '-osvg')

%     % Save as PDF
%     p.export(... 
%         fullfile(figure_dir,[sprintf('%s-level_', inference),glm_name]), ...
%         sprintf('-w%s',int2str(settings.fig_specs.width.figure)), ...
%         '-rp', ...
%         '-opdf')
end