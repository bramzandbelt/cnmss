% List of open inputs
% Results Report: Select SPM.mat - cfg_files
% Results Report: Contrast(s) - cfg_entry
nrun = X; % enter the number of runs here
jobfile = {'m-files/spm_batches/results_report_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(2, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Results Report: Select SPM.mat - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Results Report: Contrast(s) - cfg_entry
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});