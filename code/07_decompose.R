

# decompose 2019 versus 2000
library(tidyverse)
library(DemoDecomp)
library(ggridges)

mort <- read_csv("data/mort_rates.csv",
                 show_col_types = FALSE)


# first compare 2000 and 2019
dec1 <-
  mort |> 
  filter(year %in% c(2000,2019)) |> 
  select(-pop,-deaths) |> 
  pivot_wider(names_from = year, values_from = mxc) |> 
  # sort just to be certain
  arrange(cause,sex,age) |> 
  group_by(sex) |> 
  mutate(contrib = horiuchi(calc_e0, `2000`, `2019`, N = 20)) |> 
  ungroup()

# check additivity
dec1 |> 
  group_by(sex) |> 
  summarize(de0 = sum(contrib))

# compare with calculated differences:
(e0d <- read_csv("data/e0.csv", 
               show_col_types = FALSE) |> 
  filter(year %in% c(2000,2019)) |> 
  group_by(sex) |> 
  summarize(de0 = diff(e0)))

dec1 |> 
  ggplot(aes(y = cause, x = age, height = contrib, fill = cause)) +
  geom_ridgeline(scale = 15, min_height = -2, alpha = .5) +
  facet_wrap(~sex) +
  guides(fill = "none")

# now comapre 2020 and 2019

dec2 <-
  mort |> 
  filter(year %in% c(2020,2019)) |> 
  select(-pop,-deaths) |> 
  pivot_wider(names_from = year, values_from = mxc) |> 
  # sort just to be certain
  arrange(cause,sex,age) |> 
  group_by(sex) |> 
  mutate(contrib = horiuchi(calc_e0, `2019`, `2020`, N = 20)) |> 
  ungroup()

dec2 |> 
  group_by(sex) |> 
  summarize(de0 = sum(contrib))
# match
(read_csv("data/e0.csv", 
                 show_col_types = FALSE) |> 
    filter(year %in% c(2020,2019)) |> 
    group_by(sex) |> 
    summarize(de0 = diff(e0)))

# inspect (need to click zoom to see due to long cause labels)
dec2 |> 
  ggplot(aes(y = cause, x = age, height = contrib, fill = cause)) +
  geom_ridgeline(scale = 30, min_height = -2, alpha = .5) +
  facet_wrap(~sex) +
  guides(fill = "none") +
  theme_minimal()

# write out
write_csv(dec1, "data/dec2000s.csv")
write_csv(dec2, "data/dec2020s.csv")
