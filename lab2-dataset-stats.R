carsdata <- read.csv("data/Sport car price.csv")
str(carsdata)
View(carsdata)

hp <- as.integer(carsdata$Horsepower)
mean(hp)
median(hp)
max(hp) - min(hp)
sd(hp)
IQR(hp)

mean(hp, na.rm=T)
max(hp, na.rm=T) - min(hp, na.rm=T)
var(hp, na.rm=T)
sd(hp, na.rm=T)
IQR(hp, na.rm=T)

lower <- mean(hp, na.rm=T) - (3*sd(hp, na.rm=T))
upper <- mean(hp, na.rm=T) + (3*sd(hp, na.rm=T))
no_outliers <- hp[hp >= lower & hp <= upper]

mean(no_outliers, na.rm=T)
median(no_outliers, na.rm=T)