#install.packages("RedditExtractoR")

library(tidyverse)
library(RedditExtractoR)
library(googlesheets4)

gs4 <- "https://docs.google.com/spreadsheets/d/1rk61u48hf1IrxrL3lIT3xycz1wM9d1Jchafq3ZB1tOs/edit#gid=1315772545" # google sheet URL

urls <- read_sheet(ss = gs4, sheet = "post_urls")

reddit_thread <- data.frame()

#loop that collects comments from each thread link 

i <- 1

for (val in urls$url) {
  print(i)
  dat <- get_thread_content(val)
  dat <- dat$comments
  reddit_thread <- rbind(reddit_thread, dat)
  i <- i + 1
}

sheet_write(reddit_thread, ss = gs4, sheet = "comments")
