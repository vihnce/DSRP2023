
install.packages(c("usethis","credentials"))

# install required packages
#install.packages("ggplot2")

# load required packages
library(ggplot2)

?ggplot2
ggplot()

### mpg dataset
str(mpg)
?mpg

ggplot(data = mpg, aes(x = hwy, y = cty)) +
  geom_point() +
  labs(x = "highway mpg",
       y = "city mpg",
       title = "City vs. Highway Mileage")

### iris dataset
## histogram
# can set number of bars with 'bins' ; default being 30
ggplot(data = iris, aes(x = Sepal.Length)) +
  geom_histogram(bins = 35)
# can set width of bars with 'binwidth'
ggplot(data = iris, aes(x = Sepal.Length)) +
  geom_histogram(binwidth = 0.2)

## density plot
ggplot(data = iris, aes(x = Sepal.Length, y = after_stat(count))) +
  geom_density()

## boxplot
ggplot(data = iris, aes(x = Sepal.Length, y = Species)) +
  geom_boxplot()

## violin plot
ggplot(data = iris, aes(x = Species, y = Sepal.Length)) +
  geom_violin()
# violin and boxplot with color
ggplot(data = iris, aes(x = Species, y = Sepal.Length, fill = Species)) +
  geom_violin() +
  geom_boxplot(width = 0.2, fill = "blue")

ggplot(data = iris, aes(x = Species, y = Sepal.Length)) +
  geom_violin(color = "blue", fill = "gray40") + # 'color' is the outline
  geom_boxplot(width = 0.2)

## barplot
ggplot(data = iris, aes(x = Species, y = Sepal.Length, fill = Species)) +
  geom_bar(stat = "summary",
           fun = "mean")

## scatterplot
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()

ggplot(data = iris, aes(x = Species, y = Sepal.Length)) +
  geom_jitter(width = 0.2)

## line plot
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_line(stat = "summary",
            fun = "mean")
# line of best fit
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_smooth()

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_smooth(se = F) + 
  theme_classic() # can set different themes

## color scales
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point(aes(color = Species)) +
  scale_color_manual(values = c("purple","red","blue")) # sets different colors for the different categories

## factors
mpg$year <- as.factor(mpg$year)

iris$Species <- factor(iris$Species, level = c("Versicolor", "Setosa", "Virginica"))
