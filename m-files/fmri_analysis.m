function fmri_analysis(analysis_type, inference, varargin)
%
% Make sure that SPM12 is on MATLAB path
%
%

if nargin > 2
    opts = varargin{1};
else
    opts = struct('do_ostt', true, ...
                  'do_conj_maps', true, ...
                  'do_dual_coded_imgs', true, ...
                  'show_contour_contrast_significance', true, ...
                  'show_roi_mask', false);        
end

% Preliminaries
% =========================================================================



% Directories and files
currentFile     = mfilename('fullpath');
pathstr         = fileparts(currentFile);
project_dir     = fullfile(pathstr,'../');
data_dir        = fullfile(project_dir,'data');


t1_dir          = fullfile(data_dir,'fmri','anatomical_images');
roi_dir         = fullfile(data_dir,'fmri','region_of_interest_masks');
output_dir      = fullfile(data_dir,'derivatives','fmri','m_anatomical_roi_and_whole_brain_analysis');

if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

figure_dir      = fullfile(project_dir,'results','figures', 'm_anatomical_roi_and_whole_brain_analysis', analysis_type);

if ~exist(figure_dir, 'dir')
    mkdir(figure_dir);
end





t1img           = fullfile(t1_dir,'group_mean_T1.nii');
colormaps_file  = fullfile(data_dir,'fmri','colormaps.mat');
load(colormaps_file);



% Paths
addpath(genpath('/Users/bramzandbelt/Documents/MATLAB/spm12/'))
addpath(genpath(fullfile(project_dir,'opt')))
addpath(genpath(fullfile(project_dir,'code')))


% Other settngs
save_fig        = true;

cd(project_dir)


% Run statistical models
% =========================================================================
if opts.do_ostt
    
    conmap_dir      = fullfile(data_dir,'fmri','contrast_images');
    batch_dir       = fullfile(project_dir,'m-files','spm_batches');
    
    anat_roi_mask   = fullfile(roi_dir, 'anatomical_classical_svc', 'anatomical_rois.nii');

    switch lower(analysis_type)
        case 'planned'

            % successful stop_{left} vs. ignore_{fast}
            % -------------------------------------------------------------

            conmap_ix = 1;
            con_name_pos = 'successful stop_{left}';
            con_name_neg = 'ignore_{fast}';
            glm_dir = fullfile(output_dir, 'ostt_SL_vs_IGf');

            % Run one-sample t-test
            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

            % successful stop_{right} vs. ignore_{fast}
            % -------------------------------------------------------------

            conmap_ix = 2;
            con_name_pos = 'successful stop_{right}';
            con_name_neg = 'ignore_{fast}';
            glm_dir = fullfile(output_dir, 'ostt_SR_vs_IGf');

            % Run one-sample t-test
            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

            % successful stop_{both} vs. ignore_{fast}
            % -------------------------------------------------------------

            conmap_ix = 3;
            con_name_pos = 'successful stop_{both}';
            con_name_neg = 'ignore_{fast}';
            glm_dir = fullfile(output_dir, 'ostt_SB_vs_IGf');

            % Run one-sample t-test
            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

            % successful stop_{left} vs. successful stop_{both}
            % -------------------------------------------------------------

            conmap_ix = 4;
            con_name_pos = 'successful stop_{left}';
            con_name_neg = 'successful stop_{both}';
            glm_dir = fullfile(output_dir, 'ostt_SL_vs_SB');

            % Run one-sample t-test
            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

            % successful stop_{right} vs. successful stop_{both}
            % -------------------------------------------------------------

            conmap_ix = 5;
            con_name_pos = 'successful stop_{right}';
            con_name_neg = 'successful stop_{both}';
            glm_dir = fullfile(output_dir, 'ostt_SR_vs_SB');

            % Run one-sample t-test
            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

        case 'exploratory'

            % successful stop_{left} vs. no-signal_{slow}
            % -------------------------------------------------------------

            conmap_ix = 8;
            con_name_pos = 'successful stop_{left}';
            con_name_neg = 'no-signal_{slow}';
            glm_dir = fullfile(output_dir, 'ostt_SL_vs_NSs');

            % Run one-sample t-test
            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

            % successful stop_{right} vs. no-signal_{slow}
            % -------------------------------------------------------------

            conmap_ix = 10;
            con_name_pos = 'successful stop_{right}';
            con_name_neg = 'no-signal_{slow}';
            glm_dir = fullfile(output_dir, 'ostt_SR_vs_NSs');

            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

            % successful stop_{both} vs. no-signal_{slow}
            % -------------------------------------------------------------

            conmap_ix = 12;
            con_name_pos = 'successful stop_{both}';
            con_name_neg = 'no-signal_{slow}';
            glm_dir = fullfile(output_dir, 'ostt_SB_vs_NSs');

            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

            % successful stop_{left} vs. ignore_{slow}
            % -------------------------------------------------------------

            conmap_ix = 22;
            con_name_pos = 'successful stop_{left}';
            con_name_neg = 'ignore_{slow}';
            glm_dir = fullfile(output_dir, 'ostt_SL_vs_IGs');

            % Run one-sample t-test
            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

            % successful stop_{right} vs. ignore_{slow}
            % -------------------------------------------------------------

            conmap_ix = 23;
            con_name_pos = 'successful stop_{right}';
            con_name_neg = 'ignore_{slow}';
            glm_dir = fullfile(output_dir, 'ostt_SR_vs_IGs');

            % Run one-sample t-test
            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

            % successful stop_{both} vs. ignore_{slow}
            % -------------------------------------------------------------

            conmap_ix = 24;
            con_name_pos = 'successful stop_{both}';
            con_name_neg = 'ignore_{slow}';
            glm_dir = fullfile(output_dir, 'ostt_SB_vs_IGs');

            % Run one-sample t-test
            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

            % successful ignore_{slow} vs. no-signal_{slow}
            % -------------------------------------------------------------

            conmap_ix = 26;
            con_name_pos = 'ignore_{slow}';
            con_name_neg = 'no-signal_{slow}';
            glm_dir = fullfile(output_dir, 'ostt_IGs_vs_NSs');

            one_sample_ttest(conmap_dir, batch_dir, conmap_ix, con_name_pos, con_name_neg, glm_dir);

            % Write significant clusters within anatomical ROIs
            write_significant_clusters(glm_dir, char(inference), [1, 2], anat_roi_mask);

            % Write significant clusters within whole-brain
            write_significant_clusters(glm_dir, char(inference), [1, 2]);

    end

