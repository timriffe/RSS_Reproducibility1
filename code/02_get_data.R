
# create data folder if it does not exist
if (!dir.exists("data")){
  dir.create("data")
}


# I searched for deaths by cause age and sex in Spain and got here:
# https://www.ine.es/jaxiT3/Tabla.htm?t=7947
# with some fidgetting, I got the below url:
download.file(url = "https://www.ine.es/jaxiT3/files/t/en/csv_bd/7947.csv?nocab=1",
              destfile = "data/cod.tsv")


# same thing for mid-year population
download.file(url = "https://www.ine.es/jaxiT3/files/t/es/csv_bd/10256.csv?nocab=1",
              destfile = "data/pop.tsv")


# these are the only two files we need at this time.
# We do not need to commit these files in the repository,
# but it's good to archive them in case the website changes

# end
