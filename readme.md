# Spanish life expectancy decomposition

This repository contains R code to download and process data from the Spanish Instituto Nacional de Estadistica (INE). The tools used are catched using `renv`, such that the analysis will be exactly reproducible moving forward. These materials have been created for a presentation on reproducible workflows with publicly available data, held 7 June, 2023 for RSS Glagow Local Group.

## Installation

To follow this reproducibility pack, you'll need `R` and `Rstudio`. Both are free and can run on many different OSs. `R` can be installed from:

<https://cran.r-project.org/>

and, `Rstudio` from:

<https://posit.co/download/rstudio-desktop/>

## Setup

You then want to open the main repository folder as an Rstudio project, and then you should be able to follow steps. Some `R` package installation should start automatically when you open the project.

## Analysis steps

The analysis is staged in thematic steps, where each step has a unique R script in the `/code/` folder.

`00_init.R` Run this to install all required packages.

`01_functions.R` defines custom functions. It only contains an expedient life expectancy function.

`02_get_data.R` downloads two files from the INE website, one for underlying cause of death data, another for resident population estimates.

`03_prepare_deaths.R` harmonizes the deaths data, cleaning names, selecting causes, and redistributing deaths of unknown cause. It also contains some ad hoc data diagnostic checks.

`04_prepare_pop.R` harmonizes the population data, cleans names, selecting July 1 reference dates to approximate exposure, and grouping to standard abridged ages `[0,1,5,10,…90,95+]` .

`05_calculate_rates.R` at this time just merges the deaths and exposures data to calculate rates.

`06_calc_e0.R` takes the rates file to calculate life expectancy time series. These are visualized in situ.

`07_decompose.R` does two life expectancy decompositions using the Horiuhci method; first asking which ages and causes explain the life expectancy change from 2000 to 2019, and second which causes explain the change from 2019 to 2020.

`08_visualize.R` makes two simple ridgeplots of the decomposition results.

## Data files

The `/data/` folder contains several artifacts. This folder is delivered populated, but all files can be recreated given the inputs that are read in the file `02_get_data.R`. That means you can begin results reproduction at any stage of processing, but this repository can also be shared without the `/data/` folder to be more lightweight, with no loss. In this case, I recommend archiving the two inputs just in case they one day move. The data manifest is as follows:

`cod.tsv` the cause of death file, as read directly from the INE

`pop.tsv` the population estimates, as read directly from the INE

`deaths_clean.csv` the harmonized deaths file produced in step `03_prepare_deaths.R`

`pop_clean.csv` the harmonized exposures file produces in step `04_prepare_pop.R`

`mort_rates.csv` the mortality rates produced in step `05_calculate_rates.R`

`e0.csv` life expectancy results produced in step `06_calc_e0.R`

`dec2000s.csv` The first decomposition results (2019 vs 2000)

`dec2020s.csv` The second decomposition results (2020 vs 2019)

## Figures

The folder `/figs/` contains two figures of the decomposition results, `fig1.pdf` is the first decomposition, `fig2.pdf` is the second one.
