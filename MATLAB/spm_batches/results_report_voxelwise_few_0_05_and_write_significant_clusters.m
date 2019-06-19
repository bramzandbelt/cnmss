% List of open inputs
% Results Report: Select SPM.mat - cfg_files
% Results Report: Contrast(s) - cfg_entry
% Results Report: Contrast(s) - cfg_entry
nrun = X; % enter the number of runs here
jobfile = {'MATLAB/spm_batches/results_report_voxelwise_few_0_05_and_write_significant_clusters_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(3, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Results Report: Select SPM.mat - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Results Report: Contrast(s) - cfg_entry
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % Results Report: Contrast(s) - cfg_entry
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
