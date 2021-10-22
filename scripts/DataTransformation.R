library(nycflights13)
library(tidyverse)

# focus on dplyr, using nycflights13 as example
flights
?nycflights13::flights

# dplyr main functions
# - Pick observations by their values (filter()).
# - Reorder the rows (arrange()).
# - Pick variables by their names (select()).
# - Create new variables with functions of existing variables (mutate()).
# - Collapse many values down to a single summary (summarise()).
# - all can be used in conjunction with group_by()

# filter()
filter(flights, month == 1, day == 1)

# if you want it saved
jan1 <- filter(flights, month == 1, day == 1)

# what is happening here?
(dec25 <- filter(flights, month == 12, day == 25))

# why is this wrong?
filter(flights, month = 1)

# ==, !=, <, >, <=, >=
# but be careful with == with doubles
# the computer attempts to be too precise for some math...
sqrt(2) ^ 2 == 2
1 / 49 * 49 == 1
x <- sqrt(2) ^ 2
x
x == 2
x - 2


# the smallest double is not 0, it is:
.Machine$double.eps

# use near instead
near(sqrt(2) ^ 2,  2)
near(1 / 49 * 49, 1)
?near
?.Machine

# boolean operations
# x, !x, x&y, x|y, xor(x,y)

# this works
filter(flights, month == 11 | month == 12)

# this does not
filter(flights, month == 11 | 12)
11 | 12
as.numeric(11 | 12)

# this works again
nov_dec <- filter(flights, month %in% c(11, 12))

# this produces the same results
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

identical(filter(flights, !(arr_delay > 120 | dep_delay > 120)), filter(flights, arr_delay <= 120, dep_delay <= 120))
identical(1L, 1)

# missing values are contagious
NA > 5
10 == NA
NA + 10
NA / 2
NA == NA

# Let x be Mary's age. We don't know how old she is.
x <- NA

# Let y be John's age. We don't know how old he is.
y <- NA

# Are John and Mary the same age?
x == y
# We don't know!

is.na(x)

df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

## EXERCISES

# 1. Find all flights that
#   a. Had an arrival delay of two or more hours
#   b. Flew to Houston (IAH or HOU)
#   c. Were operated by United, American, or Delta
#   d. Departed in summer (July, August, and September)
#   e. Arrived more than two hours late, but didn’t leave late
#   f. Were delayed by at least an hour, but made up over 30 minutes in flight
#   g. Departed between midnight and 6am (inclusive)
# 2. Another useful dplyr filtering helper is between(). What does it do? Can you use it to simplify the code needed to answer the previous challenges?
# 3. How many flights have a missing dep_time? What other variables are missing? What might these rows represent?
# 4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? Can you figure out the general rule? (NA * 0 is a tricky counterexample!)

# arrange()

arrange(flights, year, month, day)
arrange(flights, desc(dep_delay))
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

## EXERCISES

# 1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
# 2. Sort flights to find the most delayed flights. Find the flights that left earliest.
# 3. Sort flights to find the fastest flights.
# 4. Which flights travelled the longest? Which travelled the shortest?

# select()
# Select columns by name
select(flights, year, month, day)
# Select all columns between year and day (inclusive)
select(flights, year:day)
# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))
select(flights, starts_with("d"))
select(flights, ends_with("r"))
select(flights, contains("ea"))
select(flights, matches("(.)\\1"))
select(flights, num_range("x", 1:3))

# while select can be used to rename columns there is a better function
rename(flights, tail_num = tailnum)

# you can use select to move columns by using the helper function everything()
select(flights, time_hour, air_time, everything())

## EXERCISES
# 1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
# 2. What happens if you include the name of a variable multiple times in a select() call?
# 3. What does the one_of() function do? Why might it be helpful in conjunction with this vector?
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
# 4. Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?
select(flights, contains("TIME"))

# mutate()
# smaller tibble
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)

# create new columns
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)

# use columns you created in the same call
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

# use transmute to only keep created columns
transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

# math operation with fixed numbers use recylcing
# +, -, *, /, ^
# x / sum(x) proportion
# y - mean(y) difference from mean
# integer division %/% and remainder %%

transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

# logs: log(), log2(), log10()
# leading and lagging
(x <- 1:10)
lag(x)
lead(x)

(examplA <- c(22, 26, 30, 34, 38, 42))
examplA - lag(examplA)
unique(examplA - lag(examplA))[!unique(examplA - lag(examplA)) %in% NA]

# cummulative functions
cumsum(x)
cummean(x)
cumprod(x)
cummin(x)
cummax(x)

# logical operations
# <, <=, >, >=, !=, and ==

# ranking
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))

# If min_rank() doesn’t do what you need, look at the variants row_number(), dense_rank(), percent_rank(), cume_dist(), ntile(). See their help pages for more details.

## EXERCISES
# 1. Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.
# 4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().
# 5. What does 1:3 + 1:10 return? Why?

# summarise()

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

mean(flights$dep_delay, na.rm=TRUE)

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

# pipe

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

ggplot(data = delays, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# alternative to na.rm

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# counts

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# other summing functions
# aside from mean(x) there is also median(x)
# logical subsetting

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

# sd(x), IQR(x), mad(x)  

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

# groupin multiple variables and ungroup
daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year  <- summarise(per_month, flights = sum(flights)))

daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())  # all flights

# EXERCISES

# 4. Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?
# 5. Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))

