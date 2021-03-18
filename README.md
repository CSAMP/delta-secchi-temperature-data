# Secchi and Temperature Data
There are two raw datasets for temperature data:

1. The first is the combined delta secchi and temperature data are available in `delta_water_quality_data_with_strata.csv`. This dataset contains the data collected by the CDFW and FWS during Delta fish monitoring programs. The column labeled "Region" contains the model strata identifier.
2. The second dataset is available in the `temp.txt` file and contains the data from DSM hydrodynamic simulations. 

These two temperature datasets are summarized and combined for use in the model. 


## Obtain Secchi and Temperature Data in the Delta

We used the package [deltareportr](https://github.com/sbashevkin/deltareportr) to obtain available delta water quality and saved the results in  `delta_water_quality_data.csv`. See `get_data.R` for more details.


## Digitize Strata and Join to Secchi and Temperature Data
The secchi and temperature data points were assigned their respective strata. This was achieved by digitizing the strata and joining the strata to the data. The strata was referenced from Fig. 2.3.2 from the report "Structured Decision Making for Scientific Management in the San Francisco Bay-Delta" (Peterson et al 2019).

First, a suitable watershed shapefile was identified that closely matched the inferred strata boundaries. The "WBDHU10" shapefile from "USGS National Watershed Boundary Dataset in FileGDB 10.1 format (published 20190628)" was utilized as the template to begin digitizing the strata. This shapefile corresponds to the USGS 5th level watershed classification that has a 10-digit hydrologic unit code. Using the boundaries delineated by the colored streams in Fig. 2.3.2 as a reference, the watershed shapefile was further delineated by splitting regions in GIS to represent the strata. The strata shapefile was used solely for the purpose of the spatial join and did not accurately represent watershed boundaries. The strata shapefile is located in the `subregions` directory.

The map horizontal coordinate system was set to WGS 1984. The secchi and temperature data (`delta_water_quality_data.csv`) was then imported into GIS as point objects to visualize the locations based on the longitude and latitude attributes. Thes strata were spatially joined to each data point that fell within the corresponding strata boundaries. The joined data was then exported to a CSV file named `delta_wq_data_region_joined`. The final file, `delta_water_quality_data_with_strata.csv`, contains the data from `delta_water_quality_data.csv` with the column "Region" overwritten to map to strata within the Rose/Smith et al model.

![](media/digitized_strata_regions.png)

# Methods for Preparing Secchi and Temperature Data for Model Input 

## Secchi Data 

Secchi depth data Secchi<sub>yms</sub> were used as an index of turbidity. Like (Temp)<sup>yms</sup>, Secchi depths for years 
1959-2020 were summarized from all CDFW and FWS databases available online (Fig. 2). Means for each year-month-stratum combination 
were summarized, but data were not available for all strata in all year-months. Missing data were estimated from general linear models
of the remaining Secchi data in other spatial strata. The best general linear model for each stratum was selected using backwards selection, 
beginning with the full model, having a separate coefficient for each spatial stratum, and eliminating non-significant coefficients, one at a time.

## Temperature Data

Water temperature data Temp<sub>yms</sub> for years 1990-2010 were summarized from DSM2 hydrodynamic simulations by Derek Hilts (Fig. 2).
The terminal year of the DSM2 Temp dataset, 2010, limited the number of years available for the delta smelt model by at least 4 years. A second set of
water temperature data was therefore summarized from all available online data collected by the CDFW and FWS during Delta fish 
[monitoring programs](ftp://ftp.dfg.ca.gov/; https://www.fws.gov/lodi/). The second water temperature dataset spanned years 1959-2020, but prior to 2011,
data for some year-month-strata combinations were missing or sparse, with only a single sample.

The water temperatures that would have been simulated by DSM2 for missing years, 2011-2014, were predicted using a general linear model of DSM2 monthly
means Temp<sub>yms</sub> as a function of season, spatial strata, and monthly mean temperatures measured by fish monitoring programs
(Temp)<sup>yms</sup>. The best model of Temp<sub>yms</sub> was identified using backwards selection, starting with a full model, having an effect for
each stratum and season, and eliminating non-significant spatial effects (acceptance level < 0.05), one coefficient at a time, before eliminating
non-significant seasonal effects. The model was fit to data from years 1990-2010, and used to predict Temp<sub>yms</sub> from measured
(Temp)<sup>yms</sup> for years 2011-2014.

