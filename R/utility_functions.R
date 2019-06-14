# ==============================================================================

#' Check whether directories exists, and create recursively if they don't
#'
#' @param all_dirs Character vector of directory paths to check
#' @export
check_dir <- function(all_dirs){

  for (this_dir in all_dirs) {
    if (!dir.exists(this_dir)) {
      dir.create(this_dir, recursive = TRUE)
    }
  }

}


# ==============================================================================

#' Read performance data
#'
#' Data can be of different types (responses, resp; response times, rt) and can
#' serve different purposes (descriptive vs. inferential statistics)
#'
#' @param fl, file path
#' @param data_type, data type ("resp" or "rt")
#' @param stat_type, statistics type ("descriptive" or "inferential")
#' @export
#
read_performance_data <- function(fl, data_type, stat_type) {
  if (data_type == "resp") {

    if (stat_type == "descriptive") {
      readr::read_csv(fl,
                      col_types = readr::cols_only(
                        subjectIx = readr::col_integer(),
                        blockIx = readr::col_integer(),
                        trialIx = readr::col_integer(),
                        trial = readr::col_factor(
                          # N.B. NS at end for plotting purposes
                          levels = c("SL", "SR", "SB", "IG", "NS"),
                          ordered = FALSE),
                        trial_alt = readr::col_factor(
                          levels = c("NS", "SAS", "SSS"),
                          ordered = FALSE),
                        r = readr::col_factor(
                          levels = c("RB", "RL", "RR", "RBO", "RLO", "RRO", "NR", "NOC"),
                          ordered = FALSE),
                        t_d = readr::col_double(),
                        r_bi = readr::col_logical(),
                        trialCorrect = readr::col_logical())
      )


    } else if (stat_type == "inferential") {
      readr::read_csv(fl,
                      col_types = readr::cols_only(
                        subjectIx = readr::col_integer(),
                        trial_alt = readr::col_factor(
                          levels = c("SAS", "SSS"),
                          ordered = TRUE),
                        t_d = readr::col_double(),
                        r_bi = readr::col_logical()
                      )
      )
    }

  } else if (data_type == "rt") {

    if (stat_type == "descriptive") {
      readr::read_csv(fl,
                      col_types = readr::cols_only(
                        subjectIx = readr::col_integer(),
                        blockIx = readr::col_integer(),
                        trialIx = readr::col_integer(),
                        trial = readr::col_factor(
                          # N.B. NS at end for plotting purposes
                          levels = c("SL", "SR", "SB", "IG", "NS"),
                          ordered = FALSE),
                        trial_alt = readr::col_factor(
                          levels = c("NS", "SAS", "SSS"),
                          ordered = FALSE),
                        r = readr::col_factor(
                          levels = c("RB", "RL", "RR", "RBO", "RLO", "RRO", "NR", "NOC"),
                          ordered = FALSE),
                        t_d = readr::col_double(),
                        t_d_alt = readr::col_factor(
                          levels = c("short", "intermediate", "long"),
                          ordered = TRUE),
                        RT_trial = readr::col_double())
      )
    } else if (stat_type == "inferential") {
      readr::read_csv(fl,
                      col_types = readr::cols_only(
                        subjectIx = readr::col_integer(),
                        t_d_alt = readr::col_factor(
                          levels = c("short", "intermediate", "long"),
                          ordered = TRUE),
                        mean_RT = readr::col_double())
      )
    }

  }
}
