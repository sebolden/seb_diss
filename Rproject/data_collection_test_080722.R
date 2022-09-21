library(tidyverse)
library(jsonlite)
library(httr)
library(googlesheets4)

urls <- read.csv("./urls.csv", header = T, stringsAsFactors = F)
urls$json <- paste0(urls$url, ".json")

# test_url <- fromJSON("https://www.reddit.com/r/announcements/comments/a50ns/introducing_rblog_and_rannouncements/.json")
# tst1 <- test_url$data$children[[1]]$data
# tst2 <- test_url$data$children[[2]]$data
# names(tst2)

df <- data.frame(  id = character()
                 , name = character()
                 , subreddit = character()
                 , author = character()
                 , author_flair_text = character()
                 , distinguished = character()
                 
                 # dates
                 , created = character()
                 , created_utc = character()
                 , approved_at_utc = character()
                 
                 # post content
                 , title = character()
                 , selftext = character()
                 , link_flair_text = character()
                 
                 # numeric
                 , score = numeric()
                 , downs = numeric()
                 , ups = numeric()
                 , upvote_ratio = numeric()
                 , comms_num = numeric()
                 , num_comments = numeric()
                 , total_awards_received = numeric()
                 , num_crossposts = numeric()
                 
                 # boolean
                 , edited = logical()
                 , stickied = logical()
                 , locked = logical()
                 , pinned = logical()
                 
                 # links
                 , url = character()
                 , permalink = character()
                 )

getDF <- function(df1) {
  
  tmp <- data.frame(    id = df1[['id']]
                      , name = df1[['name']]
                      , subreddit = df1[['subreddit']]
                      , author = df1[['author']]
                      , author_flair_text = df1[['author_flair_text']]
                      , distinguished = df1[['distinguished']]
                      
                      # dates
                      , created = df1[['created']]
                      , created_utc = df1[['created_utc']]
                      , approved_at_utc = df1[['approved_at_utc']]
                      
                      # post content
                      , title = df1[['title']]
                      , selftext = df1[['selftext']]
                      , link_flair_text = df1[['link_flair_text']]
                      
                      # numeric
                      , score = df1[['score']]
                      , downs = df1[['downs']]
                      , ups = df1[['ups']]
                      , upvote_ratio = df1[['upvote_ratio']]
                      , num_comments = df1[['num_comments']]
                      , total_awards_received = df1[['total_awards_received']]
                      , num_crossposts = df1[['num_crossposts']]
                      
                      # boolean
                      , edited = df1[['edited']]
                      , stickied = df1[['stickied']]
                      , locked = df1[['locked']]
                      , pinned = df1[['pinned']]
                      
                      # links
                      , url = df1[['url']]
                      , permalink = df1[['permalink']])
    
  return(tmp)
                      
}

for (i in 1:nrow(urls)) {
  tmp_url <- fromJSON(urls$json[i])
  tmp_data <- tmp_url$data$children[[1]]$data
  tmp_df <- getDF(tmp_data)
  df <- rbind(df, tmp_df)
}

write_sheet(df, ss = "https://docs.google.com/spreadsheets/d/1gVpvXqG6HkqFwDfN59BwiuFCGJ7NPEOLB3Q1_xGCkLg/edit#gid=0", sheet = "Sheet1")


# ADD IS_CROSSPOSTABLE???????





















