#This is RShiny app to create wordcloud 
#Click on the "Run App" on top right side to run the app.


#Owner: Abhishek Modi (8307)

#Context: 


#Creates title panel saying word cloud
fluidPage(
  # Application title
  titlePanel("Word Cloud"),

#creates sidebar to choose file

  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
       fileInput("file1", "Choose CSV File",
                 accept = c(
                   "text/csv",
                   "text/comma-separated-values,text/plain",
                   ".csv")
       ),
      # 
      # selectInput("sent", "Choose the sender",
      #             choices = infile$Sender,multiple = T,selectize = T),
      # 
      
  #ask to update the values
      actionButton("update", "Change"),
      hr(),
 
  
  #slider for selecting minimum and maximum frequency of word count
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 1,  max = 50, value = 15),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 300,  value = 100)
    ),
  

    
    # Show Word Cloud plot
    mainPanel(
      #tableOutput("contents"),
      plotOutput("plot")
    )
  )
)