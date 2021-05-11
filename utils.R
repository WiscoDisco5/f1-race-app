## Maps ----

plot_world_map <- function(circuit_name) {
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

plot_circuit_map <- function(circuit_name) {
  # filter to track
  selected_circuit <- subset(f1_circuits, Name == circuit_name)
  
  # leaflet map
  selected_circuit %>%
    leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolylines(color = '#FF1801', opacity = 0.8)
}

# plot_world_map(circuit_name = "Marina Bay Street Circuit")
# plot_circuit_map("Marina Bay Street Circuit")

## Timing Plots
