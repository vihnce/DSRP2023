
library(dplyr)
library(ggplot2)


## Compare the mass of male and female human Star Wars characters
## null hypothesis: the average mass of male and female Star Wars characters is the same
## alternative hypothesis: the average mass of male and female Star Wars characters is different

swHumans <- filter(starwars, species == "Human", mass > 0)
males <- filter(swHumans, sex == "male")
females <- filter(swHumans, sex == "female")

t.test(males$mass, females$mass, paired = F, alternative = "two.sided")
# p value is 0.065 (which is above 0.05)
# not significant, which supports the null hypothesis


## ANOVA ####
iris

anova_results <- aov(data = iris, Sepal.Length ~ Species)

# Are any groups different from each other?
summary(anova_results)

# Which ones?
TukeyHSD(anova_results)


# Is there a significant difference in the mean petal lengths by species?
aov_petalslength <- aov(data=iris, Petal.Length ~ Species)
summary(aov_petalslength)
TukeyHSD(aov_petalslength)


### Star Wars data
head(starwars)
unique(starwars$species)

# Which 3 species are most common?
top3species <- starwars |>
  summarize(.by = species,
            count = sum(!is.na(species))) |>
  slice_max(count, n=3)

top3species

starwars_top3species <- starwars |>
  filter(species %in% top3species$species)

starwars_top3species

# Is there a significant difference in the mass of each of the top 3 species?
a <- aov(data = starwars_top3species, mass ~ species)
summary(a)
TukeyHSD(a)
# no, all p-values are above 0.05

# In height?
b <- aov(data = starwars_top3species, height ~ species)
summary(b)
TukeyHSD(b)
# yes, all p-values are under 0.05



## Chi-Squared ####
starwars_clean <- starwars |>
  filter(!is.na(species),
         !is.na(homeworld))

t <- table(starwars_clean$species, starwars_clean$homeworld)
chisq.test(t) # not enough data

### mpg data
mpg

# How to get a contingency table of year and drv?

t <- table(mpg$year, mpg$drv)

chisq_result <- chisq.test(t)
chisq_result
chisq_result$p.value
chisq_result$residuals

#install.packages("corrplot")
library(corrplot)

corrplot(chisq_result$residuals)

##
heroes <- read.csv("heroes_information.csv")
head(heroes)

## clean the data
heroes_clean <- heroes |>
  filter(Alignment != "-",
         Gender != "-")

## plot the counts of alignment and gender
ggplot(heroes_clean, aes(x = Gender, y = Alignment)) +
  geom_count() +
  theme_minimal()

## make contingency table
t <- table(heroes_clean$Alignment, heroes_clean$Gender)
t

## chi squared test
chi <- chisq.test(t)
chi$p.value
chi$residuals

corrplot(chi$residuals, is.cor = F)
