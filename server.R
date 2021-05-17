# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$world_map <- renderLeaflet({
    
    plot_world_map(input$race, input$year)

  })
  
  output$circuit_map <- renderLeaflet({
    
    plot_circuit_map(input$race, input$year)
    
  })
  
  output$lap_times<- renderPlotly({
    
    plot_lap_times(input$race, input$year, input$driver)
    
  })
  
  output$position<- renderPlotly({
    
    plot_position(input$race, input$year, input$driver)
    
  })
  
}