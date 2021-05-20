source("./dependencies.R")
source("./load-data.R")
source("./utils.R")

# Define UI for app that draws a histogram ----
ui <- navbarPage(
  # App title ----
  "Formula 1: Race Summary App",
  
  theme = shinytheme("flatly"),
  
  # Sidebar layout with input and output definitions ----
  tabPanel("Race Visualizations",
    
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
                  selected = "Austrian Grand Prix"),
      # Input: Slider for the driver ----
      selectInput(inputId = "driver",
                  label = "Drivers:",
                  choices = unique(lap_times$driver_name),
                  multiple = TRUE,
                  selected = unique(filter(lap_times, 
                                           race_name == "Austrian Grand Prix",
                                           year == 2020,
                                           final_position <= 3)$driver_name)),
      width = 2
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      fluidPage(
        fluidRow(
          column(6,leafletOutput("world_map")),
          column(6,leafletOutput("circuit_map"))
        ),
        fluidRow(
          column(6,plotlyOutput("lap_times")),
          column(6,plotlyOutput("position"))
        )
      ),
      width = 10
    )
  ),
  tabPanel("About",
           h4("Purpose"),
           "This is for...",
           h4("Sources"),
           "Uses data from...",
           h4("Link to Source Code"))
)