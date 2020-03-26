library(magrittr)

dat <- covid19germany::get_RKI_timeseries(cache=F) %>% covid19germany::group_RKI_timeseries()

day <- as.numeric(difftime(dat$Meldedatum, as.Date("2020-01-24"), units="days"))
cases <- dat$AnzahlFall
deaths <- dat$AnzahlTodesfall
N <- length(cases)
tau_t <- 8
tau_delta <- 17

dump(c("day", "cases", "deaths", "N", "tau_t", "tau_delta"), file="covid19_model.data.R")