end


% Make conjunction maps
% =========================================================================

if opts.do_conj_maps
    
    % Make directory, if needed, for saving conjunction maps
    conjmap_dir     = fullfile(output_dir,'conjunction_maps');

    if ~exist(conjmap_dir, 'dir')
        mkdir(conjmap_dir);
    end
        
    switch lower(analysis_type)

        case 'planned'

            % SL vs. IGf AND SR vs. IGf
            % -------------------------------------------------------------

            ostt_dirs = cellstr(char(fullfile(output_dir, 'ostt_SL_vs_IGf'), ...
                                     fullfile(output_dir, 'ostt_SR_vs_IGf')));
            conjmap_name    = 'SLvsIGf_AND_SRvsIGf';

            % Make conjunction maps for anatomical ROIs (roi_mask = true)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), true);

            % Make conjunction maps for whole-brain results (roi_mask = false)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), false);

            % SL vs. IGf AND SR vs. IGf AND SB vs. IGf
            % -------------------------------------------------------------

            ostt_dirs = cellstr(char(fullfile(output_dir, 'ostt_SL_vs_IGf'), ...
                                     fullfile(output_dir, 'ostt_SR_vs_IGf'), ...
                                     fullfile(output_dir, 'ostt_SB_vs_IGf')));
            conjmap_name    = 'SLvsIGf_AND_SRvsIGf_AND_SBvsIGf';

            % Make conjunction maps for anatomical ROIs (roi_mask = true)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), true);

            % Make conjunction maps for whole-brain results (roi_mask = false)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), false);

            % SL vs. SB AND SR vs. SB
            % -------------------------------------------------------------

            ostt_dirs = cellstr(char(fullfile(output_dir, 'ostt_SL_vs_SB'), ...
                                     fullfile(output_dir, 'ostt_SR_vs_SB')));
            conjmap_name    = 'SLvsSB_AND_SRvsSB';

            % Make conjunction maps for anatomical ROIs (roi_mask = true)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), true);

            % Make conjunction maps for whole-brain results (roi_mask = false)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), false);

        case 'exploratory'

            % SL vs. SB AND SR vs. SB AND SL vs. IGf AND SR vs. IGf 
            % -------------------------------------------------------------

            ostt_dirs = cellstr(char(fullfile(output_dir, 'ostt_SL_vs_SB'), ...
                                     fullfile(output_dir, 'ostt_SR_vs_SB'), ...
                                     fullfile(output_dir, 'ostt_SL_vs_IGf'), ...
                                     fullfile(output_dir, 'ostt_SR_vs_IGf')));
            conjmap_name    = 'SLvsSB_AND_SRvsSB_AND_SLvsIGf_AND_SRvsIGf';

            % Make conjunction maps for anatomical ROIs (roi_mask = true)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), true);

            % Make conjunction maps for whole-brain results (roi_mask = false)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), false);

            % SL vs. NS AND SR vs. NS
            % -------------------------------------------------------------

            ostt_dirs = cellstr(char(fullfile(output_dir, 'ostt_SL_vs_NSs'), ...
                                     fullfile(output_dir, 'ostt_SR_vs_NSs')));
            conjmap_name    = 'SLvsNSs_AND_SRvsNSs';

            % Make conjunction maps for anatomical ROIs (roi_mask = true)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), true);

            % Make conjunction maps for whole-brain results (roi_mask = false)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), false);

            % SL vs. NS AND SR vs. NS AND SB vs. NS
            % -------------------------------------------------------------

            ostt_dirs = cellstr(char(fullfile(output_dir, 'ostt_SL_vs_NSs'), ...
                                     fullfile(output_dir, 'ostt_SR_vs_NSs'), ...
                                     fullfile(output_dir, 'ostt_SB_vs_NSs')));
            conjmap_name    = 'SLvsNSs_AND_SRvsNSs_AND_SBvsNSs';

            % Make conjunction maps for anatomical ROIs (roi_mask = true)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), true);

            % Make conjunction maps for whole-brain results (roi_mask = false)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), false);

            % SL vs. IGs AND SR vs. IGs AND SB vs. IGs
            % -------------------------------------------------------------

            ostt_dirs = cellstr(char(fullfile(output_dir, 'ostt_SL_vs_IGs'), ...
                                     fullfile(output_dir, 'ostt_SR_vs_IGs'), ...
                                     fullfile(output_dir, 'ostt_SB_vs_IGs')));
            conjmap_name    = 'SLvsIGs_AND_SRvsIGs_AND_SBvsIGs';

            % Make conjunction maps for anatomical ROIs (roi_mask = true)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), true);

            % Make conjunction maps for whole-brain results (roi_mask = false)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), false);

            % SL vs. SB AND SR vs. SB AND SL vs. IGs AND SR vs. IGs 
            % -------------------------------------------------------------

            ostt_dirs = cellstr(char(fullfile(output_dir, 'ostt_SL_vs_SB'), ...
                                     fullfile(output_dir, 'ostt_SR_vs_SB'), ...
                                     fullfile(output_dir, 'ostt_SL_vs_IGs'), ...
                                     fullfile(output_dir, 'ostt_SR_vs_IGs')));
            conjmap_name    = 'SLvsSB_AND_SRvsSB_AND_SLvsIGs_AND_SRvsIGs';

            % Make conjunction maps for anatomical ROIs (roi_mask = true)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), true);

            % Make conjunction maps for whole-brain results (roi_mask = false)
            make_conjunction_maps(ostt_dirs, conjmap_dir, conjmap_name, char(inference), false);

    end

