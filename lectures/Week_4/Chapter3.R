# - filter()
# - arrange()
# - select()
# - mutate()
# - summarize()
# - group_by()

library(nycflights13)
library(tidyverse)

?flights
head(flights)

# 1. filter
filter(flights, month == 1, day == 1, origin=='LGA')

jan1 <- filter(flights, month == 1, day == 1, origin=='LGA')

(jan1 <- filter(flights, month == 1, day == 1, origin=='LGA'))

## Boolean operations
filter(flights, month == 1 & day != 1)
filter(flights, month == 1 | day != 1)
filter(flights, xor(month == 1 , day == 1))

## Filter Exercises
filter(flights, carrier %in% c('AA', 'DL', 'UA'))
filter(flights, month %in% c(7,8,9))
filter(flights, dep_delay > 60 & (dep_delay-arr_delay) > 30)
filter(flights, between(month, 7, 9))
filter(flights, is.na(dep_time))

# 2. arrange()
arrange(flights, year, month, day)
arrange(flights, desc(arr_delay))
arrange(flights, is.na(dep_time))
arrange(flights, desc(is.na(dep_time)))
arrange(flights, desc(dep_delay))
arrange(flights, dep_delay)
arrange(flights, distance / air_time * 60)

# 3. select()
## Select columns by name
select(flights, year, month, day)

# Select all columns between year and day (inclusive)
select(flights, year:day)

# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))

select(flights, starts_with("dep"))
# not case sensitive
select(flights, starts_with("DEP"))

select(flights, ends_with("time"))
select(flights, contains("_"))

select(flights, matches("(.)\\1")) #RE

## a destructive way to rename
## kills all unnamed columns
select(flights, tail_num=tailnum)

names(flights)

## better way to rename
rename(flights, tail_num = tailnum)

select(flights, time_hour, air_time, everything())
select(flights, carrier, carrier, carrier)

vars <- c("year", "month", "day")
select(flights, one_of(vars))
select(flights, contains("TIME"))
## Make case sensitive
select(flights, contains("TIME", ignore.case=FALSE))
select(flights, contains("TIME", ignore.case=TRUE))

help(select_helpers)

# 4. mutate()

flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time
)
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60
)

### Note that you can refer to columns that you’ve just created:
mutate(flights_sml,
         gain = arr_delay - dep_delay,
         hours = air_time / 60,
         gain_per_hour = gain / hours
  )

### If you only want to keep the new variables, use transmute():
transmute(flights,
            gain = arr_delay - dep_delay,
            hours = air_time / 60,
            gain_per_hour = gain / hours
  )

# Useful creation functions
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

if (!require(hexbin)) {
  install.packages("hexbin",dependencies=TRUE)
}

## Log example
ggplot(diamonds, aes(carat, price)) +
  geom_hex(bins=50)

diamonds2 <- diamonds %>%
  filter(carat <= 2.5) %>%
  mutate(lprice = log2(price), lcarat = log2(carat))

ggplot(diamonds2, aes(lcarat, lprice)) +
  geom_hex(bins=50)

## Offset
(x <- 1:10)
lag(x)
#> [1] NA 1 2 3 4 5 6 7 8 9
lead(x)
#> [1] 2 3 4 5 6 7 8 9 10 NA

## Cumulative aggregates
cumsum(x)
cummean(x)

## Ranking
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
#> [1] 1 2 2 NA 4 5
min_rank(desc(y))
#> [1] 5 3 3 NA 2 1

row_number(y)
#> [1] 1 2 3 NA 4 5
dense_rank(y)
#> [1] 1 2 2 NA 3 4
percent_rank(y)
#> [1] 0.00 0.25 0.25 NA 0.75 1.00
cume_dist(y)
#> [1] 0.2 0.6 0.6 NA 0.8 1.0

## Mutate() exrecise
attach(flights)
dep_time[dep_time == 2400] <- 0

flights2 <- mutate(flights, 
                   dep_minutes = dep_time %/% 100 * 60 + dep_time %% 100)

flights2 <- mutate(flights2, 
                   arr_minutes = arr_time %/% 100 * 60 + arr_time %% 100)
flights2 <- mutate(flights2, arr_minus_dep = arr_minutes - dep_minutes)

ggplot(flights2, aes(air_time, arr_minus_dep))+
  geom_point() + facet_wrap(~dest)

flights3 <- mutate(flights, delay_rank = min_rank(desc(dep_delay)))
most_delayed <- filter(flights3, delay_rank < 11)

arrange(most_delayed, delay_rank)

?min_rank
1:3 + 1:10

?trigonometry
??trigonometry
?Trig

# 5. summarize()
summarize(flights, avgdelay=mean(dep_delay, na.rm=TRUE))
mean(dep_delay, na.rm=TRUE)
## useful with group_by

# 6. group_by()
(by_day <- group_by(flights, year, month, day))
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))

# Combining operations with pipe\
## Boring way
by_dest <- group_by(flights, dest)
delay <- summarize(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")

## Using Pipeline
delays <- flights %>%
  group_by(dest) %>%
  summarize(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "HNL")

# It looks like delays increase with distance up to ~750 miles
# and then decrease. Maybe as flights get longer there's more
# ability to make up delays in the air?
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

## %>% read as then

## Missing values

not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay))

# Whenever you do any aggregation, it’s always a good idea to include
# either a count (n()), or a count of nonmissing values
# (sum(!is.na(x))). That way you can check that you’re not drawing
# conclusions based on very small amounts of data.

## Example
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10)

## Now visualizing count
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )
ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

## So, only 1 flight has large delay, better to remove low count data, 
## done below

## dplyr Plus ggplot
delays %>%
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

## Another esimilar g
if (!require(Lahman)) {
  install.packages("Lahman",dependencies=TRUE)
  library(Lahman)
}
batting <- as_tibble(Lahman::Batting)

batters <- batting %>%
  group_by(playerID) %>%
  summarize(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )
batters %>%
  filter(ab > 100) %>%
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)
#> `geom_smooth()` using method = 'gam'


not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    # average delay:
    avg_delay1 = mean(arr_delay),
    # average positive delay:
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

not_cancelled %>%
  group_by(dest) %>%
  summarize(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))

# When do the first and last flights leave each day?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    first = min(dep_time),
    last = max(dep_time)
  )

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    first_dep = first(dep_time),
    last_dep = last(dep_time)
  )

not_cancelled %>%
  group_by(year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))

# Which destinations have the most carriers?
not_cancelled %>%
  group_by(dest) %>%
  summarize(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

not_cancelled %>%
  count(dest)

## “count” (sum) the total number of miles a
## plane flew:
not_cancelled %>%
  count(tailnum, wt = distance)

# How many flights left before 5am? (these usually
# indicate delayed flights from the previous day)
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(n_early = sum(dep_time < 500))

# What proportion of flights are delayed by more
# than an hour?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(hour_perc = mean(arr_delay > 60))


## Grouping by multiple variables
daily <- group_by(flights, year, month, day)
(per_day <- summarize(daily, flights = n()))
(per_month <- summarize(per_day, flights = sum(flights)))
(per_year <- summarize(per_month, flights = sum(flights)))
