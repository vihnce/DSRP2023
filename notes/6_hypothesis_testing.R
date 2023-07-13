
library(dplyr)


## Compare the mass of male and female human Star Wars characters
## null hypothesis: the average mass of male and female Star Wars characters is the same
## alternative hypothesis: the average mass of male and female Star Wars characters is different

swHumans <- filter(starwars, species == "Human", mass > 0)
males <- filter(swHumans, sex == "male")
females <- filter(swHumans, sex == "female")

t.test(males$mass, females$mass, paired = F, alternative = "two.sided")
# p value is 0.065 (which is above 0.05)
# not significant, which supports the null hypothesis