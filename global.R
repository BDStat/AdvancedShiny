library(ggvis)
library(dplyr)
library(RSQLite)
library(ggplot2)

# get data
attach("C:\\cuny\\2017Spring\\df.Rda")

axis_vars <- c(
  "score" = "score",
  "rating" = "rating",
  "review_count" = "review_count"
)
