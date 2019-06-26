<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Last-changedate](https://img.shields.io/badge/last%20change-2019--06--26-brightgreen.svg)](https://github.com/bramzandbelt/cnmss/commits/master) [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.6.0-brightgreen.svg)](https://cran.r-project.org/) [![Task DOI](https://zenodo.org/badge/49258308.svg)](https://zenodo.org/badge/latestdoi/49258308) [![Licence](https://img.shields.io/github/license/mashape/apistatus.svg)](http://choosealicense.com/licenses/mit/) [![ORCiD](https://img.shields.io/badge/ORCiD-0000--0002--6491--1247-green.svg)](https://orcid.org/0000-0002-6491-1247)

cnmss - Research compendium for the report on the cognitive and neural mechanisms of selective stopping by Zandbelt & Van den Bosch
===================================================================================================================================

Compendium DOI
--------------

<!-- TODO: Add Zenodo DOI -->
The files at the URL above will generate the results as found in the preprint. The files hosted at <https://github.com/bramzandbelt/cnmss> are the development versions and may have changed since the preprint was published.

Authors of this repository
--------------------------

-   Bram Zandbelt (<bramzandbelt@gmail.com>)
-   Ruben van den Bosch (<r.vandenbosch@donders.ru.nl>)

Published in:
-------------

TBA

<!-- TODO: Add PsyArXiv DOI and Bibliography -->
<!-- ``` -->
<!-- Zandbelt B.B., Van den Bosch R. -->
<!-- Cognitive and neural mechanisms of action- and stimulus-selective stopping -->
<!-- PsyArXiv  -->
<!-- ``` -->
Overview of contents
--------------------

The packagae `cnmss` is one of two research compendia of the research project *Cognitive and Neurobiological Mechanisms of Selective Stopping* by Bram Zandbelt and Ruben van den Bosch (the other research compendium, `irmass`, can be found [here](github.com/bramzandbelt/irmass)). This project was conducted at the Donders Institute, Radboud University, Nijmegen, the Netherlands, and registered at the Donders Centre for Cognitive Neuroimaging under project number 3017031.05 (DCCN PI: Roshan Cools).

This research compendium contains data, code, and text associated with the above-mentioned publication and is organized as follows (showing directories in a tree-like format with a maximum depth of two levels):

    .
    ├── MATLAB
    │   └── spm_batches
    ├── R
    ├── analysis
    │   ├── bash
    │   └── notebooks_and_scripts
    ├── data
    │   ├── derivatives
    │   ├── fmri
    │   └── performance
    ├── documents
    │   ├── content
    │   └── context
    ├── figures
    │   ├── a01_task_performance_analysis
    │   ├── a03_functional_roi_analysis
    │   ├── a04_planned_anatomical_roi_and_whole_brain_analysis
    │   └── a05_exploratory_anatomical_roi_and_whole_brain_analysis
    ├── man
    ├── opt
    │   ├── CorrClusTh
    │   ├── gramm
    │   ├── panel-2.12
    │   ├── plot2svg
    │   └── slice_display
    ├── packrat
    │   ├── lib
    │   ├── lib-R
    │   ├── lib-ext
    │   └── src
    └── reports
        ├── a01_task_performance_analysis
        └── a03_functional_roi_analysis

The `MATLAB/` directory contains:

-   MATLAB code specific to the present project (related to anatomical ROI and whole-brain voxel-wise analyses)

The `R/` directory contains:

-   R code specific to the present project; functions are organized into files (e.g. functions for plotting are in `plot_functions.R`)

The `analysis/` directory contains:

-   R Markdown notebooks implementing the analyses (`notebooks_and_scripts/` directory), numbered in the order in which they should be run;
-   shell scripts running the R Markdown notebooks with appropriate parameters, if any (`bash/` directory).

The `data/` directory contains:

-   the pre-processed performance data (`performance/` directory);
    -   the `tidy_*.csv` files originate from the `irmass` notebook `02_assess_task_performance_criteria`
    -   the `analysis_inputs_*.csv` files originate from the following `irmass` notebooks:
        -   `03_individual_analysis_effect_ssd_on_prob_responding_given_stopsignal`
        -   `08_group_analysis_effect_ssd_on_stoprespond_rt`
-   the relevant anatomical and functional MRI data (`fmri/` directory);
    -   the group-mean T1-weighted anatomical image (`anatomical_images` directory)
    -   the relevant contrast maps for all participants (`contrast_images/` directory)
    -   N.B. the participant-level pre-processed functional and anatomical MRI data are archived at the Donders Institute (project number: 3017051.01)
-   the data derived from the performance and fMRI data (`derivatives/` directory), organized by notebook name.

The `documents/` directory contains:

-   documents describing the content of the experimental data (`content/` directory);
-   documents describing the context of the data (`context/` directory);
-   documents related to the report of this research project (`manuscript/` directory).

The `figures/` directory contains:

-   visualizations of descriptive and inferential statistics, organized by notebook name.

The `man/` directory contains:

-   documentation of R objects inside the package, generated by `roxygen2`.

The `opt` directory contains:

-   MATLAB packages the research compendium depends on, including packages for:
    -   determining cluster-level threshold (`CorrClusTh/`);
    -   making dual-coded images (`slice_display/`);
    -   making multipanel figures (`panel/`);
    -   support for saving panel outputs to SVG (`plot2svg/`).

The `packrat/` directory contains:

-   R packages the research compendium depends on; for more info see <https://rstudio.github.io/packrat/>.

The `reports/` directory contains:

-   static HTML versions of the knitted R Markdown notebooks, organized by notebook name.

Finally, this research compendium is associated with a number of online objects, including:

<table>
<colgroup>
<col width="9%" />
<col width="45%" />
<col width="45%" />
</colgroup>
<thead>
<tr class="header">
<th>object</th>
<th>archived version</th>
<th>development version</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>preregistration</td>
<td><a href="https://osf.io/mq64z/" class="uri">https://osf.io/mq64z/</a></td>
<td>NA</td>
</tr>
<tr class="even">
<td>stimulus presentation code</td>
<td><a href="https://doi.org/10.5281/zenodo.3243799" class="uri">https://doi.org/10.5281/zenodo.3243799</a></td>
<td><a href="github.com/bramzandbelt/StPy" class="uri">github.com/bramzandbelt/StPy</a></td>
</tr>
</tbody>
</table>

How to use
----------

This repository is organized as an R package. The R package structure was used to help manage dependencies, to take advantage of continuous integration for automated code testing and documentation, and to be able to follow a standard format for file organization. The package `cnmss` depends on other R packages and non-R programs, which are listed below under [Dependencies](#Dependencies).

To download the package source as you see it on GitHub, for offline browsing, use this line at the shell prompt (assuming you have Git installed on your computer):

Install `cnmss` package from Github:

``` r
devtools::install_github("bramzandbelt/cnmss")
```

Once the download is complete, open the file `cnmss.Rproj` in RStudio to begin working with the package and compendium files. To reproduce all analyses, run the shell script `analysis/bash/run_all_analyses.sh`. This will run all RMarkdown notebooks and MATLAB scripts in correct order. It may take a while to complete.

Licenses
--------

Manuscript: CC-BY-4.0 <http://creativecommons.org/licenses/by/4.0/>

Code: MIT <http://opensource.org/licenses/MIT>, year: 2019, copyright holders: Bram B. Zandbelt & Ruben van den Bosch

Dependencies
------------

Below is the output of R's function `sessionInfo()`, showing version information about R, the OS, and attached or loaded packages:

``` r
sessionInfo()
#> R version 3.6.0 (2019-04-26)
#> Platform: x86_64-apple-darwin15.6.0 (64-bit)
#> Running under: macOS Mojave 10.14.5
#> 
#> Matrix products: default
#> BLAS:   /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRblas.0.dylib
#> LAPACK: /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRlapack.dylib
#> 
#> locale:
#> [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> loaded via a namespace (and not attached):
#>  [1] compiler_3.6.0  magrittr_1.5    htmltools_0.3.6 tools_3.6.0    
#>  [5] yaml_2.2.0      Rcpp_1.0.1      stringi_1.4.3   rmarkdown_1.13 
#>  [9] knitr_1.23      stringr_1.4.0   xfun_0.7        digest_0.6.19  
#> [13] packrat_0.5.0   evaluate_0.14
```

Packrat takes care of dependencies in R. In addition, Stan (we used v.2.18.1) is needed. Finally, MATLAB R2014b is needed (we used v.8.4.0 150421) and SPM12 (we used v6470) should be on the MATLAB search path (e.g. by adding its path to the file `startup.m`). Other MATLAB packages are located in the `opt/` directory.

Acknowledgment
--------------

This research project was funded through a James McDonnell Scholar Award (grant number 220020328) to Roshan Cools. We thank Roshan Cools (RC) for financial support and constructive feedback and Alexandra Sebastian (AS) for providing statistical parametric maps for the purpose of sample size estimation. We thank Ben Marwick for inspiration on [how to create, organize, and describe research compendia](https://github.com/benmarwick/researchcompendium).

Contributor roles
-----------------

We specify the contribution of all people involved in the research (contributing non-authors included), according to the [Contributor Role Taxonomy](https://www.casrai.org/credit/).

|                              | BBZ | RvdB | RC  | AS  |
|------------------------------|-----|------|-----|-----|
| Conceptualization            | X   | -    | -   | -   |
| Methodology                  | X   | -    | -   | -   |
| Software                     | X   | X    | -   | -   |
| Validation                   | X   | X    | -   | -   |
| Formal analysis              | X   | X    | -   | -   |
| Investigation                | -   | X    | -   | -   |
| Resources                    | X   | -    | -   | X   |
| Data curation                | X   | -    | -   | -   |
| Writing - original draft     | X   | -    | -   | -   |
| Writing - review and editing | X   | X    | -   | -   |
| Visualization                | X   | -    | -   | -   |
| Supervision                  | X   | -    | -   | -   |
| Project administration       | -   | X    | -   | -   |
| Funding acquisition          | -   | -    | X   | -   |

Contact
-------

[Bram B. Zandbelt](mailto:bramzandbelt@gmail.com)
