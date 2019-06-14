#' plot_roi_data ###############################################################
#' Plots region of interest data, including activation levels and Bayes Factors
#'
#' @param df, data frame containing the data
#' @export
plot_roi_data <- function(df, ylm = c(-10,10)) {

  colorbar <- irmass::get_bf_colorbar_vars()

  # Main variables (x, y, group) -----------------------------------------------
  ggplot2::ggplot(data = df,
                  ggplot2::aes(x = Hemisphere,
                               y = mean_activation,
                               group = interaction(ROI,Hemisphere,contrast))) +

    # Facets  --------------------------------------------------------------------
  ggplot2::facet_grid(contrast ~ ROI, labeller = "label_parsed") +

    # Geoms  ---------------------------------------------------------------------
    ggplot2::geom_tile(ggplot2::aes(fill = BF01),
                       width = 1,
                       height = Inf) +

    ggplot2::geom_hline(yintercept = 0,
                        color = "black") +

    ggplot2::geom_hline(yintercept = dplyr::setdiff(seq(2*round(ylm[1]/2),
                                                        2*round(ylm[2]/2),
                                                        2),0),
                        color = "white",
                        size = 0.2) +

    ggbeeswarm::geom_quasirandom(fill = NA,
                                 shape = 1, # shape = 42, size = 6
                                 size = 1) +

    ggplot2::geom_text(ggplot2::aes(label = irmass::fancy_scientific(BF01)),
                        y = ylm[1],
                        size = 2,
                        parse = TRUE
                        ) +


    # Summary stats  -------------------------------------------------------------
    ggplot2::stat_summary(fun.y = "mean",
                          geom = "point",
                          shape = 21,
                          size = 1.5,
                          stroke = 1,
                          color = "white",
                          fill = "black") +

    # Scales  --------------------------------------------------------------------

    ggplot2::scale_fill_gradient2(midpoint = 0,
                                  # Colorblind-friendly colors
                                  low = "#91bfdb",
                                  mid = "#ffffbf",
                                  high = "#fc8d59",
                                  # name = expression(log['10'](B['01'])),
                                  name = expression(B['01']),
                                  breaks = colorbar$breaks,
                                  labels = parse(text = colorbar$labels),
                                  # labels = colorbar$labels,
                                  limits = colorbar$limits,
                                  trans = 'log10',
                                  oob = scales::squish,
                                  guide = "colourbar"
    ) +

    ggplot2::scale_y_continuous(name = 'Contrast estimate (a.u.)',
                                limits = ylm) +
    # Themes  --------------------------------------------------------------------
    irmass::theme_irmass() +
    ggplot2::theme(panel.spacing = ggplot2::unit(0.05, "cm"),
                   legend.position = "right",
                   legend.text = ggplot2::element_text(size = 5),
                   axis.text.x = ggplot2::element_text(angle = 0,
                                                       hjust = 0.5
                                                       )
                   )

}

#' plot_trial_proportion_descriptives ##########################################
#' Descriptive statistics plot of trial proportions
#'
#' The tibble `tbl` should have the following columns
#' - subjectIx <int> subject index
#' - trial <fct> trial (levels: "no-signal", "stop-left", "stop-right", "stop-both", "ignore")
#' - t_d <dbl> signal delay
#' - r_type <fct> response type (levels: "bimanual", "unimanual", "no", "other")
#' - accuracy <chr> accuracy ("correct" or "error")
#' - n <int> trial number, given subjectIx, trial, r_type, and accuracy
#' - n_trial <int> total trial number, given subjectIx and trial
#' - prop <dbl> proportion of trials belinging to r_type and accuracy combination
#'
#' @param tbl, tibble containing data
#' @export
plot_trial_proportion_descriptives <- function(tbl) {
  plt_trial_proportion_descriptives <-
    ggplot2::ggplot(data = tbl,
                    mapping = ggplot2::aes(x = t_d,
                                           y = prop,
                                           color = accuracy,
                                           linetype = r_type)
    ) +
    ggplot2::facet_grid(. ~ trial) +

    # Geoms ----------------------------------------------------------------------
    ggbeeswarm::geom_quasirandom(mapping = ggplot2::aes(group = interaction(subjectIx, r_type, accuracy)),
                                 alpha = 0.1,
                                 dodge.width = 0.1,
                                 shape = 1) +

    ggplot2::geom_smooth(method = "loess", se = FALSE) +

    # Scales ---------------------------------------------------------------------
    ggplot2::scale_x_continuous(name = expression(t[d] (s)),
                                breaks = c(0,0.25, 0.50)) +
    ggplot2::scale_y_continuous(name = "Proportion",
                                breaks = seq(0,1,0.5)) +
    ggplot2::scale_color_manual(name = "Accuracy",
                                values = c("#0000FF", "#FF0000")) +
    ggplot2::scale_linetype_manual(name = "Response type",
                                   values = c("solid", "dotted", "dotdash", "11")) +

    # Themes ---------------------------------------------------------------------
    ggplot2::theme_minimal() +
    ggplot2::theme(aspect.ratio = 0.61,
                   legend.box = "vertical",
                   legend.direction = "vertical",
                   legend.position = "right")
}

