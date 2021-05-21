## Maps ----

get_circuit_name <- function(plot_race_name, plot_year) {
  unique(filter_race_data(plot_race_name = plot_race_name, plot_year = plot_year)$race_data$circuit_name)
}

# get_circuit_name("Singapore Grand Prix", 2019)

plot_world_map <- function(plot_race_name, plot_year) {
  
  circuit_name <- get_circuit_name(plot_race_name = plot_race_name, plot_year = plot_year)
  
  # filter to track
  selected_location <- subset(f1_locations, name == circuit_name)
  
  # leaflet map
  content <- paste(sep = '<br/>', 
                   paste0('<b>', selected_location$name, '</b>'),
                   selected_location$location,
                   paste("Opened:", selected_location$opened),
                   paste("First GP:", selected_location$firstgp),
                   paste0("Length: ", selected_location$length, "m"),
                   paste0("Altitude: ", selected_location$alt, "m")
                   )
  
  selected_location %>%
    leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addMarkers() %>%
    addPopups(popup = content,
              options = popupOptions(closeOnClick = FALSE)) %>%
    setView(0,0,2)
  
}

plot_circuit_map <- function(plot_race_name, plot_year) {
  
  circuit_name <- get_circuit_name(plot_race_name = plot_race_name, plot_year = plot_year)
  
  # filter to track
  selected_circuit <- subset(f1_circuits, Name == circuit_name)
  
  # leaflet map
  selected_circuit %>%
    leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolylines(color = '#FF1801', opacity = 0.8)
}

# plot_world_map("Singapore Grand Prix", 2019)
# plot_circuit_map("Singapore Grand Prix", 2019)

## Timing Plots

filter_race_data <- function(plot_race_name, plot_year, drivers = NULL) {
  race_data <- lap_times %>%
    filter(year == plot_year,
           race_name == plot_race_name) %>%
    mutate(name_place = str_pad(paste(final_position, "-", name_code), 8, side = "left"))
  
  number_of_drivers <- length(unique(race_data$name_place))
  
  if (is.null(drivers)) {
    list(race_data = race_data, number_of_drivers = number_of_drivers)
  } else {
    filter(race_data, driver_name %in% drivers) %>%
      list(race_data = ., number_of_drivers = number_of_drivers)
  }
  
} 

plot_lap_times <- function(plot_race_name, plot_year, drivers = NULL) {
  filter_race_data(plot_race_name = plot_race_name,
                   plot_year = plot_year,
                   drivers = drivers)$race_data %>%
    plot_ly(data = .,
            x = ~lap, 
            y = ~lap_time, 
            type = 'scatter', 
            mode = 'lines+markers',
            color = ~name_place) %>%
    layout(title = paste("Lap Time over Lap Number by Driver:", plot_year, plot_race_name),
           xaxis = list(title = "Lap Number"),
           yaxis = list(title = "Lap Time (seconds)"),
           hovermode = "x unified")
}

# plot_lap_times("Australian Grand Prix", 2015, drivers = c("Lewis Hamilton (HAM)"))

plot_position <- function(plot_race_name, plot_year, drivers = NULL) {
  race_data <- filter_race_data(plot_race_name = plot_race_name,
                   plot_year = plot_year,
                   drivers = drivers) 
  
  race_data$race_data %>%
    plot_ly(data = .,
            x = ~lap, 
            y = ~lap_position, 
            type = 'scatter', 
            mode = 'lines+markers',
            color = ~name_place) %>%
    layout(title = paste("Position over Lap Number by Driver:", plot_year, plot_race_name),
           xaxis = list(title = "Lap Number"),
           yaxis = list(title = "Position (rank)",
                        autorange = "reversed",
                        tickvals = 1:race_data$number_of_drivers),
           hovermode = "x unified")
}

# plot_position(plot_race_name = "Singapore Grand Prix", plot_year = 2019, drivers = c("Lewis Hamilton (HAM)", "Sebastian Vettel (VET)"))
