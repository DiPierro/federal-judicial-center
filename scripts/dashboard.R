# Purpose: Parses a .txt file of civil court cases filed for the dates, state 
#          and nature of suit specified in dashboard.yaml. Parses the data,  
#          renames variables, recodes variables.
# Input:   .txt file specified in `file_in` parameter
# Output:  dashboard.rds
# Data:  Federal Judicial Center
# Author:  Amy DiPierro
# Version: 2020-03-14

# Libraries
library(tidyverse)

# Parameters

## Year range
begin_year <- 1988
end_year <- 2018

## Path in for dashboard.yaml
yaml <- 
  yaml::read_yaml(
    here::here("c01-own", "scripts", "dashboard.yaml")
  )

## Path out for dashboard.rds
file_out <- here::here("c01-own", "data-raw", "dashboard.rds")

## Columns to read in
vars_cols <-
  cols_only(
    "DISTRICT" = col_character(), 
    "DOCKET" = col_character(),
    "DEF" = col_character(),
    "PLT" = col_character(),
    "NOS" = col_character(), 
    "FILEDATE" = col_date(format = "%m/%d/%Y"),
    "COUNTY" = col_integer(),
    "TERMDATE" = col_date(format = "%m/%d/%Y")
  )

## Recoding for nature of suit
nos_recode <-
  c(
    "110" = "INSURANCE",
    "120" = "MARINE CONTRACT ACTIONS",
    "130" = "MILLER ACT",
    "140" = "NEGOTIABLE INSTRUMENTS",
    "150" = "OVERPAYMENTS & ENFORCEMENT OF JUDGMENTS",
    "151" = "OVERPAYMENTS UNDER THE MEDICARE ACT",
    "152" = "RECOVERY OF DEFAULTED STUDENT LOANS",
    "153" = "RECOVERY OF OVERPAYMENTS OF VET BENEFITS", 
    "160" = "STOCKHOLDER'S SUITS",
    "190" = "OTHER CONTRACT ACTIONS",
    "195" = "CONTRACT PRODUCT LIABILITY",
    "196" = "CONTRACT FRANCHISE",
    "210" = "LAND CONDEMNATION",
    "220" = "FORECLOSURE",
    "230" = "RENT, LEASE, EJECTMENT",
    "240" = "TORTS TO LAND",
    "245" = "TORT PRODUCT LIABILITY",
    "290" = "OTHER REAL PROPERTY ACTIONS",
    "310" = "AIRPLANE PERSONAL INJURY",
    "315" = "AIRPLANE PRODUCT LIABILITY",
    "320" = "ASSAULT, LIBEL, AND SLANDER",
    "330" = "FEDERAL EMPLOYERS' LIABILITY",
    "340" = "MARINE PERSONAL INJURY",
    "345" = "MARINE - PRODUCT LIABILITY",
    "350" = "MOTOR VEHICLE PERSONAL INJURY",
    "355" = "MOTOR VEHICLE PRODUCT LIABILITY",
    "360" = "OTHER PERSONAL INJURY",
    "362" = "MEDICAL MALPRACTICE",
    "365" = "PERSONAL INJURY -PRODUCT LIABILITY",
    "367" = "HEALTH CARE / PHARM",
    "368" = "ASBESTOS PERSONAL INJURY - PROD.LIAB.", 
    "370" = "OTHER FRAUD",
    "371" = "TRUTH IN LENDING",
    "375" = "FALSE CLAIMS ACT",
    "380" = "OTHER PERSONAL PROPERTY DAMAGE",
    "385" = "PROPERTY DAMAGE -PRODUCT LIABILTY",
    "400" = "STATE RE-APPORTIONMENT",
    "410" = "ANTITRUST",
    "422" = "BANKRUPTCY APPEALS RULE 28 USC 158",
    "423" = "BANKRUPTCY WITHDRAWAL 28 USC 157", 
    "430" = "BANKS AND BANKING",
    "440" = "OTHER CIVIL RIGHTS",
    "441" = "CIVIL RIGHTS VOTING",
    "442" = "CIVIL RIGHTS JOBS",
    "443" = "CIVIL RIGHTS ACCOMMODATIONS",
    "444" = "CIVIL RIGHTS WELFARE",
    "445" = "CIVIL RIGHTS ADA EMPLOYMENT",
    "446" = "CIVIL RIGHTS ADA OTHER",
    "448" = "EDUCATION",
    "450" = "INTERSTATE COMMERCE",
    "460" = "DEPORTATION",
    "462" = "NATURALIZATION, PETITION FOR HEARING OF DENIAL", 
    "463" = "HABEAS CORPUS – ALIEN DETAINEE",
    "465" = "OTHER IMMIGRATION ACTIONS",
    "470" = "CIVIL (RICO)",
    "480" = "CONSUMER CREDIT",
    "490" = "CABLE/SATELLITE TV",
    "510" = "PRISONER PETITIONS -VACATE SENTENCE",
    "530" = "PRISONER PETITIONS -HABEAS CORPUS",
    "535" = "HABEAS CORPUS: DEATH PENALTY",
    "540" = "PRISONER PETITIONS -MANDAMUS AND OTHER",
    "550" = "PRISONER -CIVIL RIGHTS",
    "555" = "PRISONER - PRISON CONDITION",
    "560" = "CIVIL DETAINEE",
    "610" = "AGRICULTURAL ACTS",
    "620" = "FOOD AND DRUG ACTS",
    "625" = "DRUG RELATED SEIZURE OF PROPERTY",
    "630" = "LIQUOR LAWS",
    "640" = "RAILROAD AND TRUCKS",
    "650" = "AIRLINE REGULATIONS",
    "660" = "OCCUPATIONAL SAFETY/HEALTH",
    "690" = "OTHER FORFEITURE AND PENALTY SUITS",
    "710" = "FAIR LABOR STANDARDS ACT",
    "720" = "LABOR/MANAGEMENT RELATIONS ACT",
    "730" = "LABOR/MANAGEMENT REPORT & DISCLOSURE",
    "740" = "RAILWAY LABOR ACT",
    "751" = "FAMILY AND MEDICAL LEAVE ACT",
    "790" = "OTHER LABOR LITIGATION",
    "791" = "EMPLOYEE RETIREMENT INCOME SECURITY ACT",
    "810" = "SELECTIVE SERVICE",
    "820" = "COPYRIGHT",
    "830" = "PATENT",
    "840" = "TRADEMARK",
    "850" = "SECURITIES, COMMODITIES, EXCHANGE",
    "860" = "SOCIAL SECURITY",
    "861" = "HIA (1395 FF)/ MEDICARE",
    "862" = "BLACK LUNG",
    "863" = "D.I.W.C./D.I.W.W.",
    "864" = "S.S.I.D.",
    "865" = "R.S.I.",
    "870" = "TAX SUITS",
    "871" = "IRS 3RD PARTY SUITS 26 USC 7609",
    "875" = "CUSTOMER CHALLENGE 12 USC 3410", 
    "890" = "OTHER STATUTORY ACTIONS",
    "891" = "AGRICULTURAL ACTS",
    "892" = "ECONOMIC STABILIZATION ACT",
    "893" = "ENVIRONMENTAL MATTERS",
    "894" = "ENERGY ALLOCATION ACT",
    "895" = "FREEDOM OF INFORMATION ACT OF 1974",
    "896" = "ARBITRATION",
    "899" = "ADMINISTRATIVE PROCEDURE ACT/REVIEW OR APPEAL OF AGENCY DECISION",
    "900" = "APPEAL OF FEE -EQUAL ACCESS TO JUSTICE",
    "910" = "DOMESTIC RELATIONS",
    "920" = "INSANITY",
    "930" = "PROBATE",
    "940" = "SUBSTITUTE TRUSTEE",
    "950" = "CONSTITUTIONALITY OF STATE STATUTES",
    "990" = "OTHER",
    "992" = "LOCAL JURISDICTIONAL APPEAL",
    "999" =  "MISCELLANEOUS",
    .default = NA_character_
  )