#' plot_trial_rt_descriptives ##################################################
#' Descriptive statistics plot of trial response times
#'
#' The tibble `tbl` should have the following columns
#'
#' - subjectIx <int> subject index
#' - trial <fct> trial (levels: "no-signal", "stop-left", "stop-right", "stop-both", "ignore")
#' - RT_trial <dbl> response time (for bimanual responses: mean of both hands)
#' - r_type <fct> <fct> response type (levels: "bimanual", "unimanual", "no", "other")
#' - accuracy <chr> accuracy ("correct" or "error")
#'
#' @param tbl, tibble containing data
#' @export
plot_trial_rt_descriptives <- function(tbl) {
  ggplot2::ggplot(data = tbl ,
                  mapping = ggplot2::aes(x = RT_trial,
                                         color = accuracy,
                                         linetype = r_type
                                         )
                  ) +
    ggplot2::facet_grid(. ~ trial) +

    # Geoms --------------------------------------------------------------------
    ggplot2::stat_ecdf(mapping = ggplot2::aes(group = interaction(subjectIx, trialCorrect, r_type)),
                       alpha = 0.2,
                       size = 0.25,
                       na.rm = TRUE) + # Stop-both trials have missing RTs
    ggplot2::stat_ecdf(mapping = ggplot2::aes(group = interaction(trialCorrect, r_type)),
                       alpha = 1,
                       size = 0.5,
                       na.rm = TRUE) + # Stop-both trials have missing RTs

    # Scales -------------------------------------------------------------------
    ggplot2::scale_x_continuous(name = "Time (s)",
                                breaks = seq(0,1.5,0.5)) +
    ggplot2::scale_y_continuous(name = "P(RT < Time)",
                                breaks = seq(0,1,0.5)) +
    ggplot2::scale_color_manual(name = "Accuracy",
                                values = c("#0000FF", "#FF0000")) +
    ggplot2::scale_linetype_manual(name = "Response type",
                                   values = c("solid", "dotted")) +

    # Themes -------------------------------------------------------------------
    ggplot2::theme_minimal() +
    ggplot2::theme(aspect.ratio = 0.61,
                   legend.box = "vertical",
                   legend.direction = "vertical",
                   legend.position = "right")


}

#' plot_mcmc_analysis ##########################################################
#' Plots graphical diagnostics of MCMC chains (for models fit with brms)
#'
#' @param mdl, brmsfit object
#' @export
plot_mcmc_analysis <- function(mdl) {
  mdl_long <- ggmcmc::ggs(mdl)

  # Trace plot
  plt_trace <-
    ggmcmc::ggs_traceplot(mdl_long) +
    ggplot2::facet_wrap("Parameter") +
    irmass::theme_irmass() +
    ggplot2::theme(legend.position = "bottom",
                   axis.text.x = ggplot2::element_text(angle = 90,
                                                       hjust = 1))

  # Plot of Rhat
  plt_rhat <-
    ggmcmc::ggs_Rhat(mdl_long) +
    irmass::theme_irmass()

  return(list(plt_trace, plt_rhat))
}

