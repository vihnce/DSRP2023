
#install.packages("tidyr")
library(tidyr)
#install.packages("janitor")
library(janitor)

library(dplyr)


# cleaning column names
starwars
clean_names(starwars, case = "small_camel")
clean_names(starwars, case = "screaming_snake")
clean_names(starwars, case = "upper_lower")

# combining multiple function calls
starwars_women <- select(arrange(filter(starwars, sex == "female"), birth_year), name, species)
starwars_women

starwars_women <- filter(starwars, sex =="female")
starwars_women <- arrange(starwars_women, birth_year)
starwars_women <- select(starwars_women, name, species)

# OR you can use PIPES
starwars_women <- starwars |>
  filter(sex == "female") |>
  arrange(birth_year) |>
  select(name, species)

# using slice_ functions
starwars
slice_max(starwars, height, n=10) #10 tallest characters

slice_max(starwars, height, n=2, by = species, with_ties = F) #top 2 tallest characters of each species with no ties


## Tidy Data ####

## Pivot Longer
table4a

tidy_table4a <- pivot_longer(table4a,
                             cols = c(`1999`, `2000`),
                             names_to = "year",
                             values_to = "cases")

table4b #shows population data
# How to pivot to be in "tidy" form? (practice)

tidy_table4b <- pivot_longer(table4b,
                             cols = c(`1999`, `2000`),
                             names_to = "year",
                             values_to = "population")

## Pivot Wider
table2

pivot_wider(table2,
            names_from = type,
            values_from = count)

## Separate
table3

separate(table3,
         rate,
         into = c("cases", "population"),
         sep = "/") #this line not needed, it's just to be explicit

## Unite
table5

unite(table5,
      "year",
      c("century", "year"),
      sep = "") #because by default it will join with an "_" between

tidy_table5 <- table5 |>
  unite("year",
        c("century", "year"),
        sep = "") |>
  separate(rate,
           into = c("cases","population"))
tidy_table5

## Bind Rows
new_data <- data.frame(country = "USA", year = "1999", cases = "1042", population = "20000000")
new_data

bind_rows(tidy_table5, new_data)












