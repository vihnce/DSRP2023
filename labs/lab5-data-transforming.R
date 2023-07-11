carsdata <- read.csv("Sport car price.csv")
str(carsdata)
View(carsdata)
library(ggplot2)
library(dplyr)

# filter by 2 variables (lambo, non-electric engine)
lambo_enginesize <- filter(carsdata, Car.Make == "Lamborghini", as.integer(Engine.Size..L.) < 13)

# create smaller dataset with subset of variables
carsdata_small <- select(carsdata, Car.Make, Engine.Size..L., Horsepower, X0.60.MPH.Time..seconds., Price..in.USD.)
carsdata_small <- filter(carsdata_small, nchar(carsdata$Price..in.USD.) == 7)
carsdata_small <- filter(carsdata_small, as.integer(Engine.Size..L.) < 13)
carsdata_small <- filter(carsdata_small, Car.Make != "Tesla")
carsdata_small$Price..in.USD. <- as.integer(gsub(".{0,4}$", "", carsdata_small$Price..in.USD.)) * 1000

carsdata_small
View(carsdata_small)

# add 2 new rows (smaller dataset)
add_2_rows <- mutate(carsdata_small,
       Horsepower_per_L = as.integer(Horsepower)/as.integer(Engine.Size..L.),
       Cost_per_Horsepower = Price..in.USD. / as.integer(Horsepower))

add_2_rows

# data table of group summaries (smaller dataset)
summary <- summarize(carsdata_small,
          Average_Horsepower = mean(as.integer(Horsepower)),
          .by = "Car.Make",
          count = n())
View(summary)

# reorder data table (smaller dataset)
arrange(carsdata_small, desc(Price..in.USD.))

# new visualization
ggplot(data = summary, aes(x = Car.Make, y = Average_Horsepower, fill = Car.Make)) +
  geom_bar(stat = "summary",
           fun = "mean") +
  theme_minimal() +
  labs(x = "Manufacturer",
       y = "Average Horsepower",
       title = "Average Horsepower of Different Car Manufacturers",
       fill = "Manufacturer")
