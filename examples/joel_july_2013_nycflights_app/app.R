#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(tidyverse)
flights <- read_delim(file="data/shinyFlights.csv", delim=",")
jflights <- flights %>% filter(month == 7) %>% select(day,sched_dep_time,carrier,flight,origin, dest_airport_name,distance)


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("New York Flights July 2013"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("distanceInput",
                     "Distance",
                     min = 1,
                     max = 5000,
                     value = c(100,1400), post = " miles"),
      
        radioButtons("airportInput", "Airport", choices = c("EWR", "JFK", "LGA"), selected = "EWR"), 

        selectInput("airlineInput", "Carrier", 
                  choices = c(
                      "American Airlines Inc. (AA)" = "AA",
                      "Alaska Airlines Inc. (AS)" = "AS",
                      "JetBlue Airways (B6)" = "B6" ,
                      "Delta Air Lines Inc. (DL)" = "DL",
                      "ExpressJet Airlines Inc. (EV)" = "EV",
                      "Frontier Airlines Inc. (F9)" = "F9", 
                      "AirTran Airways Corporation (FL)" = "FL",
                      "Hawaiian Airlines Inc.(HA)" = "HA",
                      "Envoy Air (MQ)" = "MQ",
                      "SkyWest Airlines Inc. (OO)" = "OO",
                      "United Air Lines Inc. (UA)" = "UA", 
                      "US Airways Inc. (US)" = "US",
                      "Virgin America (VX)" = "VX",
                      "Southwest Airlines Co. (WN)" = "WN",
                      "Mesa Airlines Inc. (YV)" = "YV"))
   ),
      
      # Show a plot of the generated distribution
      mainPanel(
         h2(textOutput("resultNo")), 
         plotOutput("distancePlot"), #Histogram of the number of flights each carrier offers a certain distance from the three New York Airports
         br(),
         br(),
         tableOutput("selectedFlights") #These are the flights that match the distance and airline chosen
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    filtered <- reactive({
        jflights %>% 
            filter(distance >= input$distanceInput[1],
                   distance <= input$distanceInput[2],
                   origin == input$airportInput,
                   carrier == input$airlineInput)
    })
    
    output$resultNo <- renderText({
        paste("You have",nrow(filtered()),"results.")
        
    })
   
   output$distancePlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      ggplot(filtered(),
             mapping = aes(distance)) +
             geom_histogram()
   })
     
   output$selectedFlights <- renderTable({
       filtered()
   })
}
# Run the application 
shinyApp(ui = ui, server = server)

