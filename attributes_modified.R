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
    data.frame(id = "wattPerMeterSquared", 
               unitType = "luminosity", 
               parentSI = "numberPerSquareMeter",
               multiplierToSI = 1, 
               description = "watts per square meter")
  )

unitList <- set_unitList(custom_units)

attributes <- tribble(
  ~ attributeName,                    ~ attributeDefinition,                   ~formatString,               ~ unit,                                    ~definition,                    ~numberType,
  "station",                            "weather station ID",                       NA,                           NA,                                      "the name of the station",     NA, 
  "year",                               "Date of sampling",                        "YYYY",                      NA,                                       NA,                             NA, 
  "timestamp",                          "time on a 24 hour clock",                "YYYY-MM-DDTHH:MM:SS",      NA,                                       NA,                               NA,
  "wind_speed",                         "the speed the wind",                       NA,                         "metersPerSecond",                        NA,                             "real",
  "wind_direction",                     "compass degree of the wind",               NA,                          "degree",                                 NA,                            "real", 
  "temperature",                        "temperature of the air",                   NA,                           "celsius",                                NA,                           "real", 
  "relative_humidity",                  "Relative humidity in percent",             NA,                          "dimensionless",                          NA,                            "real", 
  "pressure",                           "Air pressure",                             NA,                          "kilopascal",                             NA,                            "real",
  "UVB",                                "ultraviolet B radiation",                  NA,                          "wattPerMeterSquared",                    NA,                            "real",                      
  "rain",                               "Rainfall in mm",                           NA,                          "millimeter",                             NA,                            "real",                
  "soil_temperature",                   "temperature of soil",                      NA,                       "celsius",                                NA,                               "real",              
  "sensor_temp",                        "temperture of UV sensor",                  NA,                       "celsius",                                NA,                               "real",                       
  "photosynthesis_active_radiation",    "Photosynthetically active radiation",      NA,                         "micromolePerMeterSquaredPerSecond",      NA,                              "real"                        
)

# year, day, wind , time of day

# create attributes
attributeList <- set_attributes(attributes = attributes)

# #,  col_classes = list("character", "character", "Date",
#                                                                              "numeric","numeric",
#                                                                              "numeric","numeric","numeric","numeric","numeric",
#                                                                              "numeric","numeric","numeric"))
# 

