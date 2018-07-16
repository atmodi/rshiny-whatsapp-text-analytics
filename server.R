#This is RShiny app to create wordcloud for reasons
#Click on the "Run App" on top right side to run the app.

#Context: 

#Version: 08032017
#Owner: Abhishek Modi 

#define input and output for the shiny app

function(input, output, session) {
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    infile <- input$file1
    getTermMatrix(infile$datapath)
    })
   
  
  
  
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  #set.seed(100)
  output$plot <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v),v,
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
}