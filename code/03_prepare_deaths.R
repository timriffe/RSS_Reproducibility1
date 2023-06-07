# in this script we do data wrangling for deaths data;
# this will include some diagnostic checks too, which
# could easily be a separate step.

library(tidyverse)
library(janitor)
# we take the already-downloaded

# read in deaths
deaths <- read_tsv("data/cod.tsv",locale = locale(grouping_mark = "."))
head(deaths)

# bring names to snake case
deaths <- 
  deaths |> 
  clean_names() |> 
  rename(cause = cause_of_death,
         year = periodo)

# check sex margins sum to stated total
deaths |> 
  pivot_wider(names_from = sex, values_from = total) |> 
  mutate(check = Total == Males + Females) |> 
  pull(check) |> 
  all()

# check age margins sum to stated total
deaths |> 
  group_by(year, sex,age) |>
  summarize(total = sum(total), .groups = "drop") |> 
  group_by(year, sex) |> 
  summarize(check = total[age == "All ages"] == sum(total[age != "All ages"]),
            groups = "drop") |> 
  pull(check) |> 
  all()

# check cause margins sum to stated total
deaths |> 
  group_by(year, sex, age) |> 
  summarize(check = total[cause == "001-102  I-XXII.All causes"] ==
              sum(total[cause != "001-102  I-XXII.All causes"]), 
            .groups = "drop") |> 
  pull(check) |> 
  all()
# this means we have deaths of unknown cause
# spot check to make sure Unknown is not already included as a cause
deaths$cause |> unique() # nope, no unknowns

# Two options: 1) create a code for unk and include this explicitly
# as a cause
# 2) redistribute unknown causes over known causes.

# for (2) we need to decide whether to use large cause groups or 
# the finer cause groups. Let's use large cause groups. These all
# contain hyphens in the fourth character position:
substr(deaths$cause,4,4)
# this appears to work
deaths |> 
  filter(substr(cause,4,4) == "-") |> 
  pull(cause) |> 
  unique()
# redistribute unknowns over large groups;
# same as scaling to stated total
deaths <-
  deaths |> 
  filter(substr(cause,4,4) == "-") |> 
  group_by(year, sex, age) |> 
  mutate(tot = total[cause == "001-102  I-XXII.All causes"]) |> 
  filter(cause != "001-102  I-XXII.All causes") |> 
  mutate(total = total * tot / (sum(total))) |> 
  ungroup() |> 
  select(-tot)

# clean ages
deaths <- 
  deaths |> 
  filter(age != "All ages",
         sex != "Total") |> 
  mutate(
    age = if_else(age == "Under 1 year old" ,"0",age),
    age = parse_number(age)) |> 
    rename(deaths = total)
  

# save out "cleaned" deaths, ready to merge
write_csv(deaths, file = "data/deaths_clean.csv")

# end