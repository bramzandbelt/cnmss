#' Test of stop-respond RT vs. stop-signal delay for group-level data
#'
#' @param df data frame
#' @export
test_effect_ssd_on_srrt_grp <- function(df) {

  # Tibble for output
  bf_output <- tibble::tibble(mdl_class = character(),
                              mdl = character(),
                              B = numeric(),
                              log10_B = numeric(),
                              error = numeric(),
                              label = character()
  )

  # BayesFactor packages cannot handle tibbles, so convert to data frame
  df <-
    df %>%
    as.data.frame(.)

  # Compute Bayes factor for full model
  if ('trial_alt' %in% colnames(df)) {
    B_full_vs_null <-
      BayesFactor::anovaBF(mean_RT ~ t_d_alt*trial_alt + subjectIx,
                           data = df,
                           whichRandom = "subjectIx",
                           rscaleFixed = get_bf_settings('rscale')
      )
  } else {
    B_full_vs_null <-
      BayesFactor::anovaBF(mean_RT ~ t_d_alt + subjectIx,
                           data = df,
                           whichRandom = "subjectIx",
                           rscaleFixed = get_bf_settings('rscale')
      )
  }

  # Fill in tibble
  for (mdl in rownames(B_full_vs_null@bayesFactor)) {
    bf_output <- tibble::add_row(bf_output,
                                 mdl_class = "null_vs_full",
                                 mdl = mdl,
                                 B = 1 / exp(B_full_vs_null[mdl]@bayesFactor$bf),
                                 log10_B = log10(1 / exp(B_full_vs_null[mdl]@bayesFactor$bf)),
                                 error = B_full_vs_null[mdl]@bayesFactor$error,
                                 label = cut(1 / exp(B_full_vs_null[mdl]@bayesFactor$bf),
                                             breaks = get_bf_settings('breaks'),
                                             labels = get_bf_settings('labels')
                                 )
    )
  }

  bf_output
}
