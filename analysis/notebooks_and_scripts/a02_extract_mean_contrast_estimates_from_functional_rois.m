% a02_extract_mean_contrast_estimates_from_functional_rois.m 

currentFile     = mfilename('fullpath');
pathstr         = fileparts(currentFile);
project_dir     = fullfile(pathstr,'../../');
mfile_dir       = fullfile(project_dir,'MATLAB');

addpath(mfile_dir)

% Use first-level contrast maps to extract mean contrast estimates from
% functional ROIs
run(fullfile(mfile_dir, 'extract_roi_contrast_estimates.m'))