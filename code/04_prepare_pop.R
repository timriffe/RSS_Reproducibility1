# in this script we do data wrangling for population data;
# this may include some diagnostic checks too, which
# could easily be a separate step.

library(tidyverse)
library(janitor)

pop <- read_tsv("data/pop.tsv",
                locale = locale(grouping_mark = ".",
                                decimal_mark = ","),
                na= "..",
                show_col_types = FALSE) |> 
  clean_names() |> 
  rename(age = valores_simples_de_edad,
         sex = sexo,
         pop = total) |> 
  filter(grepl(periodo,pattern = "julio")) |> 
  mutate(year = gsub(periodo, pattern = "1 de julio de ",replacement = ""),
         year = parse_number(year)) |> 
  select(-periodo) |> 
  filter(!is.na(pop),
         year> 1980)

# NAs are due to ages higher than the open age in a given year
# pop |> 
#   filter(is.na(pop)) |> View()

# pop$age |> unique()

# deaths go up to 95+ each year, pops are variable;
# deaths are for years 1980 - 2021
ages <- c(paste0(0:99," años"), "100 y más años")
pop <-
  pop |> 
  filter(sex != "Ambos sexos") |> 
  mutate(sex = if_else(sex == "Hombres", "Males","Females")) |> 
  filter(age %in% ages) |> 
  mutate(age = parse_number(age))

# We could try to extrapolate causes to 100+, but that's a pain,
# So let's group populations to 95+, it'll be good enough for our ends.
pop_ready_to_merge <-
  pop |> 
  mutate(age = case_when(age > 95 ~ 95,
                         age == 0 ~ 0,
                         between(age,1,4)~1,
                         TRUE ~ age - age %% 5)) |> 
  group_by(year,sex,age) |> 
  summarize(pop = sum(pop, na.rm = TRUE), 
            .groups = "drop") |> 
  filter(year > 1980)

# save out harmonized exposures
write_csv(pop_ready_to_merge, "data/pop_clean.csv")

# end
