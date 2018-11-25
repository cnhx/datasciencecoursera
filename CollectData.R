# Load packages

library(tidyverse)
library(httr)
library(jsonlite)
library(plyr)
library(dplyr)

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

dfsteamrepo <-data.frame()
rawReviews <-data.frame()
num = 20
while(num<=1000000){  #Set limit
        repos<- fromJSON(paste0(url_steam,'/',appid,'?json=1?offset=',num))
        cat("Offset now is", num)
        cat("\n")
        reviews <- repos$reviews
        flatten(reviews,recursive = TRUE)
        # dfsteamrepo <- c(dfsteamrepo,steamrepo$reviews) 
        rownames(repos$reviews) <-make.names(c((num-19):num),unique = TRUE) #Try to solve dumplicate row name issue
        rownames(repos$reviews$author)<-make.names(c((num-19):num),unique = TRUE)
        rawReviews<- rbind(rawReviews,repos$reviews)
        num <- num + 20
}

##Write data to a txt file
write.table(rawReviews,"./rawData.txt", sep="\t")



