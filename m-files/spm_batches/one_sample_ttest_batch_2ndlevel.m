% List of open inputs
% Factorial design specification: Directory - cfg_files
% Factorial design specification: Scans - cfg_files
% Contrast Manager: Name - cfg_entry
% Contrast Manager: Weights vector - cfg_entry
% Contrast Manager: Name - cfg_entry
% Contrast Manager: Weights vector - cfg_entry
nrun = X; % enter the number of runs here
jobfile = {'m-files/spm_batches/one_sample_ttest_batch_2ndlevel_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(6, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Factorial design specification: Directory - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Factorial design specification: Scans - cfg_files
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % Contrast Manager: Name - cfg_entry
    inputs{4, crun} = MATLAB_CODE_TO_FILL_INPUT; % Contrast Manager: Weights vector - cfg_entry
    inputs{5, crun} = MATLAB_CODE_TO_FILL_INPUT; % Contrast Manager: Name - cfg_entry
    inputs{6, crun} = MATLAB_CODE_TO_FILL_INPUT; % Contrast Manager: Weights vector - cfg_entry
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
