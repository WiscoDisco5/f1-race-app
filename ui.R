source("./dependencies.R")
source("./load-data.R")
source("./utils.R")

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Formula 1: Race Summary Tool"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the race year ----
      selectInput(inputId = "year",
                  label = "Year:",
                  choices = 2010:2020,
                  multiple = FALSE,
                  selected = 2020),
      # Input: Slider for the race ----
      selectInput(inputId = "race",
                  label = "Race:",
                  choices = unique(lap_times$race_name),
                  multiple = FALSE,
                  selected = "Australian Grand Prix"),
      # Input: Slider for the driver ----
      selectInput(inputId = "driver",
                  label = "Driver:",
                  choices = unique(lap_times$driver_name),
                  multiple = TRUE,
                  selected = "Australian Grand Prix")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      leafletOutput("world_map"),
      leafletOutput("circuit_map"),
      plotlyOutput("lap_times"),
      plotlyOutput("position")
      
      
    )
  )
)