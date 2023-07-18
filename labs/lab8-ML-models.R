library(parsnip)
library(rsample)
library(yardstick)
library(dplyr)
library(reshape2)
library(ggplot2)
library(Metrics)

carsdata <- read.csv("Sport car price.csv")
str(carsdata)
View(carsdata)

# creating data set with non-electric cars between $100,000 and $1,000,000
carsdata_small <- select(carsdata, -Car.Model)
carsdata_small <- filter(carsdata_small, nchar(carsdata$Price..in.USD.) == 7)
carsdata_small <- filter(carsdata_small, as.integer(Engine.Size..L.) < 13)
carsdata_small <- filter(carsdata_small, Car.Make != "Tesla" & Car.Make != "TVR" & Car.Make != "Ultima" & Car.Make != "Polestar")
carsdata_small$Price..in.USD. <- as.integer(gsub(".{0,4}$", "", carsdata_small$Price..in.USD.)) * 1000

# make numeric variables into numeric values (more cleaning)
carsdata_small$Engine.Size..L. = as.numeric(carsdata_small$Engine.Size..L.)
carsdata_small$X0.60.MPH.Time..seconds. = as.numeric(carsdata_small$X0.60.MPH.Time..seconds.)
carsdata_small$Torque..lb.ft. = as.numeric(carsdata_small$Torque..lb.ft.)
carsdata_small$Horsepower = as.numeric(carsdata_small$Horsepower)

carsdata_small
View(carsdata_small)

# PCA
cars_numvars <- select(carsdata_small, -Car.Make, -Year)
cars_numvars

pcas <- prcomp(cars_numvars, scale. = T)
pcas
summary(pcas)
pcas$rotation

pcas$rotation^2 # percentages of each variable in each PC

# get x values of PCAs and make it a data frame, then plot
pca_vals <- as.data.frame(pcas$x)
pca_vals$Car.Make <- carsdata_small$Car.Make

ggplot(pca_vals, aes(PC1, PC2, color = Car.Make)) + 
  geom_point() +
  theme_minimal() +
  labs(title = "PCA Plot of Variables by Car Make")

# make categorical variables into factors then integers
carsAllNumeric <- mutate(carsdata_small,
                         Car.Make = as.integer(as.factor(Car.Make)))

# calculate correlations
carsCors <- carsAllNumeric |>
  cor() |>
  melt() |>
  as.data.frame()
carsCors

# plot correlations between variables
ggplot(carsCors, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "orange", high = "blue", mid = "white", midpoint = 0) +
  labs(title = "Correlation Plot")

# high correlation?
ggplot(carsAllNumeric, aes(x = Price..in.USD., y = Horsepower)) +
  geom_point() +
  theme_minimal()

# low correlation?
ggplot(carsAllNumeric, aes(x = X0.60.MPH.Time..seconds., y = Horsepower)) +
  geom_point() +
  theme_minimal()

# will predict on Price (regression)

# set a seed for reproducability
set.seed(71723)

# create a split
reg_split <- initial_split(carsAllNumeric, prop = .75) # 75% of data for training

# use the split to form testing and training sets
reg_train <- training(reg_split)
reg_test <- testing(reg_split)

# Linear regression
lm_fit <- linear_reg() |>
  set_engine("lm") |>
  set_mode("regression") |>
  fit(Price..in.USD. ~ Horsepower + X0.60.MPH.Time..seconds. + Torque..lb.ft. + Engine.Size..L.,
      data = reg_train)

lm_fit$fit
summary(lm_fit$fit)

# calculate errors
reg_results <- reg_test

reg_results$lm_pred <- predict(lm_fit, reg_test)$.pred

yardstick::mae(reg_results, Price..in.USD., lm_pred)

yardstick::rmse(reg_results, Price..in.USD., lm_pred)

# Random Forest regression
forest_reg_fit <- rand_forest() |>
  set_engine("ranger") |>
  set_mode("regression") |>
  fit(Price..in.USD. ~ .,
      data = reg_train)

forest_reg_fit$fit

# calculate errors
reg_results$forest_pred <- predict(forest_reg_fit, reg_test)$.pred

yardstick::mae(reg_results, Price..in.USD., forest_pred)

yardstick::rmse(reg_results, Price..in.USD., forest_pred)

# Random Forest model performed with less error than the Linear model


