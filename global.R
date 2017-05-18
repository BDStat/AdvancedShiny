library(dplyr)

attach("~/data.Rda")
cleantable <- set1 %>%
  select(
    Name = name,
    City = city,
    Rating = rating,
    Lat = latitude,
    Long = longitude,
    State = state
  )