% a05_exploratory_anatomical_roi_and_whole_brain_analysis

currentFile     = mfilename('fullpath');
pathstr         = fileparts(currentFile);
project_dir     = fullfile(pathstr,'../');
mfile_dir       = fullfile(project_dir,'MATLAB');

addpath(mfile_dir)

% Run exploratort fMRI analyses (anatomical ROI & whole-brain)
analysis_type = 'exploratory';
inference = 'cluster'; % Cluster-level inference

opts = struct('rerun_existing', true, ...
              'do_dual_coded_imgs', true, ...
              'show_contour_contrast_significance', true, ...
              'show_roi_mask', false);

spm fmri
fmri_analysis(analysis_type, inference, opts);