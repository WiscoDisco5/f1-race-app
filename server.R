# Define server logic required ----
server <- function(input, output, session) {
  
  ## Plots
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
  
  ## Update selections per user selections
  observe({
    
    races <- unique(filter(lap_times, year == input$year)$race_name)
    
    updateSelectInput(session, "race",
                      choices = races,
                      selected = races[1]
    )
  })
  
  observe({
    
    drivers <- lap_times %>%
      filter(year == input$year,
             race_name == input$race) %>%
      select(driver_name, final_position)
    
    updateSelectInput(session, "driver",
                      choices = drivers$driver_name,
                      selected = filter(drivers, final_position <= 3)$driver_name
    )
  })
  
}