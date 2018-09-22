# Dallas shooting scraping

library(dplyr)
library(rvest)
library(readr)
library(tidyr)
library(lubridate)
library(stringr)
library(ggplot2)

yearly_url <- 'https://www.odmp.org/search/year/'

years <- seq(1791, 2018)

all_data <- data.frame()

# Scrape data

for (year in years){
  new_url <- paste0(yearly_url, year)

  selector_yearly <- '.officer-short-details'

  raw_data <- read_html(new_url) %>%
    html_nodes(selector_yearly)
  
  for (node in raw_data) {
     officer_data <- node %>% html_nodes("p") %>% html_text()
     officer_data <- as.data.frame(list(person = officer_data[1], 
                                        dept = officer_data[2], 
                                        eow = officer_data[3],
                                        cause = officer_data[4]))
     all_data <- rbind(all_data, officer_data)
  }
}

write_csv(all_data, "all_data_fallen_officers.csv")
