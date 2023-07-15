
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

# get x values of PCAs and make it a data frame
pca_vals <- as.data.frame(pcas$x)
pca_vals$Species <- iris$Species

ggplot(pca_vals, aes(PC1, PC2, color = Species)) + 
  geom_point() +
  theme_minimal()
