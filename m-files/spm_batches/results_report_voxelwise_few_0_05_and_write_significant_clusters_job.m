%-----------------------------------------------------------------------
% Job saved on 29-Nov-2017 07:59:38 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6470)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
results_batch{1}.spm.stats.results.spmmat = cellstr(fullfile(ostt_dir,'SPM.mat'));
results_batch{1}.spm.stats.results.conspec(1).titlestr = '';
results_batch{1}.spm.stats.results.conspec(1).contrasts = 1;
results_batch{1}.spm.stats.results.conspec(1).threshdesc = 'FWE';
results_batch{1}.spm.stats.results.conspec(1).thresh = 0.05;
results_batch{1}.spm.stats.results.conspec(1).extent = 0;
results_batch{1}.spm.stats.results.conspec(1).mask.none = 1;
results_batch{1}.spm.stats.results.conspec(2).titlestr = '';
results_batch{1}.spm.stats.results.conspec(2).contrasts = 2;
results_batch{1}.spm.stats.results.conspec(2).threshdesc = 'FWE';
results_batch{1}.spm.stats.results.conspec(2).thresh = 0.05;
results_batch{1}.spm.stats.results.conspec(2).extent = 0;
results_batch{1}.spm.stats.results.conspec(2).mask.none = 1;
results_batch{1}.spm.stats.results.units = 1;
results_batch{1}.spm.stats.results.print = 'pdf';
results_batch{1}.spm.stats.results.write.binary.basename = 'significant_clusters_binary';
results_batch{2}.spm.util.imcalc.input = cellstr(char(spm_select('FPList',ostt_dir,sprintf('spmT_%.4d_significant_clusters_binary.nii',1)), ...
                                                       spm_select('FPList',ostt_dir,sprintf('spmT_%.4d_significant_clusters_binary.nii',2))));
results_batch{2}.spm.util.imcalc.output = 'significant_clusters_binary';
results_batch{2}.spm.util.imcalc.outdir = cellstr(ostt_dir);
results_batch{2}.spm.util.imcalc.expression = 'i1 + i2';
results_batch{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
results_batch{2}.spm.util.imcalc.options.dmtx = 0;
results_batch{2}.spm.util.imcalc.options.mask = 0;
results_batch{2}.spm.util.imcalc.options.interp = 0;
results_batch{2}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run', results_batch)