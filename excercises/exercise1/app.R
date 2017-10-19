#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Old Faithful Geyser Data"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId = "bins",
                        label = "Number of bins:",
                        min = 1, 
                        max = 50,
                        value = 30)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot") #,
            #plotOutput("<name>")
        )
    )
)





# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        time_minutes  <- faithful$waiting
        bins <- seq(min(time_minutes), max(time_minutes), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        hist(waiting, breaks = bins, col = 'darkgray', border = 'white')
        
    })
#    output$<name> <- renderPlot({
#        ggplot(faithful[1:input$<name>,], aes(x = eruptions, y = waiting)) + #geom_point()
#    })
}

# Run the application 
shinyApp(ui = ui, server = server)

# 