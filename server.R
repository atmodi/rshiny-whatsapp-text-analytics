#This is RShiny app to create wordcloud for different station and issue
#Click on the "Run App" on top right side to run the app.

#Context: For different issues raised that are resolved by IT team, we are interested in knowing
#the most common type of resolution. FOr e.g in case of printers: restart is the most common resolution
#Don't change the name of files

#Version: 08032017
#Owner: Abhishek Modi (8307)

#define input and output for the shiny app

function(input, output, session) {
  # Define a reactive expression for the document term matrix
  # filedata <- reactive({
  #   infile <- input$file1
  #   if (is.null(infile)) {
  #     # User has not uploaded a file yet
  #     return(NULL)
  #   }
  #   read.csv(infile$datapath)
  # })
  
  terms1 <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        
        getTermMatrix(input$sent)
      #load the function from global.R file
      })
    })
  })
  
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  #set.seed(100)
  output$plot <- renderPlot({
    v <- terms1()
    wordcloud_rep(names(v),v,
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
}