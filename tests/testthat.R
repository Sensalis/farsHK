library(testthat)

test_that("make_filename", {
  expect_that(make_filename(2013), is_a("character"))
})
