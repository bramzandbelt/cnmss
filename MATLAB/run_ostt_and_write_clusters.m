function run_ostt_and_write_clusters(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir, opts, inference, anat_roi_mask)
% RUN_OSTT_AND_WRITE_CLUSTERS Wrapper function for running one-sample
% t-test and writing statistically significant clusters
%

% Has analysis already been run?
if exist(fullfile(glm_dir, 'mask.nii'), 'file') == 2 && opts.rerun_existing == false
    return
else
    % Remove directory
    if exist(fullfile(glm_dir, 'mask.nii'), 'file') == 2
        rmdir(glm_dir, 's')
    end

    % Run one-sample t-test
    one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

    % Write significant clusters within anatomical ROIs
    write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

    % Write significant clusters within whole-brain
    write_significant_clusters(glm_dir, char(inference), [1, 2]);
end