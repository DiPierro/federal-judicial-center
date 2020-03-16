# Downloads and combines population data from the Census at the county level
# Dates: 2000 through 2018
# Source: https://www.census.gov/data/developers/data-sets/popest-popproj/popest.html

# Author: Amy DiPierro
# Version: 2020-02-17

# Libraries
library(tidyverse)
library(vroom)

# Parameters

# Combined data filename
file_name <- "cb_county_population_2000_2018"

# Census Bureau API query for population estimates for 2010 - 2018
cb_county_population_2010_2018 <-
  "https://api.census.gov/data/2018/pep/population?get=GEONAME,POP,DATE_CODE,DATE_DESC&for=county:*"

# Census Bureau API query for population estimates for 2000 - 2010
cb_county_population_2000_2010 <-
  "https://api.census.gov/data/2000/pep/int_population?get=GEONAME,POP,DATE_DESC&for=county:*"

# Path to write combined data to
file_out <- here::here(str_glue("data-raw/{file_name}.rds"))


#===============================================================================

# Get the 2010-2018 data

df_2010_2018 <-
  jsonlite::fromJSON(cb_county_population_2010_2018) %>%
  as_tibble() %>%
  janitor::row_to_names(row_number = 1) %>%
  transmute(
    name = GEONAME,
    fips = str_c(state, county) %>% as.integer(),
    year = DATE_DESC,
    population = as.double(POP)
  ) %>%
  filter(str_detect(year, "^7/1/")) %>%
  mutate(year = str_extract(year, "\\b20\\d{2}\\b") %>% as.integer()) %>%
  arrange(fips, year)

# Get the 2000-2010 data

df_2000_2010 <-
  jsonlite::fromJSON(cb_county_population_2000_2010) %>%
  as_tibble() %>%
  janitor::row_to_names(row_number = 1) %>%
  transmute(
    name = GEONAME,
    fips = str_c(state, county) %>% as.integer(),
    year = DATE_DESC,
    population = as.double(POP)
  ) %>%
  filter(str_detect(year, "7/1/")) %>%
  mutate(year = str_extract(year, "\\b20\\d{2}\\b") %>% as.integer()) %>%
  arrange(fips, year)

# Combine all the data

df_combined <-
  df_2000_2010 %>%
  bind_rows(df_2010_2018) %>%
  write_rds(file_out, compress = "gz")


