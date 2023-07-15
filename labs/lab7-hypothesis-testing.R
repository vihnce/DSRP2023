carsdata <- read.csv("Sport car price.csv")
str(carsdata)
View(carsdata)
library(ggplot2)
library(dplyr)

### Part 1

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

### Part 2

# creating data set with non-electric cars between $100,000 and $1,000,000
carsdata_small <- select(carsdata, Car.Make, Engine.Size..L., Horsepower, X0.60.MPH.Time..seconds., Price..in.USD., Year)
carsdata_small <- filter(carsdata_small, nchar(carsdata$Price..in.USD.) == 7)
carsdata_small <- filter(carsdata_small, as.integer(Engine.Size..L.) < 13)
carsdata_small <- filter(carsdata_small, Car.Make != "Tesla")
carsdata_small$Price..in.USD. <- as.integer(gsub(".{0,4}$", "", carsdata_small$Price..in.USD.)) * 1000

carsdata_small
View(carsdata_small)

# ANOVA testing
anova_results <- aov(data=carsdata_small, Price..in.USD. ~ as.factor(Year))
summary(anova_results)
TukeyHSD(anova_results)

### Part 3

carsdata_small_newyears <- filter(carsdata_small, Year == "2021" | Year == "2022")

part3_table <- table(carsdata_small_newyears$Car.Make, carsdata_small_newyears$Year)

chisq_result <- chisq.test(part3_table)
chisq_result
chisq_result$p.value
chisq_result$residuals

