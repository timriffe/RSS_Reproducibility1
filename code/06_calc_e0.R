
library(tidyverse)

mort <- read_csv("data/mort_rates.csv")
e0 <-
  mort |> 
  group_by(year,sex) |> 
  summarize(e0 = calc_e0(mxc),
            .groups = "drop")

# do these look reasonable?
e0 |> 
  ggplot(aes(x = year,y=e0,color = sex)) +
  geom_line() +
  theme_minimal()

# write out
e0 |> 
  write_csv("data/e0.csv")

# end
