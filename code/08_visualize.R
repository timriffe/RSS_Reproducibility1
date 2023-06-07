
library(tidyverse)

if (!dir.exists("figs")){
  dir.create("figs")
}

dec1  <- read_csv("data/dec2000s.csv",
                  show_col_types = FALSE)
dec2  <- read_csv("data/dec2020s.csv",
                  show_col_types = FALSE)

# first plot covering the 2000s up until 2019
plot1 <-
  dec1 |> 
  ggplot(aes(y = cause, x = age, height = contrib, fill = cause)) +
  geom_ridgeline(scale = 15, min_height = -2, alpha = .5) +
  facet_wrap(~sex) +
  guides(fill = "none")+
  theme_minimal()

# save out; needs to be wide to fit legend
ggsave(plot1, filename = "figs/fig1.pdf", width = 10, height = 5, units = "in")


# second plot for first pandemic year
plot2 <- 
  dec2 |> 
  ggplot(aes(y = cause, x = age, height = contrib, fill = cause)) +
  geom_ridgeline(scale = 30, min_height = -2, alpha = .5) +
  facet_wrap(~sex) +
  guides(fill = "none") +
  theme_minimal()

# save out; needs to be wide to fit legend
ggsave(plot2, filename = "figs/fig2.pdf", width = 10, height = 5, units = "in")

# end