## Recoding for districts
district_recode <-
  c(
    "00" = "Maine",
    "01" = "Massachusetts",
    "02" = "New Hampshire",
    "03" = "Rhode Island",
    "04" = "Puerto Rico",
    "05" = "Connecticut",
    "06" = "New York Northern",
    "07" = "New York Eastern",
    "08" = "New York Southern",
    "09" = "New York Western",
    "10" = "Vermont",
    "11" = "Delaware",
    "12" = "New Jersey",
    "13" = "Pennsylvania Eastern",
    "14" = "Pennsylvania Middle",
    "15" = "Pennsylvania Western",
    "16" = "Maryland",
    "17" = "North Carolina Eastern",
    "18" = "North Carolina Middle",
    "19" = "North Carolina Western",
    "20" = "South Carolina",
    "22" = "Virginia Eastern",
    "23" = "Virginia Western",
    "24" = "West Virginia Northern",
    "25" = "West Virginia Southern",
    "26" = "Alabama Northern",
    "27" = "Alabama Middle",
    "28" = "Alabama Southern",
    "29" = "Florida Northern",
    "3A" = "Florida Middle",
    "3C" = "Florida Southern",
    "3E" = "Georgia Northern",
    "3G" = "Georgia Middle",
    "3J" = "Georgia Southern",
    "3L" = "Louisiana Eastern",
    "3N" = "Louisiana Middle",
    "36" = "Louisiana Western",
    "37" = "Mississippi Northern", 
    "38" = "Mississippi Southern",
    "39" = "Texas Northern",
    "40" = "Texas Eastern",
    "41" = "Texas Southern",
    "42" = "Texas Western",
    "43" = "Kentucky Eastern",
    "44" = "Kentucky Western",
    "45" = "Michigan Eastern",
    "46" = "Michigan Western",
    "47" = "Ohio Northern",
    "48" = "Ohio Southern",
    "49" = "Tennessee Eastern",
    "50" = "Tennessee Middle", 
    "51" = "Tennessee Western", 
    "52" = "Illinois Northern", 
    "53" = "Illinois Central", 
    "54" = "Illinois Southern", 
    "55" = "Indiana Northern", 
    "56" = "Indiana Southern", 
    "57" = "Wisconsin Eastern", 
    "58" = "Wisconsin Western",
    "60" = "Arkansas Eastern", 
    "61" = "Arkansas Western", 
    "62" = "Iowa Northern",
    "63" = "Iowa Southern",
    "64" = "Minnesota",
    "65" = "Missouri Eastern", 
    "66" = "Missouri Western", 
    "67" = "Nebraska",
    "68" = "North Dakota",
    "69" = "South Dakota", 
    "7-" = "Alaska",
    "70" = "Arizona",
    "71" = "California Northern",
    "72" = "California Eastern",
    "73" = "California Central",
    "74" = "California Southern",
    "75" = "Hawaii",
    "76" = "Idaho",
    "77" = "Montana",
    "78" = "Nevada",
    "79" = "Oregon",
    "80" = "Washington Eastern",
    "81" = "Washington Western",
    "82" = "Colorado",
    "83" = "Kansas",
    "84" = "New Mexico",
    "85" = "Oklahoma Northern",
    "86" = "Oklahoma Eastern",
    "87" = "Oklahoma Western",
    "88" = "Utah",
    "89" = "Wyoming",
    "90" = "District of Columbia",
    "91" = "Virgin Islands",
    "93" = "Guam",
    "94" = "Northern Mariana Islands",
    .default = NA_character_
  )

dummy_cases <- c("0301223", "5700001", "1040001")

#===============================================================================

# Read in and write out the data
yaml$path %>% 
  read_tsv(
    col_names = TRUE,
    col_types = vars_cols
  ) %>% 
  select_all(str_to_lower) %>%
  mutate(
    # Recode outdated FIPS codes
    county = recode(
      county, 
      `51560` = 51005L,
      `51780` = 51083L,
      `12025` = 12086L,
      `30113` = 30031L,
      `46131` = 46071L,
      `46113` = 46102L,
      `51515` = 51019L,
      .default  = county
    ),
    # Recode districts
    district = recode(district, !!! district_recode),
    # Recode nature of suit
    nature_of_suit = recode(nos, !!! nos_recode)
  ) %>%
  # Remove duplicate cases with the same docket number, 
  # filed on the same date in the same court
  distinct(district, docket, filedate, .keep_all = TRUE) %>% 
  filter(
    # Filter out partial year data
    lubridate::year(filedate) >= begin_year,
    lubridate::year(filedate) <= end_year,
    # Filter out dummy cases
    !docket %in% dummy_cases
  ) %>% 
  write_rds(file_out, compress = "gz") 

