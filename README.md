# Mayor’s Office - Interactive Homelessness Operations Planner and Tracker 

## About

In the past year, Los Angeles County residents have passed two measures to combat homelessness (Measure H and Measure HHH). As the City seeks to administer the new funds at its disposal, it will face the challenge of having to prioritize areas of the city with high-concentrations of unsheltered homelessness, public safety incidents, and community complaints, as well as areas of high danger or health risks for the homeless community. Although current City and County data related to homelessness are vast, they are also dispersed, making it difficult for Mayor’s Office decision-makers to address the full scope or magnitude of homelessness, while prioritizing service delivery needs. 

The main objective of this project is to collect, clean, and use geospatial analysis and predictive modeling to quantify need, demand, and potential impact of different homelessness intervention strategies. The creation of new measures (e.g. indices, coefficients, risk scores) will help the Mayor’s office better determine the concentration of homeless individuals over time, as well as understand the health/human service needs of particular geographies (e.g. the Los Angeles river).

Deliverables will be integrated into an online mapping application that will enable Mayor’s office staff to evaluate and track the effects of existing and upcoming homelessness interventions, and providing a framework to consider policy trade-offs that would accompany different rapid service delivery alternatives.  This mapping tool will allow Mayor’s office staff to analyze data in a more holistic and standardized manner and facilitate the rapid deployment of resources and services.

Additionally, with the current CENTCOM focus on El Pueblo, this tool will seek to assist in real-time impact evaluation of current priority areas and support future real-time evaluation efforts. 

In addition, the mapping tool will incorporate data and functionality to support expected future City efforts to combat homelessness:

* Locate suitable City property for temporary/permanent service centers, shelter, and housing

* Identify populations at risk for future homelessness

## Sponsors

Miguel Sangalang / Amanda Daflos / Dan Caroselli  - Los Angeles Mayor’s Office, Budget and Innovation

Jeanne Holm - ITA

## Partners

USC Data Sciences and Operations, Professor Abbass Sharif 

## City Team

Brian Buchner - Mayor’s Office, Operations and Implementation Lead

Alisa Orduna - Mayor’s Office, MOEO Project Manager

Alex Pudlin - Mayor’s Office, MOBI Project Manager

Sari Ladin - Mayor’s Office, GeoHub/Open Data Lead

Brendan Bailey - Mayor’s Office, Principal Data Liaison 

Hunter Owens - ITA, General Project Manager/University Liaison

## Goals

*General City Homelessness Goals*

* *Support the Mayor’s goal to reduce unsheltered Angelenos by 50% in five years.*

*Project Goals*

* Clean and merge homelessness-related datasets from disparate sources with automation scripts

* Develop a measure to estimate homelessness density in a given area by combining PIT counts, LAPD/LAFD incident reports, 311 calls, Bureau of Sanitation homelessness encampments, LAHSA El Pueblo weekly census, and HMIS data

* Develop a measure to estimate health and safety risk for homeless communities or discrete geographic regions based on homelessness density measure (see above), LAPD/LAFD incident reports, heat and weather-related indices, areas susceptible to flooding, fire, or other natural emergencies, Bureau of Sanitation homelessness encampments, and HMIS data.

* Combine the count and risk measures into an interactive measure that responds to user input, allowing the user to specify count weight vs. risk weight and a geographic boundary.

* Determine where existing and potential resources are located.

* Allow users to create custom geographies that will return an estimated count of homeless individuals, services, encampments, and risk factors within the boundaries.

* Build a focused reporting mechanism for El Pueblo and future key areas.

* Develop students’ understanding of homelessness, its impact on the City of Los Angeles, and the current/planned City policies to address homelessness. 

*Additional Phase 2 goals*

* Create a public support measure to help determine communities most likely to be receptive to new service centers/permanent supportive housing.

* Develop a framework to track homelessness migration patterns by year, by season

## Deliverables

* Cleaned and merged homelessness-related datasets from disparate sources with automation scripts

* Aggregate measure(s) to estimate count/homeless concentration based on variables within PIT count data, 311 complaints, Cleanstat, LAPD incidents, and any other relevant datasets. The measurement should apply at the block level but will also aggregate to higher geographies, specifically Census Tract, Zip Code, Community Plan Area, Council District, and customizable geographies (phase 2). 

* Aggregate measure(s) to estimate need/health and safety risk based on existing risk indices and variables including environmental indicators, service concentration, homeless population concentration, areas susceptible to weather extremes (heat factor, flooding, fire), and encampment concentration.

* [To be completed by City Staff] Interactive mapping application and dashboard that will include aggregate measures, raw data, and additional contextual layers. The map will also include tools that allow the user to manipulate inputs to generate priority areas for rapid service delivery. Said application will develop in sprints, with each component added as modules to a single framework.

