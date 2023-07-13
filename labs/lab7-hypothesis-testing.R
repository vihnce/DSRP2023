carsdata <- read.csv("Sport car price.csv")
str(carsdata)
View(carsdata)
library(ggplot2)
library(dplyr)


## Group 1: Lamborghini cars with combustion engine
lambos <- filter(carsdata, Car.Make == "Lamborghini") |>
  filter(as.integer(Engine.Size..L.) < 13)

lambos$Horsepower = as.integer(lambos$Horsepower)

## Group 2: Ferrari cars with combustion engine
ferraris <- filter(carsdata, Car.Make == "Ferrari") |>
  filter(as.integer(Engine.Size..L.) < 13) |>
  select(Car.Make, Horsepower)

ferraris$Horsepower = as.integer(ferraris$Horsepower)

## Numeric Variable to compare: average horsepower

# Null Hypothesis: The average horsepower of combustion engine Lamborghinis and combustion engine Ferraris is same

# Alternative Hypothesis: The average horsepower of combustion engine Lamborghinis and combustion engine Ferraris is different
# ^ this should be tested with two-tailed and unpaired

t.test(lambos$Horsepower, ferraris$Horsepower, paired = F, alternative = "two.sided")

# p-value is 0.0016
# Thus, there is a significant difference in the average horsepower of combustion engine Lamborghinis and combustion engine Ferraris