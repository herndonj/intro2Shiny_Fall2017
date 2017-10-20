library(shiny)
library(tidyverse)
bcl <- read_csv("bcl-data.csv")

# The entire UI is basically passing in comma-separated arguments
ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100, value= c(25, 40), pre = "$"),
    radioButtons("typeInput", "Product type", choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"), selected = "WINE"), 
    selectInput("countryInput", "Country", 
                choices = c("CANADA", "FRANCE", "ITALY"))
    ),
    mainPanel(
      h2(textOutput("resultNo")),
      plotOutput("coolplot"), #This shows a graph that we are creating
      br(), br(),
      tableOutput("results") # This is going to show a data table of results
    )
  )
)

server <- function(input, output) {
  filtered <- reactive({
    bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput)
  })

  output$resultNo <- renderText({
#    filtered <-
#      bcl %>%
#      filter(Price >= input$priceInput[1],
#             Price <= input$priceInput[2],
#             Type == input$typeInput,
#             Country == input$countryInput
#      )
    paste("You have",nrow(filtered()),"results.")
   
})
  output$coolplot <- renderPlot({
#    filtered <-
#      bcl %>%
#      filter(Price >= input$priceInput[1],
#             Price <= input$priceInput[2],
#             Type == input$typeInput,
#             Country == input$countryInput
#      )
    ggplot(filtered(), aes(Alcohol_Content)) +
      geom_histogram()
})
  output$results <- renderTable({
#    filtered <-
#      bcl %>%
#      filter(Price >= input$priceInput[1],
#             Price <= input$priceInput[2],
#             Type == input$typeInput,
#             Country == input$countryInput
#      )
    filtered()
  })
}
shinyApp(ui = ui, server = server)