end

% Make dual-coded images
% =========================================================================

if opts.do_dual_coded_imgs
    
    conjmap_dir     = fullfile(output_dir,'conjunction_maps');
    
    dualmap_ix = 1;
    cmap = CyBuGyRdYl;
    clrs = {[1 1 1], [0 1 0], [0 2/3 2/3]};
    lnstl = {'-','-','-'};
    clrs_alt = {[1 1 1], [0 2/3 2/3]};
    lnstl_alt = {'-','-'};
    
    if opts.show_roi_mask
        all_rois_mask = fullfile(roi_dir, 'all_rois.nii');
    end
    
    switch lower(analysis_type)

        case 'planned'
            
            % Successful stop_{left} minus ignore_{fast}
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SL_vs_IGf');
            
            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end

                    contour_conj_significance_1 = fullfile(conjmap_dir, 'cluster-level_SLvsIGf_AND_SRvsIGf.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'cluster-level_SLvsIGf_AND_SRvsIGf_AND_SBvsIGf.nii');

                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii'); 
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance_1 = fullfile(conjmap_dir, 'voxel-level_SLvsIGf_AND_SRvsIGf.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'voxel-level_SLvsIGf_AND_SRvsIGf_AND_SBvsIGf.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, all_rois_mask, clrs, lnstl);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, clrs, lnstl);
            end

            % Successful stop_{right} minus ignore_{fast}
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SR_vs_IGf');
            
            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance_1 = fullfile(conjmap_dir, 'cluster-level_SLvsIGf_AND_SRvsIGf.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'cluster-level_SLvsIGf_AND_SRvsIGf_AND_SBvsIGf.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance_1 = fullfile(conjmap_dir, 'voxel-level_SLvsIGf_AND_SRvsIGf.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'voxel-level_SLvsIGf_AND_SRvsIGf_AND_SBvsIGf.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, all_rois_mask, clrs, lnstl);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, clrs, lnstl);
            end

            % Successful stop_{both} minus ignore_{fast}
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SB_vs_IGf');
            
            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'cluster-level_SLvsIGf_AND_SRvsIGf_AND_SBvsIGf.nii');

                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'voxel-level_SLvsIGf_AND_SRvsIGf_AND_SBvsIGf.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, clrs_alt, lnstl_alt);
            end
            
            % Successful stop_{left} minus successful stop_{both}
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SL_vs_SB');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'cluster-level_SLvsSB_AND_SRvsSB.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'voxel-level_SLvsSB_AND_SRvsSB.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, clrs_alt, lnstl_alt);
            end

            % Successful stop_{right} minus successful stop_{both}
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SR_vs_SB');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'cluster-level_SLvsSB_AND_SRvsSB.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'voxel-level_SLvsSB_AND_SRvsSB.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, clrs_alt, lnstl_alt);
            end
            
        case 'exploratory'
            
            % Successful stop_{left} minus successful stop_{both} - with additional
            % IGf constraint
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SL_vs_SB');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'cluster-level_SLvsSB_AND_SRvsSB_AND_SLvsIGf_AND_SRvsIGf.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'voxel-level_SLvsSB_AND_SRvsSB_AND_SLvsIGf_AND_SRvsIGf.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, clrs_alt, lnstl_alt);
            end

            % Successful stop_{right} minus successful stop_{both} - with additional
            % IGf constraint
            % -------------------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SR_vs_SB');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'cluster-level_SLvsSB_AND_SRvsSB_AND_SLvsIGf_AND_SRvsIGf.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'voxel-level_SLvsSB_AND_SRvsSB_AND_SLvsIGf_AND_SRvsIGf.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, clrs_alt, lnstl_alt);
            end
            
            
            % Successful stop_{left} minus no-signal_{slow}
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SL_vs_NSs');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance_1 = fullfile(conjmap_dir, 'cluster-level_SLvsNSs_AND_SRvsNSs.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'cluster-level_SLvsNSs_AND_SRvsNSs_AND_SBvsNSs.nii');

                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance_1 = fullfile(conjmap_dir, 'voxel-level_SLvsNSs_AND_SRvsNSs.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'voxel-level_SLvsNSs_AND_SRvsNSs_AND_SBvsNSs.nii');

            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, all_rois_mask, clrs, lnstl);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, clrs, lnstl);
            end
            
            % Successful stop_{right} minus no-signal_{slow}
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SR_vs_NSs');
            
            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance_1 = fullfile(conjmap_dir, 'cluster-level_SLvsNSs_AND_SRvsNSs.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'cluster-level_SLvsNSs_AND_SRvsNSs_AND_SBvsNSs.nii');

                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance_1 = fullfile(conjmap_dir, 'voxel-level_SLvsNSs_AND_SRvsNSs.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'voxel-level_SLvsNSs_AND_SRvsNSs_AND_SBvsNSs.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, all_rois_mask, clrs, lnstl);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, clrs, lnstl);
            end
            
            % Successful stop_{both} minus no-signal_{slow}
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SB_vs_NSs');
            
            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end

                    contour_conj_significance = fullfile(conjmap_dir, 'cluster-level_SLvsNSs_AND_SRvsNSs_AND_SBvsNSs.nii');

                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end

                    contour_conj_significance = fullfile(conjmap_dir, 'voxel-level_SLvsNSs_AND_SRvsNSs_AND_SBvsNSs.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, clrs_alt, lnstl_alt);
            end
            
            % Successful stop_{left} minus ignore_{slow}
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SL_vs_IGs');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'cluster-level_SLvsIGs_AND_SRvsIGs_AND_SBvsIGs.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'voxel-level_SLvsIGs_AND_SRvsIGs_AND_SBvsIGs.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, clrs_alt, lnstl_alt);
            end

            % Successful stop_{right} minus ignore_{slow}
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SR_vs_IGs');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'cluster-level_SLvsIGs_AND_SRvsIGs_AND_SBvsIGs.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'voxel-level_SLvsIGs_AND_SRvsIGs_AND_SBvsIGs.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, clrs_alt, lnstl_alt);
            end

            % Successful stop_{both} minus ignore_{slow}
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SB_vs_IGs');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'cluster-level_SLvsIGs_AND_SRvsIGs_AND_SBvsIGs.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'voxel-level_SLvsIGs_AND_SRvsIGs_AND_SBvsIGs.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, clrs_alt, lnstl_alt);
            end

            % Successful stop_{left} minus successful stop_{both} - with additional
            % IGs constraint
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SL_vs_SB');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'cluster-level_SLvsSB_AND_SRvsSB_AND_SLvsIGs_AND_SRvsIGs.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'voxel-level_SLvsSB_AND_SRvsSB_AND_SLvsIGs_AND_SRvsIGs.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, clrs_alt, lnstl_alt);
            end

            % Successful stop_{right} minus successful stop_{both} - with additional
            % IGs constraint
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SR_vs_SB');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'cluster-level_SLvsSB_AND_SRvsSB_AND_SLvsIGs_AND_SRvsIGs.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance = fullfile(conjmap_dir, 'voxel-level_SLvsSB_AND_SRvsSB_AND_SLvsIGs_AND_SRvsIGs.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance, clrs_alt, lnstl_alt);
            end

            % Successful stop_{left} minus successful stop_{both} - with additional
            % IGs constraint - four contours
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SL_vs_SB');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance_1 = fullfile(conjmap_dir, 'cluster-level_SLvsSB_AND_SRvsSB.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'cluster-level_SLvsSB_AND_SRvsSB_AND_SLvsIGs_AND_SRvsIGs.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance_1 = fullfile(conjmap_dir, 'voxel-level_SLvsSB_AND_SRvsSB.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'voxel-level_SLvsSB_AND_SRvsSB_AND_SLvsIGs_AND_SRvsIGs.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, clrs_alt, lnstl_alt);
            end

            % Successful stop_{right} minus successful stop_{both} - with additional
            % IGs constraint - four contours
            % -------------------------------------------------------------

            glm_dir = fullfile(output_dir, 'ostt_SR_vs_SB');

            switch char(inference)
                case 'cluster'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'cluster-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance_1 = fullfile(conjmap_dir, 'cluster-level_SLvsSB_AND_SRvsSB.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'cluster-level_SLvsSB_AND_SRvsSB_AND_SLvsIGs_AND_SRvsIGs.nii');
                case 'voxel'
                    if opts.show_contour_contrast_significance
                        contour_contrast_significance = fullfile(glm_dir, 'voxel-level_significant_clusters_binary_con_0001_and_con_0002.nii');
                    else
                        contour_contrast_significance = '';
                    end
                    contour_conj_significance_1 = fullfile(conjmap_dir, 'voxel-level_SLvsSB_AND_SRvsSB.nii');
                    contour_conj_significance_2 = fullfile(conjmap_dir, 'voxel-level_SLvsSB_AND_SRvsSB_AND_SLvsIGs_AND_SRvsIGs.nii');
            end

            if opts.show_roi_mask
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, all_rois_mask, clrs_alt, lnstl_alt);
            else
                make_dual_coded_images(glm_dir, figure_dir, char(inference), t1img, dualmap_ix, contour_contrast_significance, cmap, save_fig, contour_conj_significance_1, contour_conj_significance_2, clrs_alt, lnstl_alt);
            end
            
            
    end
    
end
