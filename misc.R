#Misc
library(tidyverse)

df <- readRDS('data/landRegistryPricePaid_LondonWards.rds')

ggplot(df, aes(x = price)) +
# ggplot(df, aes(x = price)) +
  geom_histogram(bins = 100) +
  # geom_density() +
  scale_x_log10() +
  # coord_cartesian(xlim = c(exp(9),exp(14)))
  coord_cartesian(xlim = c(1e+04,1e+07))


plot(density(rnorm(n = 1000000, mean = 0, sd = 1)), zero.line = T)

plot(density(rnorm(n = 19, mean = 0, sd = 1)), zero.line = T)

hist(rnorm(n = 19, mean = 0, sd = 1))
hist(rnorm(n = 19, mean = , sd = 1))

