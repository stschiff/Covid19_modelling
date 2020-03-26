library(magrittr)
library(ggplot2)

stan_output <- readr::read_csv("output.csv", comment = "#")

rki_dat <- covid19germany::get_RKI_timeseries() %>%
  covid19germany::group_RKI_timeseries()

# Modelling the "true cases"

day_tbl <- tibble::tibble(days = 1:80) %>%
  dplyr::mutate(date = as.POSIXct("2020-01-24") + lubridate::days(days))
plot_curves <- stan_output %>%
  dplyr::select(alpha, gamma, delta, I0) %>%
  dplyr::mutate(id=1:nrow(stan_output)) %>%
  tidyr::expand_grid(day_tbl)
dplyr::mutate(plot_curves, true_cases = I0 * exp(days * alpha)) %>%
  ggplot() +
  geom_line(mapping = aes(x = date, y = true_cases, group = id), alpha=0.02) +
  geom_point(rki_dat, mapping = aes(x = Meldedatum, y = AnzahlFall)) +
  scale_y_log10() 

dplyr::mutate(plot_curves, predicted_testcases = I0 * exp((days - 8) * alpha) * gamma) %>%
  ggplot() +
  geom_line(mapping = aes(x = date, y = predicted_testcases, group = id), alpha=0.02) +
  geom_point(rki_dat, mapping = aes(x = Meldedatum, y = AnzahlFall)) +
  scale_y_log10() 

dplyr::mutate(plot_curves, predicted_deaths = I0 * exp((days - 17) * alpha) * delta) %>%
  ggplot() +
  geom_line(mapping = aes(x = date, y = predicted_deaths, group = id), alpha=0.02) +
  geom_point(rki_dat, mapping = aes(x = Meldedatum, y = AnzahlTodesfall)) +
  scale_y_log10() 
