#' Check data has required columns.
#'
#' @param data The tracking data to check for required columns.
#' @param names_needed The names expected.
#'
#' @return
wat_check_data <- function(data,
                           names_expected = c("x", "y", "time")) {

  # get the colmumn names
  data_names <- colnames(data)

  purrr::walk(names_expected, function(nr) {
    assertthat::assert_that(nr %in% data_names,
                            msg = glue::glue("wat_check_data: {nr} is
                         required but missing from data!"))
  })
}
