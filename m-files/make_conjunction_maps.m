function make_conjunction_maps( ostt_dirs, out_dir, out_name, inference, roi_mask)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% Donald McLaren's approach to conjunction analyses 
% (conjunction as overlap, see SPM mailinglist)

act_files = [];
deact_files = [];

n_ostt_dirs = size(ostt_dirs,1);

switch lower(inference)
    case 'cluster'
        if roi_mask
            for i = 1:n_ostt_dirs
                act_files   = strvcat(act_files, spm_select('FPList',ostt_dirs{i},'spmT_0001_cluster-level_significant_clusters_binary_roi_inclusive_mask.nii'));
                deact_files = strvcat(deact_files, spm_select('FPList',ostt_dirs{i},'spmT_0002_cluster-level_significant_clusters_binary_roi_inclusive_mask.nii'));
            end
        else
            for i = 1:n_ostt_dirs
                act_files   = strvcat(act_files, spm_select('FPList',ostt_dirs{i},'spmT_0001_cluster-level_significant_clusters_binary.nii'));
                deact_files = strvcat(deact_files, spm_select('FPList',ostt_dirs{i},'spmT_0002_cluster-level_significant_clusters_binary.nii'));
            end
        end
    case 'voxel'
        if roi_mask
            for i = 1:n_ostt_dirs
                act_files   = strvcat(act_files, spm_select('FPList',ostt_dirs{i},'spmT_0001_voxel-level_significant_clusters_binary_roi_inclusive_mask.nii'));
                deact_files = strvcat(deact_files, spm_select('FPList',ostt_dirs{i},'spmT_0002_voxel-level_significant_clusters_binary_roi_inclusive_mask.nii'));
            end
        else
            for i = 1:n_ostt_dirs
                act_files   = strvcat(act_files, spm_select('FPList',ostt_dirs{i},'spmT_0001_voxel-level_significant_clusters_binary.nii'));
                deact_files = strvcat(deact_files, spm_select('FPList',ostt_dirs{i},'spmT_0002_voxel-level_significant_clusters_binary.nii'));
            end
        end
end

% Merge binary maps =======================================================

% Specify the job ---------------------------------------------------------

% Activations
job_merge_bin_maps{1}.spm.util.imcalc.input = cellstr(act_files);
switch lower(inference)
    case 'cluster'
        if roi_mask
            job_merge_bin_maps{1}.spm.util.imcalc.output = ['cluster-level_activations_roi_inclusive_mask_', out_name];
        else
            job_merge_bin_maps{1}.spm.util.imcalc.output = ['cluster-level_activations_', out_name];
        end
        
        
    case 'voxel'
        if roi_mask
            job_merge_bin_maps{1}.spm.util.imcalc.output = ['voxel-level_activations_roi_inclusive_mask_', out_name];
        else
            job_merge_bin_maps{1}.spm.util.imcalc.output = ['voxel-level_activations_', out_name];
        end
        
