# in this script we merge our harmonized inputs and calculate rates
# we presume the previous steps were run already.
library(tidyverse)
pop <- read_csv("data/pop_clean.csv",
         show_col_types = FALSE)
deaths <- read_csv("data/deaths_clean.csv",
                   show_col_types = FALSE)

mort <- left_join(deaths, pop, by = c("year","sex","age")) |> 
  mutate(mxc = deaths / pop) |> 
  filter(year > 1980)

# save out
write_csv(mort, "data/mort_rates.csv")
  
# end


