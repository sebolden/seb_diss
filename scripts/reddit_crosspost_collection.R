library(tidyverse)
library(jsonlite)
library(httr)
library(googlesheets4)

urls <- read_sheet(ss = "https://docs.google.com/spreadsheets/d/1rk61u48hf1IrxrL3lIT3xycz1wM9d1Jchafq3ZB1tOs/edit#gid=740726129", sheet = "crosspost_urls_unique")

urls <- urls %>% filter(!is.na(additional_url)) 

#convert collected urls to json format
urls$json <- paste0(urls$additional_url, ".json") 
urls2 <- urls[801:1422,]

# REMOVE BROKEN LINKS
urls2 <- urls2 %>% filter(json != "https://www.reddit.com/r/fitnesscirclejerk/comments/emdglw/voting_now_open_should_we_ban_unumbski_for/.json")

urls2 <- urls2 %>% filter(json != "https://www.reddit.com/r/fitnesscirclejerk/comments/pg2n92/we_did_it_guys_by_going_private_we_fixed_reddit/.json")

urls2 <- urls2 %>% filter(json != "https://www.reddit.com/r/HeckOffCommie/comments/mcjfnb/lets_gooooooo/.json")
# create subsets to avoid http/404 errors??
#urls1 <- urls[1:200,] # for df1


# function to collect post metadata from json file
getDF <- function(df) {
  
  tmp <- data.frame(      id = df[['id']]
                        , name = df[['name']]
                        , subreddit = df[['subreddit']]
                        , author = df[['author']]
                        , author_flair_text = df[['author_flair_text']]
                        , distinguished = df[['distinguished']]
                        
                        # dates
                        , created = df[['created']]
                        , created_utc = df[['created_utc']]
                        , approved_at_utc = df[['approved_at_utc']]
                        
                        # post content
                        , title = df[['title']]
                        , selftext = df[['selftext']]
                        , link_flair_text = df[['link_flair_text']]
                        
                        # numeric
                        , score = df[['score']]
                        , downs = df[['downs']]
                        , ups = df[['ups']]
                        , upvote_ratio = df[['upvote_ratio']]
                        , num_comments = df[['num_comments']]
                        , total_awards_received = df[['total_awards_received']]
                        , num_crossposts = df[['num_crossposts']]
                        
                        # boolean
                        , edited = df[['edited']]
                        , stickied = df[['stickied']]
                        , locked = df[['locked']]
                        , pinned = df[['pinned']]
                        
                        # links
                        , url = df[['url']]
                        , permalink = df[['permalink']])
  
  return(tmp)
  
}

##########################

df <- data.frame(   id = character()
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


for (i in 1:nrow(urls)) {
  print(paste0("starting step 1 for row #", i))
  tmp_url <- fromJSON(urls$json[i])
  print(paste0("step 1 complete for row #", i))
  print(paste0("starting step 2 for row #", i))
  tmp_data <- tmp_url$data$children[[1]]$data
  print(paste0("step 2 complete for row #", i))
  print(paste0("starting step 3 for row #", i))
  tmp_df <- getDF(tmp_data)
  print(paste0("step 3 complete for row #", i))
  print(paste0("starting step 4 for row #", i))
  df <- rbind(df, tmp_df)
  print(paste0("data successfully collected for row #", i))
}



#####################


df2 <- data.frame(   id = character()
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

for (i in 1:nrow(urls2)) {
  print(paste0("starting step 1 for row #", i))
  tmp_url <- fromJSON(urls2$json[i])
  print(paste0("step 1 complete for row #", i))
  print(paste0("starting step 2 for row #", i))
  tmp_data <- tmp_url$data$children[[1]]$data
  print(paste0("step 2 complete for row #", i))
  print(paste0("starting step 3 for row #", i))
  tmp_df <- getDF(tmp_data)
  print(paste0("step 3 complete for row #", i))
  print(paste0("starting step 4 for row #", i))
  df2 <- rbind(df2, tmp_df)
  print(paste0("data successfully collected for row #", i))
}


write_sheet(df2, ss = "https://docs.google.com/spreadsheets/d/1rk61u48hf1IrxrL3lIT3xycz1wM9d1Jchafq3ZB1tOs/edit#gid=353854741", sheet = "crossposts_801_1422")
