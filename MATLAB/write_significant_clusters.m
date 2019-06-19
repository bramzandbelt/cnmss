function write_significant_clusters(glm_dir, inference, conmap_ix, varargin)
%
% DESCRIPTION
%
% Make sure that the following tools are path
% - SPM
% - panel
% - slice display
% - CorrClusThres
%
% SYNTAX
% glm_dir      - directory containing 2nd-level one-sample t-test data
% conmap_ix     - index of contrast maps to display (positive and negative)
% inference     - 'voxel' or 'cluster'
%
% ......................................................................... 
% November, 2017
% Bram Zandbelt (bramzandbelt@gmail.com), Radboud University

% Assertions ==============================================================
assert(exist(glm_dir,'dir') == 7, 'The directory glm_dir does not exist');
assert(exist(fullfile(glm_dir,'SPM.mat'),'file') == 2, 'The directory glm_dir should contain an SPM.mat file');
assert(all(size(conmap_ix(:)) == [2,1]), 'The variable conmap_ix should specify two contrasts and have dimensions [1, 2]');
assert(any(strncmp(inference,{'voxel','cluster'},10)), 'The variable inference should be ''voxel'' (voxel-level inference) or ''cluster'' (cluster-level inference)')

if nargin > 3
    mask_image = true;
    mask_file = varargin{1}
else
    mask_image = false;
end

% Identify and save significant clusters (binary) =========================

% Specify the job ---------------------------------------------------------

job_write_bin_maps{1}.spm.stats.results.spmmat = cellstr(fullfile(glm_dir,'SPM.mat'));
for i_contrast = 1:2
    job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).titlestr = '';
    job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).contrasts = conmap_ix(i_contrast);
    switch lower(inference)
        case 'voxel'
            job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).threshdesc = 'FWE';
            job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).thresh = 0.05;
            job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).extent = 0;
        case 'cluster'
            load(fullfile(glm_dir,'SPM.mat'))
            job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).threshdesc = 'none';
            job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).thresh = 0.001;
            if mask_image
                % Cluster-extent threshold, given anatomical ROI mask
                job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).extent = 18;
            else
                job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).extent = CorrClusTh(SPM, 0.001, 0.05);
            end
    end
    
    if mask_image
        job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).mask.image.name = cellstr(mask_file);
        job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).mask.image.mtype = 0; % Confusingly, 0 means inclusive
    else
        job_write_bin_maps{1}.spm.stats.results.conspec(i_contrast).mask.none = 1;
    end
    
end
job_write_bin_maps{1}.spm.stats.results.units = 1;
job_write_bin_maps{1}.spm.stats.results.print = 'csv';
if mask_image
    job_write_bin_maps{1}.spm.stats.results.write.binary.basename = sprintf('%s-level_significant_clusters_binary_roi_inclusive_mask', lower(inference));
else
    job_write_bin_maps{1}.spm.stats.results.write.binary.basename = sprintf('%s-level_significant_clusters_binary', lower(inference));
end


% Run the job -------------------------------------------------------------

% N.B. This also puts the variables xSPM, SPM, among others, in base workspace
spm_jobman('run', job_write_bin_maps)


% Rename the csv files
for i_contrast = 1:2
    
    fn_source = sprintf('spm_%s_%.3d.csv', datestr(now, 'yyyymmmdd'), i_contrast);
    if mask_image
        fn_dest = sprintf('spmT_%.4d_%s-level_significant_clusters_roi_inclusive_mask.csv', i_contrast, lower(inference));
    else
        fn_dest = sprintf('spmT_%.4d_%s-level_significant_clusters.csv', i_contrast, lower(inference));
    end
    
    movefile(fullfile(pwd, fn_source), fullfile(pwd, fn_dest));
        
end

% Merge binary maps =======================================================

% Specify the job ---------------------------------------------------------

if mask_image
    job_merge_bin_maps{1}.spm.util.imcalc.input = cellstr(char(spm_select('FPList',glm_dir,sprintf('spmT_%.4d_%s-level_significant_clusters_binary_roi_inclusive_mask.nii', conmap_ix(1), lower(inference))), ...
                                                               spm_select('FPList',glm_dir,sprintf('spmT_%.4d_%s-level_significant_clusters_binary_roi_inclusive_mask.nii', conmap_ix(2), lower(inference)))));
    job_merge_bin_maps{1}.spm.util.imcalc.output = sprintf('%s-level_significant_clusters_roi_inclusive_mask_binary_con_%.4d_and_con_%.4d', lower(inference), conmap_ix(1), conmap_ix(2));
else
    job_merge_bin_maps{1}.spm.util.imcalc.input = cellstr(char(spm_select('FPList',glm_dir,sprintf('spmT_%.4d_%s-level_significant_clusters_binary.nii', conmap_ix(1), lower(inference))), ...
                                                               spm_select('FPList',glm_dir,sprintf('spmT_%.4d_%s-level_significant_clusters_binary.nii', conmap_ix(2), lower(inference)))));
    job_merge_bin_maps{1}.spm.util.imcalc.output = sprintf('%s-level_significant_clusters_binary_con_%.4d_and_con_%.4d', lower(inference), conmap_ix(1), conmap_ix(2));
end
job_merge_bin_maps{1}.spm.util.imcalc.outdir = cellstr(glm_dir);
job_merge_bin_maps{1}.spm.util.imcalc.expression = 'i1 + i2';
job_merge_bin_maps{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
job_merge_bin_maps{1}.spm.util.imcalc.options.dmtx = 0;
job_merge_bin_maps{1}.spm.util.imcalc.options.mask = 0;
job_merge_bin_maps{1}.spm.util.imcalc.options.interp = 0;
job_merge_bin_maps{1}.spm.util.imcalc.options.dtype = 4;

% Run the job -------------------------------------------------------------

spm_jobman('run', job_merge_bin_maps)