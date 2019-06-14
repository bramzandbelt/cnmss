function one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, output_dir)
% ONE_SAMPLE_TTEST Specifies, estimates, and makes contrast images for a
% 2nd-level one-sample t-test
%
% DESCRIPTION
% N.B. Make sure that SPM is on path.
%
% SYNTAX
% conmap_dir       - directory where first-level contrast maps reside
% conmap_ix        - contrast map index (first-level)
% con_name_pos     - contrast name of positive (1) contrast weight
% con_name_neg     - contrast name of negative (-1) contrast weight
% output_dir       - directory where outputs should be written
%
% EXAMPLE
% conmap_dir = 'data/fmri/contrast_images';
% conmap_ix = 4;
% con_name_pos = 'successful stop_{left} - no-signal_{slow}'
% con_name_neg = 'no-signal_{slow} - successful stop_{left}'
% output_dir = 'data/fmri/ostt_successful_stop_left_vs_no-signal_slow'
%
% one_sample_ttest(conmap_dir, conmap_ix, con_name_pos, con_name_neg, output_dir)
%
% ......................................................................... 
% Bram Zandbelt (bramzandbelt@gmail.com), Radboud University

% Verify if output_dir exists
if exist(output_dir,'dir') == 0
    mkdir(output_dir)
end

% Select contrast maps
filt = sprintf('.*con_%.4d.nii',conmap_ix);
con_maps = spm_select('FPList',conmap_dir, filt)

job_ostt{1}.spm.stats.factorial_design.dir = cellstr(output_dir);
job_ostt{1}.spm.stats.factorial_design.des.t1.scans = cellstr(con_maps);
job_ostt{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
job_ostt{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
job_ostt{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
job_ostt{1}.spm.stats.factorial_design.masking.im = 1;
job_ostt{1}.spm.stats.factorial_design.masking.em = {''};
job_ostt{1}.spm.stats.factorial_design.globalc.g_omit = 1;
job_ostt{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
job_ostt{1}.spm.stats.factorial_design.globalm.glonorm = 1;
job_ostt{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
job_ostt{2}.spm.stats.fmri_est.write_residuals = 0;
job_ostt{2}.spm.stats.fmri_est.method.Classical = 1;
job_ostt{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
job_ostt{3}.spm.stats.con.consess{1}.tcon.name = '<UNDEFINED>';
job_ostt{3}.spm.stats.con.consess{1}.tcon.weights = '<UNDEFINED>';
job_ostt{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
job_ostt{3}.spm.stats.con.consess{2}.tcon.name = '<UNDEFINED>';
job_ostt{3}.spm.stats.con.consess{2}.tcon.weights = '<UNDEFINED>';
job_ostt{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
job_ostt{3}.spm.stats.con.delete = 1;

nrun = 1; % Number of runs here
jobfile = {fullfile(batch_dir,'one_sample_ttest_batch_2ndlevel_job.m')};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(6, nrun);
for crun = 1:nrun
    inputs{1, crun} = cellstr(output_dir); % Factorial design specification: Directory - cfg_files
    inputs{2, crun} = cellstr(con_maps); % Factorial design specification: Scans - cfg_files
    inputs{3, crun} = [con_name_pos, ' - ', con_name_neg]; % Contrast Manager: Name - cfg_entry
    inputs{4, crun} = [1]; % Contrast Manager: Weights vector - cfg_entry
    inputs{5, crun} = [con_name_neg, ' - ', con_name_pos]; % Contrast Manager: Name - cfg_entry
    inputs{6, crun} = [-1]; % Contrast Manager: Weights vector - cfg_entry
end

spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});