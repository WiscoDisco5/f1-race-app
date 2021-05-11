## Load Kaggle data ----

lap_times <- read_csv("./data/lap_times.csv")
races <- read_csv("./data/races.csv")
drivers <- read_csv("./data/drivers.csv")
results <- read_csv("./data/results.csv")

races <- races %>%
  select(raceId, year, name) %>%
  rename(race_name = name)

drivers <- drivers %>%
  mutate(driver_name = paste(forename, surname)) %>%
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
  select(year, race_name, driver_name, name_code, lap, lap_time, lap_position, final_position)


## Load GeoJSON Data ----

f1_circuits <- readOGR("./f1-circuits/f1-circuits.geojson",
                       encoding = "UTF-8", use_iconv = TRUE)
f1_locations <- readOGR("./f1-circuits/f1-locations.geojson",
                        encoding = "UTF-8", use_iconv = TRUE)
