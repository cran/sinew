## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(sinew)

## ----results='hide'-----------------------------------------------------------
pkg_dir <- file.path(tempdir(),'pkg')
pkg_dir_r <- file.path(pkg_dir, 'R')

usethis::create_package(path = pkg_dir, open = FALSE)
withr::with_dir(pkg_dir, usethis::use_data_raw(open = FALSE))
withr::with_dir(pkg_dir, usethis::use_mit_license(copyright_holder = "John Doe"))
withr::with_dir(pkg_dir, usethis::use_roxygen_md())


## -----------------------------------------------------------------------------
example_file <- system.file('example.R', package = 'sinew')


## -----------------------------------------------------------------------------
untangle(
  file = example_file, 
  dir.out = pkg_dir_r, 
  dir.body = file.path(pkg_dir, 'data-raw')
)


## ----results='hide'-----------------------------------------------------------
pretty_namespace(pkg_dir_r,overwrite = TRUE)

## -----------------------------------------------------------------------------
make_import(script = pkg_dir_r,format = 'description')

## -----------------------------------------------------------------------------
sinew::update_desc(path = pkg_dir_r, overwrite = TRUE)

## ---- echo = FALSE------------------------------------------------------------
details::details(file.path(pkg_dir,'DESCRIPTION'), summary = 'Click to see DESCRIPTION file',lang = '')

## -----------------------------------------------------------------------------
#single file
make_import(script = file.path(pkg_dir_r,'yy.R') ,format = 'oxygen')

## -----------------------------------------------------------------------------
#whole directory
make_import(script = pkg_dir_r,format = 'oxygen')

## -----------------------------------------------------------------------------
#with cut
make_import(script=file.path(pkg_dir_r,'yy.R'),format = 'oxygen', cut = 1)

## -----------------------------------------------------------------------------
unlink(pkg_dir, recursive = TRUE, force = TRUE)

