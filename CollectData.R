# Load packages

library(tidyverse)
library(httr)
library(jsonlite)

#Save appid
appid <- 570

#Base URL
url_steam <- 'https://store.steampowered.com/appreviews/'

#Construct API Request
repos <- GET(url = paste0(url_steam,'/',appid,'?json=1?offset'))

#Exmain response components
names(repos)

#Check Status, only 200 is fine
status_code(repos)

#Get Content from Repo
repo_content <- content(repos)

#repo_df <- lapply(repo_content, function(x){
#  df <- data.frame(
#   recommendationID = x$reviews$reviewsrecommendationid,
#  authorID = x$reviews$author$steamid,
# language = x$reviews$language,
#review = x$reviews$review
#)
#})

dfrepo <- as.data.frame(repo_content)
repo_reviews <- repo_content$reviews
repo_reviews <-as.data.frame(repo_reviews)

dfsteamrepo <-list()
while(TRUE){
        num = 20
        steamrepo <-repos <- GET(url = paste0(url_steam,'/',appid,'?json=1?offset=',num))
        print("Offset now is ", num)
        if(status_code(steamrepo)==200){
                steamrepo_content<-content(steamrepo)
                dfsteamrepo <- c(dfsteamrepo,steamrepo_content$reviews)
                num <- num + 20
        }else{
                break
        }
}

## Another approach to collect the data.
dfsteamrepo <-data.frame()
rawReviews <-data.frame()
num = 20
while(num<=100){  #Set limit
        repos<- fromJSON(paste0(url_steam,'/',appid,'?json=1?offset=',num))
        cat("Offset now is", num)
        reviews <- repos$reviews
        flatten(reviews,recursive = TRUE)
        # dfsteamrepo <- c(dfsteamrepo,steamrepo$reviews) 
        rownames(repos$reviews) <-make.names(c(num:(num+19)),unique = TRUE) #Try to solve dumplicate row name issue
        rawReviews <- rbind(rawReviews,repos$reviews)
        num <- num + 20
}
