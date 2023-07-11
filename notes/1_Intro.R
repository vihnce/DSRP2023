
# this is a comment

number <- 10
number = 10
number=10

# R Objects ####

ls() #print the names of all objects in environment
rm() #removes an object

number <- 5
decimal <- 1.8

letter <- "a"
word <- "abc"

logic <- TRUE
logic2 <- T

# types of variables
# 3 main classes: numeric, character, logical
class(number)
class(decimal)

class(letter)
class(word)

class(logic)

# there is more variation in types
typeof(number)
typeof(decimal)

# can change the type of an object
as.character(number)
as.integer(number)
as.integer(decimal)

# how to round numbers
round(decimal)
round(22/7, 3) #three values after the decimal

22/7
ceiling(22/7) #always rounds up
floor(22/7) #always rounds down
floor(3.9)

# NA values
?as.integer
word_as_int <- as.integer("hello")
NA + 5

# object naming
name <- "Vince"
NAME <- "Vincent"
n.a.m.e. <- "Vicente"
n_a_m_e_ <- "Vincenzo"
name12345 <- "vihnce"

#### object naming that DOESNT work
#starting with a number
#starting with an underscore
#containing operators: + - / *
#containing conditionals: & < > ! |
#containing: \ , space


# Object Manipulation ####
number
number + 7

decimal
number + decimal

name
paste(name, "Sanchez")
paste(name, "Sanchez is awesome")
paste0(name, "Sanchez")
paste(name, number) #this is to join characters and numbers (or logicals)

#### PRACTICE ###
number <- 17
paste("My name is", name, "Sanchez and I am", number, "years old")



# find something in a word and replace it
?grep
food <- "pizza"
grepl("zz", food)
sub("zz", "", food)

# Vectors ####

# make a vector of characters
letters <- c("a","b","c")
letters <- c(letters, "d") #this adds a new letter to the vector
letters
letters <- c(letters, letter)
letters <- c("x", letters, "w")

# make a vector of numerics
numbers <- c(2,4,6,8,10)
rangeofvalues <- 1:5 #all integers from 1 to 5
5:10

seq(2,10,2) #from, to (inclusive), by
rep(3,5) #repeats 3 five times
rep(c(1,2),5) #repeats 1 2 five times

#### PRACTICE ###
#all values between 1 and 5 by 0.5
seq(1,5,0.5)
#how to get [1 1 1 2 2 2]
rep(1:2, each=3)
c(rep(1,3),rep(2,3))



# make a vector of random numbers 1 to 20
numbers <- 1:20
five_nums <- sample(numbers, 5)
sort(five_nums)
five_nums <- sort(five_nums)
rev(five_nums)

fifteen_nums <- sample(numbers, 15, replace = T)
fifteen_nums <- sort(fifteen_nums)
length(fifteen_nums)
unique(fifteen_nums) #what are the unique values
#how to get number of unique values?
length(unique(fifteen_nums))
#get the count of values in the vector
table(fifteen_nums)

fifteen_nums + 5
fifteen_nums / 2

nums1 <- c(1,2,3)
nums2 <- c(4,5,6)
nums1 + nums2 #values are added together element-wise

nums3 <- c(nums1,nums2)
nums3 + nums1 #values are recycled when adding together
nums3 + nums1 + 1

sum(nums3)
sum(nums3 + 1)
sum(nums3) + 1

# vector indexing
numbers <- rev(numbers)
numbers
numbers[1]
numbers[5]
i <- 5
numbers[i]

numbers[c(1,2,3,4,5)]
numbers[1:5]

# Datasets ####

?mtcars
mtcars #prints entire dataset to console

View(mtcars) #view entire dataset in new tab; better method

summary(mtcars) #gives info on the spread of each variable
str(mtcars) #preview the structure of the dataset

names(mtcars) #names of the variables
head(mtcars) #first 6 rows
head(mtcars, 10) #first 10 rows

# pulling out individual variables as vectors
mpg <- mtcars[,1] #blank means "all". All rows, first column
mtcars[2,2] #value at second row, second column
mtcars[3,] #third row, all columns
mtcars[,1:3] #first 3 columns

#using names to pull out columns
mtcars$gear #pulls out the "gear" column
mtcars[,c("gear","mpg")] #pulls out the "gear", and "mpg" columns (with the names of the cars)

sum(mtcars$gear) #adds all values in the "gear" column

# Statistics ####

View(iris)
first5 <- iris[1:5,1]

mean(first5)
mean(iris$Sepal.Length) #average of the sepal length column

median(first5)
median(iris$Sepal.Length) #middle number of the sepal length

range(first5)
max(first5) - min(first5)
max(iris$Sepal.Length) - min(iris$Sepal.Length)

var(first5)
var(iris$Sepal.Length)

sd(first5)
sqrt(var(first5))

# IQR
IQR(first5) #range of the middle 50% of the data
quantile(first5, 0.25) #Q1
quantile(first5, 0.75) #Q3

# outliers
sl <- iris$Sepal.Length
lower <- mean(sl) - (3*sd(sl))
upper <- mean(sl) + (3*sd(sl))
#or
outliers3 <- quantile(sl,0.25) - 1.5*IQR(sl)
outliers4 <- quantile(sl,0.75) + 1.5*IQR(sl)

# subsetting vectors
first5
first5 < 4.75 | first5 > 5
first5[first5 < 4.75]

values <- c(first5,3,9)
upper
lower

values[values > lower & values < upper] #keeps values lower than upper and higher than lower
values_no_outliers <- values[values > lower & values < upper]

# read in data
getwd() # get working directory
superdata <- read.csv("data/super_hero_powers.csv")

# Conditionals ####

x <- 5
x<3
x>3
x==3
x==5
x!=3

numbers <- 1:5
numbers<3
numbers==3

numbers[1]
numbers[c(1,2)]
numbers[1:2]

numbers[numbers <3] #numbers where numbers < 3

#outlier thresholds
lower <- 2
upper <- 4

#pull out only outliers
numbers[numbers < lower]
numbers[numbers > upper]

#combine with | (or)
numbers[numbers < lower | numbers > upper]

#use & to get all values in between outlier thresholds
numbers[numbers >= lower & numbers <= upper]

# NA Values
NA + 5
sum(1,2,3,NA) #returns NA if any value is NA
sum(1,2,3,NA, na.rm=T)
mean(c(1,2,3,NA), na.rm=T)