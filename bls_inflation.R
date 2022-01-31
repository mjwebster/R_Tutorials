

#https://www.bls.gov/developers/

#register for an API key
#store it in environ by editing R_environ and call it "bls_api" (all lowercase)

#an API key allows you to access what is called "version 2" of the API. Mainly this allows you to make a greater number of calls

#install blsAPI package, which is a wrapper for easier access to the BLS API
#documentation is not great, however
#https://github.com/mikeasilva/blsAPI


#devtools library needs to be loaded before installing the package
#library(devtools)
#install_github("mikeasilva/blsAPI")


#here's some other code that is useful
#https://github.com/matthewstern/cmappolicyfuns/blob/master/R/bls_functions.R


#load other libraries
library(blsAPI)
library(tidyverse)
library(janitor)
library(ggthemes)




#find the "seriesid" of the data you want
#the seriesid numbers can be found on this page https://www.bls.gov/help/hlpforma.htm

#here we're going to use the CPI (inflation)
#https://www.bls.gov/help/hlpforma.htm#CU
#notice that the series ID is different depending what you want to return


#Example/Explanation of series IDs
#if we want the Consumer Price Index for all Urban Consumers the series id is CUUR0000SA0
#the first two digits -- CU -- is for "consumer price index urban consumers"
#the next digit -- U --  is whether it's seasonally adjusted or not (U=not adjusted, S=adjusted)
#the fourth digit -- R -- is the periodicty (R=monthly or S=semi-annual data)
#digits 5-8 represent the geographic area -- https://download.bls.gov/pub/time.series/cu/cu.area
#digit 9 is the base year (the "current" base year is 1982-84=100 or more recent (S) and the "alternate" base year (A) is prior to the current base year)
#remaining digits are the item codes: https://download.bls.gov/pub/time.series/cu/cu.item. Right now we have "SAO" which means we're asking for the consumer price index for "all items"



# Load the area and item codes to be able to reference them later

#Areas
area_url <-  'https://download.bls.gov/pub/time.series/cu/cu.area'
areas <- read_delim(area_url, delim="\t")

#Items
item_url <-  'https://download.bls.gov/pub/time.series/cu/cu.item'
items <-  read_delim(item_url, delim="\t")


#BLS limits you to only 50 series in one call

#the areas list includes a lot of regions that I don't want to include. I just want the metro areas, plus the national figure (which is "0000"). A quick way to isolate the metro areas is that they all have commas in their names (the others don't)

#adding to that new table the full series codes needed to get various items for each of those geographies

metro_areas <-  areas %>% filter(area_code=='0000' | grepl(',', area_name)) %>% mutate(all_items_code = paste('CUUR', area_code, 'SA0', sep=""),
                                                                                       food_code = paste('CUUR', area_code, 'SAF1', sep=""),
                                                                                       meat_code = paste('CUUR', area_code, 'SAF11211', sep=""),
                                                                                       milk_code = paste('CUUR', area_code, 'SEFJ01', sep=""),
                                                                                       housing_code = paste('CUUR', area_code, 'SAH', sep=""),
                                                                                       energy_code = paste('CUUR', area_code, 'SA0E', sep=""),
                                                                                       apparel_code = paste('CUUR', area_code, 'SAA', sep=""),
                                                                                       motor_fuel_code = paste('CUUR', area_code, 'SETB', sep=""),
                                                                                       medical_code = paste('CUUR', area_code, 'SETB', sep=""),
                                                                                       daycare_code = paste('CUUR', area_code, 'SEEB03', sep=""),
                                                                                       all_less_food_energy = paste('CUUR', area_code, 'SA0L1E', sep=""))



#set the variables for the API call

#start and end years ;  BLS has a 20 year maximum
startyear <- 2018 
endyear <- 2022

#set the series id's you want to pull (maximum of 50 in one call)

#this is going to grab the "all items" series for the metro areas, plus whole US

#set the item code you want to pull, referring to the column name in metro_areas table
seriesid = c(metro_areas$all_items_code)


#set the variables that will be loaded to the API; none of this needs to change
payload <- list('seriesid' = seriesid,
                'startyear' = startyear,
                'endyear' = endyear,
                'annualaverage' = TRUE,
                'registrationkey' =  Sys.getenv("bls_api"))

#pull data and turn it into a dataframe
response <- blsAPI(payload, api_version = 2, return_data_frame = TRUE)



allitems <-  left_join(response, metro_areas %>% select(all_items_code, area_name), by=c("seriesID"="all_items_code"))







# pull a different set of data


#this is going to grab the "all items" series for the metro areas, plus whole US
seriesid = c(metro_areas$energy_code)


#set the variables that will be loaded to the API
payload <- list('seriesid' = seriesid,
                'startyear' = startyear,
                'endyear' = endyear,
                'annualaverage' = TRUE,
                'registrationkey' =  Sys.getenv("bls_api"))

#pull data and turn it into a dataframe
response <- blsAPI(payload, api_version = 2, return_data_frame = TRUE)

energy <-  left_join(response, metro_areas %>% select(energy_code, area_name), by=c("seriesID"="energy_code"))




