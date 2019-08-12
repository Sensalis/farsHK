context("make_filename")

test_that("make_filename_classtest", {
  expect_that(make_filename(2013), is_a("character"))
})
