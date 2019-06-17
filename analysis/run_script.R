require(tidyverse)
require(irmass)
library(cnmss)

# Provides access to a copy of the command line arguments, which specifies what to do
args <- commandArgs(TRUE)

# Get index of notebook to render to identify notebook filename
notebook_ix <- as.integer(args[1])

notebook_file <-
  switch(notebook_ix,
         "1" = "a01_task_performance_analysis.Rmd",
         "2" = "",
         "3" = "a03_functional_roi_analysis.Rmd"
         )

# Define input dir (notebook_templates_dir) and output dir (reports_dir)
notebook_dir <- "analysis"
reports_dir <- "reports"

# Create non-existing dirs if they don't exist
irmass::check_dir(all_dirs = c(notebook_dir, reports_dir))

# Reports are not parameterized ------------------------------------------------
params_tibble <- NULL


# Render notebook into static HTML file ----------------------------------------
irmass::render_notebook(notebook_file = notebook_file,
                             notebook_dir = notebook_dir,
                             reports_dir = reports_dir,
                             params_tibble = params_tibble,
                             force = TRUE)

