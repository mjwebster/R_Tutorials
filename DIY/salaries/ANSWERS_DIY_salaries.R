
library(readxl)
library(tidyverse)
library(lubridate)
library(janitor)
library(formattable)

#Import file
pay <-  read_excel('stpaulsalaries.xls') %>% clean_names()

#check the table structure to make sure all the columns are formatted properly
str(pay)

#Question 1:
#Calculate percentage of OT pay for each person
#Here's the simplest way to do it. It will give a 0 for those without any overtime
pay <-  pay %>% mutate(pctot = overtime_pay/total_wages )
#Who had the most?
pay %>% select(lastname, restname, jobtitle,dept, pctot) %>% arrange(desc(pctot))

#Question 2:
#Calculate overtime hours per week (52 weeks in a year)
pay <-  pay %>% filter(overtime_hours>0) %>% mutate(ot_per_wk = overtime_hours/52)
#Now find who had the most?
pay %>% select(lastname, restname, jobtitle, dept, ot_per_wk) %>% arrange(desc(ot_per_wk))


#Question 3:
#Make a summary table at the department level
dept <-  pay %>% group_by(dept) %>% summarise(total_pay = currency(sum(total_wages)),
                                              total_ot_pay = currency(sum(overtime_pay)),
                                              total_hours = currency(sum(total_hrs)),
                                              total_ot_hours = comma(sum(overtime_hours)),
                                              employee_count = comma(n()))

#Question 4:
#Which department paid out the most in total compensation?
dept %>% arrange(desc(total_pay))

#Question 5:
#Which department had the highest average salary?
#First let's make a new column with average salary
dept <-  dept %>% mutate(avg_salary = currency(total_pay/employee_count))
#Now let's see which dept had the highest
dept %>% select(dept, avg_salary) %>%  arrange(desc(avg_salary))

#Question 6:
#Calculate the percentage that overtime pay makes up of total wages for each department.
dept <-  dept %>% mutate(ot_pct = percent(total_ot_pay/total_pay))
#highest department?
dept %>% select(dept, ot_pct) %>% arrange(desc(ot_pct))

#FYI.. the public works snow taggers are part-time employees who go out during snow emergencies
#and write tickets on vehicles that are parked in areas that are supposed to be cleared
#for plow trucks to come through. 

#Question 7:
#Calculate the average overtime hours per person in each department
dept <-  dept %>% mutate(avg_ot_hours = total_ot_hours/employee_count)
#highest department?
dept %>% select(dept, avg_ot_hours) %>% arrange(desc(avg_ot_hours))

#FYI... Police ECC is the emergency communications dispatch center
