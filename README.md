spenv
=====

[![Build Status](https://travis-ci.org/sckott/spenv.svg)](https://travis-ci.org/sckott/spenv)

`spenv` - add environmental data to spatial data

See the [Wiki](https://github.com/sckott/spenv/wiki) for some documentation.

Package API:

* `sp_mutate` - get env data for occ data input - not ready yet
* `sp_extract_gridded` - extract env gridded data
* `sp_extract_pt` - extract env point data
* `sp_query` - query for env data - not ready yet
* `find_locs` - find locations/stations/etc. based on occ data input - internal fxn used in `sp_mutate`

## Install


```r
devtools::install_github("ropensci/spenv")
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
```

```
## Assuming 'longitude' and 'latitude' are longitude and latitude, respectively
```

```r
head(out)
```

```
##         name longitude  latitude prov       date       key lon_adj   sst
## 4  Mola mola   -67.000  45.09908 obis 2013-08-19 267605308 113.000 16.66
## 8  Mola mola   -58.000  40.96667 obis 1986-02-14 267605048 122.000  0.46
## 19 Mola mola    -8.273  55.26500 obis 1995-07-21 249600046 171.727  8.58
## 20 Mola mola   173.450 -39.73330 obis 1981-12-07 265201106 353.450 13.21
## 21 Mola mola   172.810 -40.62330 obis 1983-01-26 265087487 352.810 12.64
## 23 Mola mola   172.000 -52.10000 obis 1982-04-17 265202514 352.000  1.82
```

Map it

"map"

## Contributors

* Tom Webb
* Samuel Bosch
* Scott Chamberlain

## Meta

* Please [report any issues or bugs](https://github.com/sckott/spenv/issues).
* License: MIT
