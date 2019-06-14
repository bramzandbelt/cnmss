# !/bin/bash
#
# run_all_analyses.sh

# Define some general variables ================================================

# Run analysis of task performance (in R) ======================================
sh analysis/bash/a01_r_task_performance_analysis.sh

# Extract mean contrast estimates from functional ROIs (in MATLAB) =============
sh analysis/bash/a02_extract_mean_contrast_estimates_from_functional_rois.sh

# Functional ROI analyses (in R) ===============================================
sh analysis/bash/a03_functional_roi_analysis.sh

# Planned anatomical ROI and whole-brain voxel-wise analyses (in MATLAB) =======
sh analysis/bash/a04_planned_anatomical_roi_and_whole_brain_analysis.sh

# Exploratory anatomical ROI and whole-brain voxel-wise analyses (in MATLAB) ===
sh analysis/bash/a05_exploratory_anatomical_roi_and_whole_brain_analysis.sh
