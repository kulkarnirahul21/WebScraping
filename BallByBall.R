setwd("C:/Users/Rahul.Kulkarni/Desktop/R/T20")
require('XML')
require('RCurl')
library(stringr)
data2<-read.csv("links.csv",header=T,sep=',',dec='.',stringsAsFactors=FALSE)
x<-nrow(data2)
for(i in 1:x){
  url<-as.character(data2[i,]) 
  SOURCE <-  getURL(url,encoding="UTF-8")
  PARSED <- htmlTreeParse(SOURCE, useInternalNodes = TRUE)
  acom=(xpathSApply(PARSED, "//*/div[@class='commentary-event']",xmlValue))
  if(length(acom) > 0 ){
    data<-as.data.frame(acom)
    temp <- acom
    temp <- gsub(pattern=",", replacement="", x=temp)
    temp <- strsplit(x=temp, split="\n")
    temp <- temp[sapply(temp, length) != 4]
    temp <- lapply(X=temp, FUN=`[`, c(2, 4, 5, 6))
    temp <- lapply(X=temp, FUN=str_trim)
    temp <- data.frame(temp)
    #if(ncol(temp)==4){
    temp <- data.frame(t(temp), stringsAsFactors=FALSE)
    rownames(temp) <- NULL
    colnames(temp) <- c("Balls", "temp", "Runs", "Comments")
    temp$Bowling <- sapply(X=strsplit(x=temp$temp, split=" to "), FUN=`[`, 1)
    temp$Batting <- sapply(X=strsplit(x=temp$temp, split=" to "), FUN=`[`, 2)
    temp$temp <- NULL
    temp$Comments <-NULL
    temp$PageURL <- url
    write.table(temp, file = 'BallByBall.csv',sep = ",",append=TRUE,row.names=FALSE,col.names=FALSE)
    #write.csv(temp, "BallByBall.csv", row.names=FALSE)
  }else{
    write.table(url, file = 'Nocom.csv',sep = ",",append=TRUE,row.names=FALSE,col.names=FALSE)
  }
}
