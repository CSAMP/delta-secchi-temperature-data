remotes::install_github("sbashevkin/deltareportr")

library(deltareportr)
library(tidyverse)

Data <- DeltaDater(Start_year = 1900,
                   WQ_sources = c("EMP", "STN", "FMWT", "EDSM", "DJFMP", "SKT",
                                  "20mm", "Suisun", "Baystudy", "USBR", "USGS"),
                   Variables = "Water quality",
                   Regions = NULL)

glimpse(Data)
write_csv(Data, "delta_water_quality_data.csv")