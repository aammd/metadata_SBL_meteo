# writing EML for the trait table

library(EML)
library(tibble)
library(dplyr)

# set it as physical
physical <- set_physical("sbl_meteo.tsv")


custom_units <- 
  rbind(
  data.frame(id = "micromolePerMeterSquaredPerSecond", 
             unitType = "luminosity", 
             parentSI = "numberPerSquareMeterPerSecond",
             multiplierToSI = 1, 
             description = "number of micromoles of photos per square meter"),
  data.frame(id = "wattsPerMeterSquared", 
             unitType = "luminosity", 
             parentSI = "numberPerSquareMeter",
             multiplierToSI = 1, 
             description = "watts per square meter")
  )

unitList <- set_unitList(custom_units)

## NOTE that until we get some answer from ropensci, it doesn't seem possible to include a custom unit here. using "METER" instead!! 

attributes <- tribble(
  ~ attributeName,                    ~ attributeDefinition,                    ~measurementScale,    ~domain,                     ~numberType,    ~formatString,                  ~ unit,                                    ~definition,                     
  "station",                            "weather station ID",                   "nominal",              "textDomain"     ,          NA,                   NA,                        NA,                                      "the name of the station",      
  "year",                               "Date of sampling",                     "dateTime",             "dateTimeDomain"     ,         NA,                    "YYYY",                         NA,                          NA,  
  "timestamp",                          "time on a 24 hour clock",              "dateTime",             "dateTimeDomain"     ,      NA,                  "YYYY-MM-DDTHH:MM:SS",      NA,                       NA,  
  "wind_speed",                         "the speed the wind",                   "ratio",                "numericDomain"     ,         "real",             NA,                      "metersPerSecond",                        NA,  
  "wind_direction",                     "compass degree of the wind",           "interval",             "numericDomain"     ,         "real",            NA,                           "degree",                             NA,     
  "temperature",                        "temperature of the air",               "interval",             "numericDomain"     ,         "real",           NA,                           "celsius",                             NA,
  "relative_humidity",                  "Relative humidity in percent",         "ratio",                "numericDomain"     ,         "real",            NA,                          "dimensionless",                       NA,  
  "pressure",                           "Air pressure",                         "ratio",                "numericDomain"     ,         "real",            NA,                          "kilopascal",                          NA,  
  "UVB",                                "ultraviolet B radiation",              "ratio",                "numericDomain"     ,         "real",            NA,                          "wattsPerMeterSquared",                                NA,                
  "rain",                               "Rainfall in mm",                       "ratio",                "numericDomain"     ,         "real",            NA,                          "millimeter",                          NA,          
  "soil_temperature",                   "temperature of soil",                  "interval",             "numericDomain"     ,      "real",               NA,                          "celsius",                             NA,           
  "sensor_temp",                        "temperture of UV sensor",              "interval",             "numericDomain"     ,      "real",               NA,                          "celsius",                             NA,                    
  "photosynthesis_active_radiation",    "Photosynthetically active radiation",  "ratio",                "numericDomain"     ,          "real",             NA,                       "micromolePerMeterSquaredPerSecond",                                  NA                                
)            


# year, day, wind , time of day

# create attributes
attributeList <- set_attributes(attributes = attributes)

# #,  col_classes = list("character", "character", "Date",
#                                                                              "numeric","numeric",
#                                                                              "numeric","numeric","numeric","numeric","numeric",
#                                                                              "numeric","numeric","numeric"))
# 



# create dataTable

dataTable <- list(
                 entityName = "sbl_meteo.tsv",
                 entityDescription = "Meterological data collected at the SBL from 2011 to 2016 ",
                 physical = physical,
                 attributeList = attributeList)


# coverage ----------------------------------------------------------------

#c(W 74°00'23"--W 74°00'19"/N 45°59'20"--N 45°59'18")

minlat <- '45.988'
maxlat <- '45.989'
minlon <- '74.006'
maxlon <- '74.005'



 # elevation 362m

sbl <- readr::read_tsv("sbl_meteo.tsv")


# save these to objects and add to coverage

geographicDescription <- "These measurments were collected from a fixed weather station at the Station Biologique des Laurentides, which is the research station of the Université de Montreal"

# as.character(min(sbl$timestamp))
# as.character(max(sbl$timestamp))

# date coverage 
coverage <- 
  set_coverage(begin = "2011-01-01", 
               end = "2017-01-01",
               geographicDescription = geographicDescription,
               west = minlon, east = maxlon, 
               north = maxlat, south = minlat)


# methods -----------------------------------------------------------------

# methods <- set_methods("")


# people ------------------------------------------------------------------

# the example
# "Aaron Ellison <fakeaddress@email.com> [cre]"

# https://orcid.org/0000-0002-2509-4678

the_creator <- person(given = "Roxane", family = "Maranger",email =  "r.maranger@umontreal.ca", role = "cre")
creator <- as_emld(the_creator)

# others <- c(
#   as.person(""),
# )

# associatedParty <- as(others, "associatedParty")

station_address <- list(
                      deliveryPoint = "592, chemin du lac Croche",
                      city = "St-Hippolyte",
                      administrativeArea = "Quebec",
                      postalCode = "J8A 3K9",
                      country = "Canada")

contact <- 
  list(
      individualName = creator$individualName,
      # address = station_address,
      organizationName = "Station Biologique des Laurentides",
      phone = "1 450 563-3111")

publisher <- list(
                 organizationName = "Université de Montreal")

# keywords ----------------------------------------------------------------

keywordSet <-
  list(
    list(
      keywordThesaurus = "LTER controlled vocabulary",
      keyword = list("rainfall",
                  "PAR",
                  "UVB",
                  "temperature")))

# other information -------------------------------------------------------

pubDate <- "2019" 

title <- "Meterological data from the Station Biologique des Laurentides"

abstract <- "This dataset contains measurements of wind, rain, air and soil temperature, relative humitidy, pressure, UVB and photosynthetically active radiation, measured at the Station Biologique des Laurentides outside of Montreal, Canada. Measurements were made every 15 minutes from 01 Jan 2011 to 01 Jan 2017"


intellectualRights <- "This dataset is released to the public and may be freely
downloaded. Please keep the designated Contact person informed of any
plans to use the dataset. Publications and data products
that make use of the dataset must include proper acknowledgement."



# les petits oignons -------------------------------------------------------

dataset <- list(
  title = title,
  creator = creator,
  pubDate = pubDate,
  intellectualRights = intellectualRights,
  abstract = abstract,
  # associatedParty = associatedParty,
  keywordSet = keywordSet,
  coverage = coverage,
  contact = contact,
  # methods = methods,
  dataTable = dataTable)


eml <- list(
           packageId = "0256bb61-dcbc-4046-9d1b-cc1f4cf1bbc0",  # from uuid::UUIDgenerate(),
           system = "uuid", # type of identifier
           dataset = dataset,
           additionalMetadata = list(metadata = list(
             unitList = unitList))
           )
write_eml(eml, "eml.xml")
eml_validate("eml.xml")

