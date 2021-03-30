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

Secchi depth data Secchi<sub>yms</sub> were used as an index of turbidity. Like Temp<sub>yms</sub>, Secchi depths for years 
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
Temp<sub>yms</sub>. The best model of Temp<sub>yms</sub> was identified using backwards selection, starting with a full model, having an effect for
each stratum and season, and eliminating non-significant spatial effects (acceptance level < 0.05), one coefficient at a time, before eliminating
non-significant seasonal effects. The model was fit to data from years 1990-2010, and used to predict Temp<sub>yms</sub> from measured
Temp<sub>yms</sub> for years 2011-2014.

## Missing Secchi and Temperature Data 

General linear models were developed to predicting missing temperature and turbidity data. The objective of these models was prediction, not inference; therefore, covariate effects were not selected based any particular mechanistic link (e.g., spatial proximity), and the relative effects within each model were not compared. Only explanatory power and model performance was considered.

**Temperature.** DSM2 monthly mean Temp<sub>yms</sub> for years y, 2011-2014, months m, and spatial strata s were predicted as a function of season, spatial strata, and monthly mean temperatures measured by fish monitoring programs Temp<sub>yms</sub>, using a general linear model. Temp<sub>yms</sub> from DSM2 represented a water column mean, while Temp<sub>yms</sub> from monitoring programs represented surface measurements. The relationship between  Temp<sub>yms</sub> and Temp<sub>yms</sub> was expected to vary seasonally, with the onset of thermal stratification as water warmed, and the effect of thermal stratification was expected to vary spatially, as water depth, tidal influence, and stratification vary spatially. Factorial seasonal and strata effects accounted for this spatiotemporal variation in the model to predict missing Temp<sub>yms</sub>.

$$ (1)  Temp_{yms} = \beta_{temp_{0}} + \beta{temp_{1}} * Temp_{yms} +\sum_{j=1}^{n.season} \beta_{Temp_{2}} * Season_{m} +  \sum_{j=1}^{n.st.group_{temp}} \beta_{Temp_{2 + n,season + j}} * St.group_{Temp_{s}} $$

$\beta_{Temp}$ represented coefficents of the general linear model, the quantity $\beta_{temp_{0}} +\sum_{j=1}^{n.season} \beta_{Temp_{2}} * Season_{m} +  \sum_{j=1}^{n.st.group_{temp}} \beta_{Temp_{2 + n,season + j}} * St.group_{Temp_{s}}$ represented a unique intercept for each _s_, and $\beta{temp_{1}} * Temp_{yms}$ scaled fish monitoring temperatures to DSM2 temperatures. Beginning with a full model, having four seasonal effects _Season_<sub>m</sub>, backwards selection was used to combine seasons until _n.season_ groupings remained, with coefficient p-values < 0.05. After selecting seasonal effects, the same process was used to eliminate strata-specific effects. Beginning with a full model, having 12 strata-specific effects _St.grou_<sub>s</sub>, backwards selection was used to combine strata until _n.st.grou_<sub>Temp</sub> groupings remained, with coefficient p-values < 0.05.

**Secchi depth.** Missing Secchi depth measurements Secchi<sub>yms</sub> were also predicted from a general linear model. Since turbidity stratification was not expected to occur and no secondary measurements of Secchi<sub>yms</sub> were available from independent sources, missing Secchi<sub>yms</sub> were predicted using the remaining measurements in other strata.

$$ (2)  Secchi_{ymi} = \beta_{Secchi_{0}} + \sum_{j=1}^{n.st_{Secchi_{i}}} \beta_{Secchi_{j}} * Secchi{ym_{St.group_{Secchi_{ij}}}} $$

for _i_ in the set [Yolo, East Delta, Northeast Suisun]. Backwards model selection was used to eliminate strata-specific effects $\beta_{Secchi}$ until $n.st_{Secchi}$ strata effects remained, with coefficient p-values < 0.05.


