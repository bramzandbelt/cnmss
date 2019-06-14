# ==============================================================================

#' Batch-render analysis notebooks
#'
#' @param notebook_file filename of the template notebook to be run
#' @param notebook_dir directory where the template notebook resides
#' @param reports_dir directory where reports are written
#' @param params_tibble tibble of parameter values with which to run the notebooks
#' @param force whether or note to rerun a notebook when it exists
#' @export
render_notebook <- function(notebook_file, notebook_dir = "analysis", reports_dir = "reports", params_tibble, force = FALSE) {

  # Check if notebook_dir and reports_dir exist, create them if they don't
  irmass::verify_output_dirs()
  cnmss::check_dir(all_dirs = c(notebook_dir, reports_dir))

  # Parse notebook file
  notebook_path <-
    file.path(notebook_dir, notebook_file)
  notebook_fileparts <-
    stringr::str_split(notebook_file, pattern = "\\.", simplify = TRUE)
  notebook_filename <-
    notebook_fileparts[1:length(notebook_fileparts) - 1]
  notebook_ext <-
    notebook_fileparts[-1]

  # Assertions
  assertthat::assert_that(file.exists(notebook_path),
                          msg = stringr::str_c("Notebook '",
                                               notebook_path,
                                               "' does not exist.")
  )

  yaml_params <-
    rmarkdown::yaml_front_matter(input = notebook_path)$params



  for (i_row in 1:nrow(params_tibble)) {

    # Parameters to override in the YAML frontmatter of notebook
    run_params <-
      params_tibble %>%
      dplyr::slice(i_row) %>%
      as.list()

    suffix_str <- c(pid_str, task_str, model_str, pmz_str, bound_str, algorithm,
                    max_iter, rel_tol, n_pop_per_free_param, optim_str, vis_str)

    nonempty_str <- stringr::str_length(suffix_str) > 0
    suffix_str <- stringr::str_flatten(suffix_str[nonempty_str], collapse = "_")
    suffix_str <- stringr::str_c(suffix_str, ".html")

    report_file <- stringr::str_c(notebook_filename, ".html")
    report_path <- file.path(reports_dir, report_file)

    # Render notebook only if report does not exist or if forced
    if (!file.exists(report_path) | force) {
      tryCatch(rmarkdown::render(input = notebook_path,
                                 output_dir = reports_dir,
                                 output_file = report_file,
                                 knit_root_dir =
                                   rprojroot::find_root(rprojroot::has_file("DESCRIPTION"))
      ),
      error = function(e) {
        message(e)
        message(sprintf("Failed to render notebook for participant %d.",
                        run_params$participant_id)
        )

      }
      )

    }
  }

}
