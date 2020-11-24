library(tidyverse)
library(lubridate)

wq <- read_csv("delta_water_quality_data.csv")

glimpse(wq)

unique(wq$Region)

wq_join <- read_csv("delta_wq_data_region_joined.csv") %>% 
  select(-FID:-TARGET_FID) 
names(wq_join) <- names(wq)

write_csv(wq_join, "delta_water_quality_data_with_strata.csv")
glimpse(wq_join)
wq2 <- wq_join %>%
  filter(!is.na(Region))

wq2 %>% 
  filter(Temperature > 0) %>% 
  group_by(month = month(Date), year = year(Date), Region) %>% 
  summarise(mean = mean(Temperature, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(date = ymd(paste(year, month, 1))) %>% 
  ggplot(aes(date, mean)) +
  geom_line() +
  facet_wrap(~Region) +
  labs(y = "monthly mean temp (degC)")

wq2 %>% 
  group_by(month = month(Date), year = year(Date), Region) %>% 
  summarise(mean = mean(Secchi, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(date = ymd(paste(year, month, 1))) %>% 
  ggplot(aes(date, mean)) +
  geom_line() +
  facet_wrap(~Region, scales = "free_y") +
  labs(y = "monthly mean Secchi (ft)")
