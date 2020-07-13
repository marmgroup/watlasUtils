context("distance function")
testthat::test_that("simple distance works", {

  # make test positions
  testdf <- tibble::tibble(a = 1,
                           b = 1:100,
                           time = 1:100)
  # run function with custom col names
  testoutput <- watlastools::wat_simple_dist(testdf, x = "a", y = "b")
  # do tests
  # should return as many elements as nrows in df
  testthat::expect_equal(length(testoutput), nrow(testdf),
                         info = "distances returned are not same length
                                 as data provided")
  # test that the first element is NA
  testthat::expect_identical(testoutput[1], as.double(NA),
                             info = "first distance is not NA")
  # test that the vector class is numeric or double
  testthat::expect_type(testoutput, "double")
  # test that the distances except first are 1 in this case
  testthat::expect_identical(testoutput, c(NA, rep(1.0, 99)),
                             info = "the distance calculation is wrong")

})

testthat::test_that("simple distance is correct", {
  testdata <- data.table::fread("../testdata/whole_season_tx_435.csv")[1:1000, ]

  # distance using custom fun
  test_distances <- watlastools::wat_simple_dist(testdata,
                                            x = "X", y = "Y",
                                            time = "TIME")

  # distance using sf
  data_sf <- sf::st_as_sf(testdata,
                          coords = c("X", "Y"))
  sf::st_crs(data_sf) <- 32631

  sf_distance <- sf::st_distance(data_sf$geometry[seq_len(nrow(data_sf) - 1)],
                                 data_sf$geometry[-1], by_element = T)

  sf_distance <- as.numeric(c(NA, sf_distance))

  testthat::expect_equal(test_distances, sf_distance)
})
