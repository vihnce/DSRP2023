library(dplyr)

?ifelse()
?case_when()

## practice with ifelse()
x <- 7
x <- c(1,3,5,7,9)
ifelse(x<5, "small num", "big num")

head(iris)
mean(iris$Petal.Width)
iris_new <- iris

## add categorical column
iris_new <- mutate(iris_new,
                   petal_size = ifelse(Petal.Width > 1, "big", "small"))
iris_new

iris_new <- mutate(iris_new,
                   petal_size = case_when(Petal.Width < 1 ~ "small",
                                          Petal.Width < 2 ~ "medium",
                                          Petal.Width >= 2 ~ "big")) # or can use TRUE ~ "something" , which means everything else
iris_new
