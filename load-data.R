## Load Kaggle data ----

lap_times <- read_csv("./data/lap_times.csv")
races <- read_csv("./data/races.csv")
circuits <- read_csv("./data/circuits.csv")
drivers <- read_csv("./data/drivers.csv")
results <- read_csv("./data/results.csv")

circuits <- select(circuits, circuitId, name) %>%
  rename(circuit_name = name) %>%
  mutate(circuit_name = str_replace(circuit_name, "Grand Prix ", "")) %>%
  mutate(circuit_name = case_when(circuit_name == 'Istanbul Park' ~ 'Intercity Istanbul Park',
                                  circuit_name == 'Circuit Gilles Villeneuve' ~ 'Circuit Gilles-Villeneuve',
                                  circuit_name == 'Autodromo Nazionale di Monza' ~ 'Autodromo Nazionale Monza',
                                  circuit_name == 'Suzuka Circuit' ~ 'Suzuka International Racing Course',
                                  circuit_name == 'A1-Ring' ~ 'Red Bull Ring',
                                  TRUE ~ circuit_name))

races <- races %>% 
  left_join(circuits, by = "circuitId") %>%
  select(raceId, year, name, circuit_name, url, date) %>%
  rename(race_name = name)

drivers <- drivers %>%
  mutate(driver_name = paste(forename, surname, paste0("(", code, ")"))) %>%
  select(driverId, driver_name, code) %>%
  rename(name_code = code)

## Old races allowed drivers to switch between 1 constructor's vehicles in races
## so we need to dedup to ensure join doesn't blow up
results <- results %>%
  group_by(raceId, driverId) %>%
  summarise(final_position = min(positionOrder))

lap_times <- lap_times %>%
  mutate(lap_time = milliseconds * 0.001) %>%
  left_join(races, by = "raceId") %>%
  left_join(drivers, by = "driverId") %>%
  left_join(results, by = c("raceId", "driverId")) %>%
  rename(lap_position = position) %>%
  select(year, race_name, url, date, circuit_name, driver_name, name_code, lap, lap_time, lap_position, final_position) %>%
  arrange(date, driver_name, lap)


## Load GeoJSON Data ----

f1_circuits <- readOGR("./f1-circuits/f1-circuits.geojson",
                       encoding = "UTF-8", use_iconv = TRUE)
f1_locations <- readOGR("./f1-circuits/f1-locations.geojson",
                        encoding = "UTF-8", use_iconv = TRUE)
