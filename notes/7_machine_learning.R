library(ggplot2)
### Unsupervised Learning ####
## Principal Components Analysis
head(iris)

# remove any non-numeric variables
iris_num <- select(iris, -Species)
iris_num

# do PCA
pcas <- prcomp(iris_num, scale. = T)
pcas
summary(pcas)
pcas$rotation

pcas$rotation^2 # percentages of each variable in each PC

# get x values of PCAs and make it a data frame
pca_vals <- as.data.frame(pcas$x)
pca_vals$Species <- iris$Species

ggplot(pca_vals, aes(PC1, PC2, color = Species)) + 
  geom_point() +
  theme_minimal()


### Supervised Learning Models ####

## install and load packages

#install.packages("tidymodels")
#install.packages("ranger")
#install.packages("xgboost")
#install.packages("reshape2")
library(parsnip)
library(rsample)
library(yardstick)
library(dplyr)
library(reshape2)
library(ggplot2)

## STEP 1: Collect Data
head(starwars)

## STEP 2: Clean and Process Data

# get rid of NAs
noNAs <- na.omit(iris) # only use na.omit when you have specifically selected variables you want to include in the model
noNAs <- filter(starwars, !is.na(mass), !is.na(height))

# replace with means
replaceWithMeans <- mutate(starwars,
                           mass = ifelse(is.na(mass),
                                         mean(mass),
                                         mass))

# encode categories as factors or integers 
# if categorical variable is a character, make it a factor (then an integer).
intSpecies <- mutate(starwars,
                     species = as.integer(as.factor(species)))

# if categorical variable is already a factor, make it an integer. WITH IRIS DATA SET NOW
irisAllNumeric <- mutate(iris,
                         Species = as.integer(Species))

## STEP 3: Visualize Data

# make a PCA or calculate correlations
irisCors <- irisAllNumeric |>
  cor() |>
  melt() |>
  as.data.frame()
irisCors

# plot of correlations between variables
ggplot(irisCors, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white", midpoint = 0)

# high correlation?
ggplot(irisAllNumeric, aes(x = Petal.Length, y = Sepal.Length)) +
  geom_point() +
  theme_minimal()

# low correlation?
ggplot(irisAllNumeric, aes(x = Sepal.Width, y = Sepal.Length)) +
  geom_point() +
  theme_minimal()

## STEP 4: Perform Feature Selection

# choose which variables to classify & predict and which to use as features in the model
# for iris data, we will classify on Species (classification) & predict on Sepal.Length (regression)

## STEP 5: Separate Data into Testing and Training Sets

# choose 70-85% of data to train on

# set a seed for reproducability
set.seed(71723)

# Regression Dataset Splits
# create a split
reg_split <- initial_split(irisAllNumeric, prop = .75) # 75% of data for training

# use the split to form testing and training sets
reg_train <- training(reg_split)
reg_test <- testing(reg_split)

# Classification Dataset Splits (PRACTICE using iris instead of irisAllNumeric)
class_split <- initial_split(iris, prop = .75)

class_train <- training(class_split)
class_test <- testing(class_split)
class_test

## STEP 6 & 7: Choose a ML model and train it

# Linear Regression
lm_fit <- linear_reg() |>
  set_engine("lm") |>
  set_mode("regression") |>
  fit(Sepal.Length ~ Petal.Length + Petal.Width + Species + Sepal.Width,
      data = reg_train)
# Sepal.Length = 2.3 + Petal.Length*0.7967 + Petal.Width*-0.4067 + etc.
lm_fit$fit
summary(lm_fit$fit)

# Logistic Regression
# for logistic regression,
# 1. filter data to only 2 groups in categorical variable of interest
# 2. make the categorical variable a factor
# 3. make training and testing splits

# for our purposes, we are going to filter test and training (don't do this)
binary_test_data <- filter(class_test, Species %in% c("setosa", "versicolor"))
binary_train_data <- filter(class_train, Species %in% c("setosa", "versicolor"))

# build the model
log_fit <- logistic_reg() |>
  set_engine("glm") |>
  set_mode("classification") |>
  fit(Species ~ Petal.Width + Petal.Length + ., data = binary_train_data)

log_fit$fit
summary(log_fit$fit)

# Boosted Decision Trees
# regression
boost_fit <- boost_tree() |>
  set_engine("xgboost") |>
  set_mode("regression") |>
  fit(Sepal.Length ~ ., data = reg_train)

boost_fit$fit$evaluation_log

# classification
# PRACTICE using "classification" as the mode, Species as the predictor (independent) variable, and class_train as the data
boost_class_fit <- boost_tree() |>
  set_engine("xgboost") |>
  set_mode("classification") |>
  fit(Species ~ ., data = class_train)

boost_class_fit$fit$evaluation_log

# Random Forest
# regression
forest_reg_fit <- rand_forest() |>
  set_engine("ranger") |>
  set_mode("regression") |>
  fit(Sepal.Length ~ ., data = reg_train)

forest_reg_fit$fit

# classification (PRACTICE)
forest_class_fit <- rand_forest() |>
  set_engine("ranger") |>
  set_mode("classification") |>
  fit(Species ~ ., data = class_train)

forest_class_fit$fit

## STEP 8: Evaluate Model Performance on Test Set

# calculate errors for regression
# lm_fit, boost_fit, forest_reg_fit
reg_results <- reg_test

reg_results$lm_pred <- predict(lm_fit, reg_test)$.pred
reg_results$boost_pred <- predict(boost_fit, reg_test)$.pred
reg_results$forest_pred <- predict(forest_reg_fit, reg_test)$.pred

mae(reg_results, Sepal.Length, lm_pred)
mae(reg_results, Sepal.Length, boost_pred)
mae(reg_results, Sepal.Length, forest_pred)

rmse(reg_results, Sepal.Length, lm_pred)
rmse(reg_results, Sepal.Length, boost_pred)
rmse(reg_results, Sepal.Length, forest_pred)

# calculate accuracy for classification models
install.packages("Metrics")
library(Metrics)

class_results <- class_test

class_results$lm_pred <- predict(log_fit, class_test)$.pred_class
class_results$boost_pred <- predict(boost_class_fit, class_test)$.pred_class
class_results$forest_pred <- predict(forest_class_fit, class_test)$.pred_class

#f1(class_results$Species, class_results$log_pred)
#f1(class_results$Species, class_results$boost_pred)
#f1(class_results$Species, class_results$forest_pred)

class_results$Species == "setosa"
class_results$log_pred == "setosa"

f1(class_results$Species == "virginica", class_results$log_pred == "virginica")
