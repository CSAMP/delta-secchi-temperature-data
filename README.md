# Secchi and Temperature Data

Delta secchi and temperature data are available in `delta_water_quality_data_with_strata.csv`. The column labeled "Region" contains the model strata identifier.

## Obtain Secchi and Temperature Data in the Delta

We used the package [deltareportr](https://github.com/sbashevkin/deltareportr) to obtain available delta water quality and saved the results in  `delta_water_quality_data.csv`. See `get_data.R` for more details.

The [deltareportr](https://github.com/sbashevkin/deltareportr) documentation gives the following data sources for the water quality variables, pulled from the [discretewq](https://github.com/sbashevkin/discretewq/) package:
* "EMP" (Environmental Monitoring Program)
* "STN" (Summer Townet Survey)
* "FMWT" (Fall Midwater Trawl)
* "EDSM" (Enhanced Delta Smelt Monitoring)
* "DJFMP" (Delta Juvenile Fish Monitoring Program)
* "20mm" (20mm Survey)
* "SKT" (Spring Kodiak Trawl)
* "Baystudy" (Bay Study)
* "USGS" (USGS San Francisco Bay Surveys)
* "USBR" (United States Bureau of Reclamation Sacramento Deepwater Ship Channel data)
* "Suisun" (Suisun Marsh Fish Study)

See the [Delta Smelt Anual Conditions Report](https://sbashevkin.github.io/deltareportr/Delta_Smelt_conditions_report_2019.html#recent-publications) for more information on raw data.

## Digitize Strata and Join to Secchi and Temperature Data
The secchi and temperature data points were assigned their respective strata. This was achieved by digitizing the strata and joining the strata to the data. The strata was referenced from Fig. 2.3.2 from the report "Structured Decision Making for Scientific Management in the San Francisco Bay-Delta" (Peterson et al 2019).

First, a suitable watershed shapefile was identified that closely matched the inferred strata boundaries. The "WBDHU10" shapefile from "USGS National Watershed Boundary Dataset in FileGDB 10.1 format (published 20190628)" was utilized as the template to begin digitizing the strata. This shapefile corresponds to the USGS 5th level watershed classification that has a 10-digit hydrologic unit code. Using the boundaries delineated by the colored streams in Fig. 2.3.2 as a reference, the watershed shapefile was further delineated by splitting regions in GIS to represent the strata. The strata shapefile was used solely for the purpose of the spatial join and did not accurately represent watershed boundaries. The strata shapefile is located in the `subregions` directory.

The map horizontal coordinate system was set to WGS 1984. The secchi and temperature data (`delta_water_quality_data.csv`) was then imported into GIS as point objects to visualize the locations based on the longitude and latitude attributes. Thes strata were spatially joined to each data point that fell within the corresponding strata boundaries. The joined data was then exported to a CSV file named `delta_wq_data_region_joined`. The final file, `delta_water_quality_data_with_strata.csv`, contains the data from `delta_water_quality_data.csv` with the column "Region" overwritten to map to strata within the Rose/Smith et al model.

![](media/digitized_strata_regions.png)
