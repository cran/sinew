## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- echo = FALSE------------------------------------------------------------
if(file.exists('../reference/figures/Guy-Tangled-in-Lights.jpg')){
  knitr::include_graphics('../reference/figures/Guy-Tangled-in-Lights.jpg', dpi = 100)
}else{
  knitr::include_graphics('../man/figures/Guy-Tangled-in-Lights.jpg', dpi = 100)
}

## -----------------------------------------------------------------------------
library(sinew)


## -----------------------------------------------------------------------------
pkg_dir <- file.path(tempdir(),'pkg')
usethis::create_package(path = pkg_dir, open = FALSE)
withr::with_dir(pkg_dir, usethis::use_data_raw(open = FALSE))
withr::with_dir(pkg_dir, usethis::use_mit_license(copyright_holder = "John Doe"))
withr::with_dir(pkg_dir, usethis::use_roxygen_md())

## -----------------------------------------------------------------------------
withr::with_dir(pkg_dir,fs::dir_tree())

## -----------------------------------------------------------------------------

example_file <- tempfile(fileext = '.R',tmpdir = file.path(pkg_dir, 'data-raw'))

example_lines <- "#some comment
yy <- function(a=4){
  head(runif(10),a)
  # a comment
}

zz <- function(v=10,a=8){
  head(runif(v),a)
}


yy(6)

zz(30,3)
"

cat(example_lines,file = example_file)


## -----------------------------------------------------------------------------
pkg_dir_R <- file.path(pkg_dir,'R')
sinew::untangle(file = example_file,
                dir.out = pkg_dir_R, 
                dir.body = file.path(pkg_dir, 'data-raw'))

## -----------------------------------------------------------------------------
withr::with_dir(pkg_dir,fs::dir_tree())

## ---- echo = FALSE------------------------------------------------------------
details::details(file.path(pkg_dir, 'data-raw','body.R'), summary = 'Click to see body.R')

## ---- echo = FALSE------------------------------------------------------------
details::details(file.path(pkg_dir_R,'yy.R'), summary = 'Click to see yy.R')

## ---- echo = FALSE------------------------------------------------------------
details::details(file.path(pkg_dir_R,'zz.R'), summary = 'Click to see zz.R')

## -----------------------------------------------------------------------------
sinew::pretty_namespace(pkg_dir_R,overwrite = TRUE)

## -----------------------------------------------------------------------------
sinew::sinew_opts$set(markdown_links = TRUE)

## -----------------------------------------------------------------------------
sinew::makeOxyFile(input = pkg_dir_R, overwrite = TRUE, verbose = FALSE)

## ---- echo = FALSE------------------------------------------------------------
details::details(file.path(pkg_dir_R,'yy.R'), summary = 'Click to see yy.R')

## ---- echo = FALSE------------------------------------------------------------
details::details(file.path(pkg_dir_R,'zz.R'), summary = 'Click to see zz.R')

## -----------------------------------------------------------------------------
sinew::make_import(pkg_dir_R,format = 'description',desc_loc = pkg_dir)

## -----------------------------------------------------------------------------
new_yy <- "#some comment
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param a numeric, set the head to trim from random unif Default: 4
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \\dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \\code{\\link[utils]{head}}
#'  \\code{\\link[stats]{runif}}
#' @rdname yy
#' @export 
#' @author Jonathan Sidi
#' @importFrom utils head
#' @importFrom stats runif
yy <- function(a=4,b=2){
  x <- utils::head(stats::runif(10*b),a)
  stats::quantile(x,probs=.95)
  # a comment
}"


cat(new_yy, file = file.path(pkg_dir_R,'yy.R'))


## -----------------------------------------------------------------------------
moga(file.path(pkg_dir_R,'yy.R'),overwrite = TRUE)

## ---- echo = FALSE------------------------------------------------------------
details::details(file.path(pkg_dir_R,'yy.R'), summary = 'Click to see yy.R')

## -----------------------------------------------------------------------------

r_env_vars <- function () {
    vars <- c(R_LIBS = paste(.libPaths(), collapse = .Platform$path.sep), 
        CYGWIN = "nodosfilewarning", R_TESTS = "", R_BROWSER = "false", 
        R_PDFVIEWER = "false")
    if (is.na(Sys.getenv("NOT_CRAN", unset = NA))) {
        vars[["NOT_CRAN"]] <- "true"
    }
    vars
}

withr::with_envvar(r_env_vars(), roxygen2::roxygenise(pkg_dir))

## ----eval=interactive()-------------------------------------------------------
#  check_res <- rcmdcheck::rcmdcheck(path = pkg_dir, args = '--as-cran',quiet = TRUE)

## ----echo=FALSE,eval=interactive()--------------------------------------------
#  details::details(check_res,summary = 'Check Results', open = TRUE)

## -----------------------------------------------------------------------------
unlink(pkg_dir, recursive = TRUE, force = TRUE)