end
job_merge_bin_maps{1}.spm.util.imcalc.outdir = cellstr(out_dir);
job_merge_bin_maps{1}.spm.util.imcalc.expression = ['(',sprintf('i%d +',1:n_ostt_dirs-1),sprintf('i%d) > %f',n_ostt_dirs, n_ostt_dirs-0.5)];
job_merge_bin_maps{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
job_merge_bin_maps{1}.spm.util.imcalc.options.dmtx = 0;
job_merge_bin_maps{1}.spm.util.imcalc.options.mask = 0;
job_merge_bin_maps{1}.spm.util.imcalc.options.interp = 0;
job_merge_bin_maps{1}.spm.util.imcalc.options.dtype = 4;

% Deactivations
job_merge_bin_maps{2}.spm.util.imcalc.input = cellstr(deact_files);
switch lower(inference)
    case 'cluster'
        if roi_mask
            job_merge_bin_maps{2}.spm.util.imcalc.output = ['cluster-level_deactivations_roi_inclusive_mask_', out_name];
        else
            job_merge_bin_maps{2}.spm.util.imcalc.output = ['cluster-level_deactivations_', out_name];
        end
    case 'voxel'
        if roi_mask
            job_merge_bin_maps{2}.spm.util.imcalc.output = ['voxel-level_deactivations_roi_inclusive_mask_', out_name];
        else
            job_merge_bin_maps{2}.spm.util.imcalc.output = ['voxel-level_deactivations_', out_name];
        end
end
job_merge_bin_maps{2}.spm.util.imcalc.outdir = cellstr(out_dir);
job_merge_bin_maps{2}.spm.util.imcalc.expression = ['(',sprintf('i%d +',1:n_ostt_dirs-1),sprintf('i%d) > %f',n_ostt_dirs, n_ostt_dirs-0.5)];
job_merge_bin_maps{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
job_merge_bin_maps{2}.spm.util.imcalc.options.dmtx = 0;
job_merge_bin_maps{2}.spm.util.imcalc.options.mask = 0;
job_merge_bin_maps{2}.spm.util.imcalc.options.interp = 0;
job_merge_bin_maps{2}.spm.util.imcalc.options.dtype = 4;

% Run the job -------------------------------------------------------------

spm_jobman('run', job_merge_bin_maps)

% Activations and deactivations

switch lower(inference)
    case 'cluster'
        if roi_mask
            job_merge_bin_maps_act_deact{1}.spm.util.imcalc.input = cellstr(strvcat(spm_select('FPList',out_dir,['^cluster-level_activations_roi_inclusive_mask_',out_name,'.nii$']), ...
                                                                                    spm_select('FPList',out_dir,['^cluster-level_deactivations_roi_inclusive_mask_',out_name,'.nii$'])));
            job_merge_bin_maps_act_deact{1}.spm.util.imcalc.output = ['cluster-level_roi_inclusive_mask_', out_name];
        else
            job_merge_bin_maps_act_deact{1}.spm.util.imcalc.input = cellstr(strvcat(spm_select('FPList',out_dir,['^cluster-level_activations_',out_name,'.nii$']), ...
                                                                                    spm_select('FPList',out_dir,['^cluster-level_deactivations_',out_name,'.nii$'])));
            job_merge_bin_maps_act_deact{1}.spm.util.imcalc.output = ['cluster-level_', out_name];
        end
    case 'voxel'
        if roi_mask
            job_merge_bin_maps_act_deact{1}.spm.util.imcalc.input = cellstr(strvcat(spm_select('FPList',out_dir,['^voxel-level_activations_roi_inclusive_mask_',out_name,'.nii$']), ...
                                                                                    spm_select('FPList',out_dir,['^voxel-level_deactivations_roi_inclusive_mask_',out_name,'.nii$'])));
            job_merge_bin_maps_act_deact{1}.spm.util.imcalc.output = ['voxel-level_roi_inclusive_mask_', out_name];
        else
            job_merge_bin_maps_act_deact{1}.spm.util.imcalc.input = cellstr(strvcat(spm_select('FPList',out_dir,['^voxel-level_activations_',out_name,'.nii$']), ...
                                                                                    spm_select('FPList',out_dir,['^voxel-level_deactivations_',out_name,'.nii$'])));
            job_merge_bin_maps_act_deact{1}.spm.util.imcalc.output = ['voxel-level_', out_name];
        end
end
job_merge_bin_maps_act_deact{1}.spm.util.imcalc.outdir = cellstr(out_dir);
job_merge_bin_maps_act_deact{1}.spm.util.imcalc.expression = 'i1 + i2';
job_merge_bin_maps_act_deact{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
job_merge_bin_maps_act_deact{1}.spm.util.imcalc.options.dmtx = 0;
job_merge_bin_maps_act_deact{1}.spm.util.imcalc.options.mask = 0;
job_merge_bin_maps_act_deact{1}.spm.util.imcalc.options.interp = 0;
job_merge_bin_maps_act_deact{1}.spm.util.imcalc.options.dtype = 4;

% Run the job -------------------------------------------------------------

spm_jobman('run', job_merge_bin_maps_act_deact)


end