#' plot_p_r_bi_fit #############################################################
#' Plots probability of responding bimanually plus predictions from the best-fitting model
#'
#' @param obs, tibble containing observed probability of responding given a signal
#' @param posterior_fit, output from tidybayes::add_fitted_draws for best-fitting model
#' @param t_d_pos, scaled t_d values (for positioning tick labels)
#' @export
plot_p_r_bi_fit <- function(obs, posterior_fit, t_d_pos) {

  ggplot2::ggplot(data = posterior_fit,
                  mapping = aes(x = t_d,
                                y = p_r_bi,
                                color = trial_alt)) +

    # Geoms ----------------------------------------------------------------------

    ggbeeswarm::geom_quasirandom(data = obs,
                                 alpha = 0.1,
                                 dodge.width = 0.1) +

    ggplot2::stat_summary(mapping = ggplot2::aes(group = interaction(subjectIx, trial_alt)),
                          fun.y = "mean",
                          geom = "line",
                          alpha = 0.1) +

    ggplot2::stat_summary(mapping = ggplot2::aes(group = interaction(trial_alt)),
                          fun.y = "mean",
                          geom = "line",
                          size = 1) +

    ggplot2::stat_summary(data = tidy_resp_data_inf_grp,
                          mapping = ggplot2::aes(group = interaction(trial_alt)),
                          fun.y = "mean",
                          geom = "point",
                          size = 3) +

    # Scales ---------------------------------------------------------------------
    ggplot2::scale_x_continuous(breaks = t_d_pos,
                                labels = c(0.066, 0.166, 0.266, 0.366, 0.466)) +

    ggplot2::scale_color_brewer(palette = "Dark2", labels = c("action-selective",
                                                              "stimulus-selective")) +

    # Labels and annotations  ----------------------------------------------------
    ggplot2::labs(x = "Delay (s)",
                  y = "P(bimanual response|stop-signal)")  +

    # Themes ---------------------------------------------------------------------
    irmass::theme_irmass() +

    # Some adjustments to the standard theme
    ggplot2::theme(aspect.ratio = 1/1.61,
                   legend.justification=c(0,1),
                   legend.position=c(0,1),
                   legend.background = ggplot2::element_blank(),
                   legend.title=ggplot2::element_blank())

}

#' plot_stop_respond_rt ########################################################
#' Plots mean stop-response response time as a function of delay category and selective stopping type
#'
#' @param tbl, tibble containing the data
#' @export
plot_stop_respond_rt <- function(tbl) {

  ggplot2::ggplot(data = tbl,
                  mapping = ggplot2::aes(x = as.numeric(t_d_alt),
                                         y = mean_RT,
                                         color = trial_alt)) +

    # Geoms ----------------------------------------------------------------------

  ggbeeswarm::geom_quasirandom(alpha = 0.1,
                               dodge.width = 0.1) +

    # Participant-level data (transparent, thin lines)
    ggplot2::geom_line(mapping = ggplot2::aes(group = interaction(subjectIx, trial_alt)),
                       alpha = 0.2,
                       size = 0.25) +

    # Group-level data (opaque, thick lines)
    ggplot2::stat_summary(mapping = ggplot2::aes(group = trial_alt),
                          fun.y = "mean",
                          geom = "line",
                          size = 1,
                          na.rm = TRUE) +

    # Scales ---------------------------------------------------------------------
  ggplot2::scale_x_continuous(labels = c("short", "intermediate", "long"),
                              breaks = c(1,2,3),
                              limits = c(.8,3.2)) +
    ggplot2::expand_limits(y = 0) +

    ggplot2::scale_color_brewer(palette = "Dark2") +

    # Annotations ----------------------------------------------------------------

  ggplot2::labs(x = "Delay category",
                y = "Stop-respond response time (s)") +

    # Themes ---------------------------------------------------------------------

  irmass::theme_irmass() +

    # Some adjustments to the standard theme
    ggplot2::theme(aspect.ratio = 1/1.61,
                   legend.position = "none")

}



