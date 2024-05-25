library(tidyverse)
library(penguins)

# density solution --------------------------------------------------------

penguins |> ggplot(aes(flipper_length_mm)) + 
  geom_histogram(aes(y = after_stat(density))) + 
  stat_function(
    fun = dnorm, 
    args = list(
      mean = mean(penguins$flipper_length_mm, na.rm = T), 
      sd = sd(penguins$flipper_length_mm, na.rm = T))
    )


# scaling density ---------------------------------------------------------

dnorm_scaled <- function(x, mean, sd, scale) {
  dnorm(x, mean, sd) * scale
}

penguins |> ggplot(aes(flipper_length_mm)) + 
  geom_histogram() + 
  stat_function(
    fun = dnorm_scaled, 
    args = list(
      mean = mean(penguins$flipper_length_mm, na.rm = T), 
      sd = sd(penguins$flipper_length_mm, na.rm = T),
      scale = 1000
      )
  ) + 
  ylab("count")



