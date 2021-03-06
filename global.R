rm(list=ls())
#This is RShiny app to create wordcloud for different reasons
#Click on the "Run App" on top right side to run the app.


#Version: 08032017
#Owner: Abhishek Modi (8307)

rm(list=ls())

library(readr)
library(dplyr)
library(qdap)
library(tm)
library(wordcloud)
library(memoise)
library(dplyr)
library(stringr)
library(readr)

#Whatsapp <- read_csv(input$file1,col_names = F)




# Using "memoise" to automatically cache the results
getTermMatrix <- function(infile) {
  if (is.null(infile)) {
    # User has not uploaded a file yet
    return(NULL)
  }
  location <- infile
  Whatsapp <-  read_csv(location)
  names(Whatsapp) <- c("Date","Text")
  Whatsapp$Time <- substr(Whatsapp$Text,1,8)
  Whatsapp$Text <- substr(Whatsapp$Text,11,nchar(Whatsapp$Text))
  Whatsapp$Sender <- str_trim(substr(Whatsapp$Text,1,unlist(gregexpr(pattern =':.*$',Whatsapp$Text))-1))
  Whatsapp$Text <- substr(Whatsapp$Text,unlist(gregexpr(pattern =':.*$',Whatsapp$Text))+1,nchar(Whatsapp$Text))
  
  Sender <- as.character(unique(Whatsapp$Sender))
  
  # Careful not to let just any name slip in here; a
  # malicious user could manipulate this value.

  #text<- filter(Whatsapp,Sender==sentby)
  text <- select(Whatsapp,"Text")
  text <- text[complete.cases(text),]
  text <- sapply(text, function(x) iconv(enc2utf8(x), sub = "byte"))
  myCorpus = VCorpus(VectorSource(text))
  myCorpus.copy <- myCorpus
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("english")
                      ))
                    # "printer","baggage","scanner",issue,"print","issue","user","report", "reported", "reporting", "reportedly","team", "flight", 
                    #                          "incident","test", "issue", "issues", "done", "open", "please",
                    #                          "the", "impact", "impacting", "impacted", "resolve", "resolution", "resolved",
                    #                          "ticket", "queue", "queued", "cause", "caused", "causing", "investigated", "investigating",
                    #                          "investigate", "work", "worked", "working", "thank", "thanked", "thanking", "manage", "managing",
                    #                          "managed","now","greenwichuniversal","flight","delay","problem","hi","process", "processes", "processed", "find", 
                    #                          "found", "tested", "testing", "end", "ended"))
                    # 
  #mycorpus=tm_map(myCorpus,stemCompletion,dictionary=myCorpus.copy)
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength =c(0,Inf)))
  
  m = as.matrix(myDTM)
  
 sort(rowSums(m), decreasing = TRUE) #returns the value to function
}