* Dashboard and impact measurements for El Pueblo and current CENTCOM priority areas. 

Deliverables will follow this basic pipeline:

Step 1. SOURCE (raw data)

Step 2. CLEANING/ANALYSIS (Python/R)

Step 3. GeoSpatial layer (R or ArcGIS Online/[ArcGIS API for Python](https://developers.arcgis.com/python/))

Step 4. Integration with single mapping application (ArcGIS Online/[ArcGIS API for JS)](https://developers.arcgis.com/javascript/) [City Staff]

Step 5. Integration with City’s GeoHub [City Staff] 

## Data Sources

*Contextual research*

* [City of Los Angeles Homelessness strategy](https://www.lamayor.org/comprehensive-homelessness-strategy)

* [LAHSA homelessness count methodology, research, and more](https://www.lahsa.org/homeless-count/)

*Publically available*

* LAHSA PIT count tabular data

    * [201](https://www.lahsa.org/documents?id=1495-homeless-count-2017-results-by-census-tract.xlsx)[7](https://www.lahsa.org/documents?id=1495-homeless-count-2017-results-by-census-tract.xlsx)

    * [2016](https://www.lahsa.org/homeless-count/reports)

    * [2015](https://www.lahsa.org/homeless-count/reports)

* [LAHSA PIT count geospatial data](http://geohub.lacity.org/datasets/607614502e93482fa80e5b9b5b4c3267_0)

* [City funds related to homelessness](https://controllerdata.lacity.org/Audits-and-Reports/Funds-Relating-to-Housing-and-Homelessness/3bze-bz36)

* [311 call data (multiple formats)](https://data.lacity.org/A-Well-Run-City/311-Homeless-Encampments-Requests/az43-p47q)

* [Shelters and services](http://geohub.lacity.org/datasets/7be554e5802c4d65b1f5b430639e41bb_158) (shapefile)

* Los Angeles County parcel data (multiple formats)

    * [Parcel change file](https://data.lacounty.gov/Parcel-/Assessor-Parcel-Change-File/qju6-wpwm)

    * [Parcels 2017 tax roll](https://data.lacounty.gov/GIS-Data/Parcels-2017-Tax-Roll/aszk-cppu)

* Los Angeles crime details with victim detail (multiple formats; note - homeless victims ID’d with an MO code of 1218

    * [Homeless victims Aug 2016- Aug 2017](https://data.lacity.org/A-Safe-City/Crime-Homeless-Victim-8-16-8-17/djbj-9vsp)

* [City zoning](http://geohub.lacity.org/datasets/e6ba3bcca10e4e64a51f4f58e73b20bd_0)

*City data (to be provided)*

* Los Angeles City Attorney encampment data (shapefile)*

* Los Angeles River encampment data (shapefile)*

*We have current access to a sample of these data as of September 2017. Mayor’s Office will work with data owners to obtain full and updated data sets.

* Bureau of Sanitation Cleanstat encampment data (shapefile)

* Vacant Los Angeles City-owned property data (shapefile)

* HOPE encampments (shapefile)

* LAFD electronic Patient Care Records (e-PCR) data (.csv/excel)

    * *We have it to 100 block level. Based on terms of use, we can’t use this layer on a Google Satellite map.

* LAHSA El Pueblo Census Data

*Not yet available*

* LAHSA HMIS system data (format: tbd)

* Potential private data sources (e.g. CoStar, REIS) to show commercial or multifamily vacancy

* LAHSA outreach data (format: tbd)

*Already consolidated/aggregated data *(to be provided)

* Internal index measuring homelessness concentration using LAPD, LAHSA PIT counts, Cleanstat/encampment data, and 311 calls (.csv/excel)

* Combined LAHSA/BOS encampment PIT hot spot/cold spot clusters (shapefile)

* Existing homelessness exploration map (ESRI web app) and underlying layers

## Possible Phases

1: Data research, literature review

2: Data collection, cleaning, and blending

3: Index creation/model to estimate current homeless population, starting with the El Pueblo population as a pilot. 

3a: Creation of measure

3b: Creation of GeoSpatial layer

4: Index creation/model of need/health and vulnerability scale

4a: Creation of measure

4b: Creation of GeoSpatial layer

4c: Incorporation into central tool

5: Curation of additional contextual layers such as neighborhood characteristics, City properties, service locations.

6: El Pueblo dashboard creation

Future sprints:

7: Creation of migration measurements/framework for future data collection

	- Identification of suitable data for longitudinal tracking

	- Creation of migration measure - current and future if additional data collection necessary.

	- Dashboard creation
	
	- Incorporation into main mapping tool

8: Creation of widget/tool that allows user to draw geographic boundaries and see a summary of estimated homelessness count, available services, and risk indicators.

9: Creation of widget/tool that allows user to specify parameters, including two main measurements (count and risk) to generate custom hotspots.

