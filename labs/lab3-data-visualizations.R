carsdata <- read.csv("data/Sport car price.csv")
str(carsdata)
View(carsdata)
library(ggplot2)

hp <- as.integer(carsdata$Horsepower)

ggplot(data = carsdata, aes(x = hp)) +
  geom_histogram(bins = 50) +
  labs(x = "Horsepower",
       y = "# of Cars")

ggplot(data = carsdata, aes(x = Car.Make, y = hp, fill = Car.Make)) +
  geom_bar(stat = "summary",
           fun = "mean") +
  labs(x = "Car Brand",
       y = "Average Horsepower")

engine_sizes = as.integer(carsdata$Engine.Size..L.)

ggplot(data = carsdata, aes(x = hp, y = X0.60.MPH.Time..seconds.)) +
  geom_point(aes(color = engine_sizes),
             shape = 18,
             size = 3) +
  labs(x = "Horsepower",
       y = "0-60 MPH time",
       title = "Horsepower vs. 0-60 Time, With Engine-Size Comparison",
       col = "Engine Size (L)") +
  theme_minimal()
