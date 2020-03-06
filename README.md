spenv
=====



[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![Build Status](https://travis-ci.org/ropenscilabs/spenv.svg)](https://travis-ci.org/ropenscilabs/spenv)

`spenv` - add environmental data to spatial data

Docs: https://docs.ropensci.org/spenv/

## Package API

* `sp_mutate` - get env data for occ data input - not ready yet
* `sp_extract_gridded` - extract env gridded data
* `sp_extract_pt` - extract env point data
* `sp_query` - query for env data - not ready yet
* `find_locs` - find locations/stations/etc. based on occ data input - internal fxn used in `sp_mutate`

## Data sources

* High priority: There are a set of data sources for environmental data, some of which are high priority as determined by perhaps data quality, coverage, etc. 
    * temperature, chlorophyll, ...
* Available in R: Then there are a set of data sources that are already available in R. 
* We should identify the set of high priority data sources that are not yet available in R, and make them so. 

List of datasources on [Google Sheets](https://docs.google.com/spreadsheets/d/1Ot_HCrsrCJM19cVWz7kSEHipLYd-7WTldJYPDlCCRC4/edit?usp=sharing)

## Use cases

I want data...

* for this bounding box for this temporal range and spatial resolution
* that is of a certain license, because:
    * I want only open data, e.g., CC0
    * I want data I can redistribute
    * I want data that I can purchase or resell

## Install


```r
remotes::install_github("ropenscilabs/spenv")
```


```r
library("spenv")
```

## Example: pt env data


```r
file <- system.file("examples", "obis_mola_mola.csv", package = "spenv")
dat <- read.csv(file)
head(dat)
```


```r
res <- sp_extract_pt(x = dat[1:10,], radius = 100)
res[[1]]
```

## Example: gridded env data


```r
library("spocc")
res <- occ(query = 'Mola mola', from = 'obis', limit = 200)
res_df <- occ2df(res)
out <- sp_extract_gridded(res_df)
head(out)
#> # A tibble: 6 x 8
#>   name    longitude latitude prov  date       key                  lon_adj   sst
#>   <chr>       <dbl>    <dbl> <chr> <date>     <chr>                  <dbl> <dbl>
#> 1 Mola m…      7.73     43.1 obis  2012-06-02 00001054-19a2-441b-…    7.73  20.5
#> 2 Mola m…      4.06     43.4 obis  2012-05-25 0000642b-51de-4042-…    4.06  16.2
#> 3 Mola m…     -2.14     49.2 obis  2001-08-05 000a320e-4e86-4259-…  358.    17.4
#> 4 Mola m…      4.21     43.2 obis  2012-05-25 001099b7-7a24-4072-…    4.21  16.2
#> 5 Mola m…     -2.09     44.4 obis  2012-07-03 0018922a-8b1c-4bb2-…  358.    20.0
#> 6 Mola m…      6.19     42.9 obis  2012-06-27 0018a5aa-d260-4af1-…    6.19  20.5
```

Map it

"map"

## Contributors

* Tom Webb
* Samuel Bosch
* Scott Chamberlain

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/handlr/issues).
* License: MIT
* Get citation information for `handlr` in R doing `citation(package = 'handlr')`
* Please note that this project is released with a [Contributor Code of Conduct][coc].
By participating in this project you agree to abide by its terms.

[coc]: https://github.com/ropenscilabs/spenv/blob/master/CODE_OF_CONDUCT.md
