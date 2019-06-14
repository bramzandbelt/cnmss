% Extract ROI contrast estimates
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure that SPM12 is on MATLAB path

currentFile     = mfilename('fullpath');
pathstr         = fileparts(currentFile);
project_dir     = fullfile(pathstr,'../');
mfile_dir       = fullfile(project_dir,'m-files');
data_dir        = fullfile(project_dir,'data');
stat_dir        = fullfile(data_dir,'fmri','stat');
conmap_dir      = fullfile(data_dir,'fmri','contrast_images');
roi_dir         = fullfile(data_dir,'fmri','region_of_interest_masks');
output_dir      = fullfile(data_dir,'derivatives','a02_extract_mean_contrast_estimates_from_functional_rois');

if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Add paths
% addpath(genpath('/Users/bramzandbelt/Documents/MATLAB/spm12/'))
addpath(genpath(mfile_dir))
addpath(genpath(fullfile(project_dir,'opt','panel-2.12')))
addpath(genpath(fullfile(project_dir,'opt','slice_display')))

% Go to project directory
cd(project_dir)

% Make empty dataset array
ds = dataset();

for hemi = {'left', 'right'}
    
    % Select ROI files
    roi = spm_select('FPList', fullfile(roi_dir, 'for_extraction', char(hemi)), '.*.nii$');
    
    switch char(hemi)
        case 'left'
            hemi_tag = 'L';
        case 'right'
            hemi_tag = 'R';
    end
    
    for con = {'stop_as_left_vs_no_signal_slow', ...
               'stop_as_right_vs_no_signal_slow', ...
               'stop_ss_vs_no_signal_slow', ...
               'ignore_slow_vs_no_signal_slow', ...
               'stop_as_left', ... % Corresponds to SAS,left in preregistration
               'stop_as_right', ... % Corresponds to SAS,right in preregistration
               'stop_ss', ... % Corresponds to SAS,both in preregistration
               'ignore_slow_vs_ignore_fast', ...
               'stop_as_left_vs_stop_ss', ...
               'stop_as_right_vs_stop_ss'
               }
           
        % Select data files
        switch char(con)
            case 'stop_as_left_vs_no_signal_slow'
                data = spm_select('FPList', conmap_dir, '^subj.*_con_0008.nii$');
            case 'stop_as_right_vs_no_signal_slow'
                data = spm_select('FPList', conmap_dir, '^subj.*_con_0010.nii$');
            case 'stop_ss_vs_no_signal_slow'
                data = spm_select('FPList', conmap_dir, '^subj.*_con_0012.nii$');
            case 'ignore_slow_vs_no_signal_slow'
                data = spm_select('FPList', conmap_dir, '^subj.*_con_0026.nii$');
            case 'stop_as_left' 
                data = spm_select('FPList', conmap_dir, '^subj.*_con_0001.nii$');
            case 'stop_as_right'
                data = spm_select('FPList', conmap_dir, '^subj.*_con_0002.nii$');
            case 'stop_ss'
                data = spm_select('FPList', conmap_dir, '^subj.*_con_0003.nii$');
            case 'ignore_slow_vs_ignore_fast'
                data = spm_select('FPList', conmap_dir, '^subj.*_con_0020.nii$');
            case 'stop_as_left_vs_stop_ss'
                data = spm_select('FPList', conmap_dir, '^subj.*_con_0004.nii$');
            case 'stop_as_right_vs_stop_ss'
                data = spm_select('FPList', conmap_dir, '^subj.*_con_0005.nii$');
        end
        
        % Extract parameter values
        tmp_ds = extract_data_from_roi(data,roi);
        nrow = size(tmp_ds,1);
        
        ds = [ds; [tmp_ds(:,{'iData','roiFileName'}), ... 
                   dataset({repmat(hemi_tag,nrow,1),'roiHemi'}), ...
                   dataset({repmat(con,nrow,1),'conName'}), ...
                   dataset({double(tmp_ds(:,'meanRoiContrastEstimate')),'mean_activation'})
                   ]];
        
    end
end

% Write to disk as csv file
export(ds, ...
       'File', fullfile(output_dir,'functional_roi_mean_contrast_estimates.csv'), ...
       'Delimiter',',')