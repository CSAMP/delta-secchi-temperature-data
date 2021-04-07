library(readr)
library(tidyverse)

# Load in secchi temp data and water year rda from waterYearType repo 
secchi_temp <- read_csv("delta_water_quality_data_with_strata.csv") 
filtered_temp <- secchi_temp %>% 
  mutate(water_year = ifelse(Month >= 8, Year + 1, Year)) %>% 
  filter(Region == c("Yolo Bypass", "South Delta")) %>% glimpse() 

load("~/Git/delta-secchi-temperature-data/frequency_exceeding_temps/water_year_indices.rda") 

water_years <- water_year_indices %>% filter(location == "Sacramento Valley") %>%
  select(water_year = WY, water_year_type = Yr_type) %>% na.omit() %>% glimpse()

# Join them together
# Select strata and find proportion exceeding in march and april 
temp_with_wy <- filtered_temp %>%
  left_join(water_years) %>%
  group_by(water_year, water_year_type, Region) %>%
  summarise(march_above_15 = sum(Month == 3 & Temperature > 15)/sum(Month == 3), 
            april_above_17 = sum(Month == 4 & Temperature > 17)/sum(Month == 4)) %>%
  select(water_year, water_year_type, march_above_15, april_above_17, strata = Region) %>% na.omit()

#write_csv(temp_with_wy, "frequency_exceeding_temps/cache_slough_temp_exceeding_thresholds.csv")
write_csv(temp_with_wy, "frequency_exceeding_temps/cache_slough_strata_temp_exceeding_thresholds.csv")
# Checks a few months to see if proportion exceeding match up 
# explore_temp <- filtered_temp %>% filter(Year == 2008, Month == 4) %>% mutate(above_17 = sum(Temperature > 17)/n())
