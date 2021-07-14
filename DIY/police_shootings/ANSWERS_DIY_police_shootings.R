

library(tidyverse)
library(janitor)
library(lubridate)
library(rmarkdown)
library(knitr)
library(htmltools)
library(kableExtra)

shootings <-  read_csv('mn_police_shootings.csv', col_types=cols('BirthDate'=col_date("%m/%d/%Y"),
                                                                 'DeathDate' = col_date("%m/%d/%Y"),
                                                                 'InjuryDate' = col_date("%m/%d/%Y"))) %>% 
  clean_names()


#Question 1:
#How many deaths were there each year?

#Option 1 is to make a new column with the yr in it
#and then run a group_by query
#this uses the lubridate function year() to strip the year from the date
shootings <-  shootings %>% mutate(yr = year(death_date))
shootings %>% group_by(yr) %>% summarise(count=n())

#Option 2 is to do the year calculation on the fly
shootings %>% group_by(year(death_date)) %>% summarise(count=n())


#Question 2:
#What percentage were men versus women?

shootings %>%
  group_by(gender) %>%
  summarise(count=n()) %>% 
  mutate(pct = count/sum(count))

#Question 3:
#How many involved the Minneapolis Police Department?

#First let's find out how the Minneapolis Police Department is identified in the data
#Here's one way
shootings %>% group_by(agency) %>% summarise(count=n()) %>%
  arrange(desc(count))

#Here's another:
#Note the data is stored as uppercase, so it won't find it unless you uppercase the value
shootings %>%
  filter(grepl("MINNEAPOLIS", agency)) %>%
  group_by(agency) %>% 
  summarise(count=n())

#This second approach won't find misspellings of Minneapolis, though.

#Looks like that second query using grepl found all the instances
#incuding one where Minneapolis PD were one of several agencies involved in the incident

#Question 4:
#How many of the people had a gun at the time of the incident?

#Let's try the column "weapon"
shootings %>% group_by(weapon) %>% summarise(count=n())

#Notice that it's very detailed
#Let's try the column "weapon_category"

shootings %>% group_by(weapon_category) %>% summarise(count=n())

#Question 5:
#What percentage occurred in each region of the state?
#display the largest at the top

shootings %>%
  group_by(region) %>%
  summarise(count=n()) %>%
  mutate(pct= count/sum(count)) %>% 
  arrange(desc(pct))
