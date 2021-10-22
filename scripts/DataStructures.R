# R is like a fast calculator

232047294879347 * 242424 / 12313 + 2

# in R <- is used to assign a value to a variable. You can also use =

test_variable <- 232047294879347 * 242424 / 12313 + 2
test_variable

#you can use rm() to remove a variable, object
rm(test_variable)
test_variable = 2
test_variable

# you do not have to remove to update or change the variable
# and you can change the variable using it's own value
test_variable <- test_variable * test_variable
test_variable

#### The datatype of each variable is inferred

#### R's datatypes 

# Logical is either TRUE or FALSE
variable <- FALSE 
class(variable)

# Numeric is a number that can include fractual parts, i.e. 2.34 
variable <- 2.34 
class(variable)

# Integer is a whole number
variable <- 2L 
variable
class(variable)

##### Sidetrack

# Integers are cheaper than Numerics
object.size(c(1L,2L,3L,4L,5L)) < object.size(c(1,2,3,4,5))
# Unless they are empty
object.size(numeric()) == object.size(integer())
# Than they are both 48bytes
object.size(numeric())

##### Back to data types

# You can also express complex numbers
variable <- 3 + 2i
variable
class(variable)
# And plot them
plot(variable)

# Strings are called characters in R
variable <- "hello world"
variable
class(variable)

# And there is also raw data
variable <- charToRaw(variable)
variable
class(variable)

# raw objects are small. empty raw objects are also 48bytes though

object.size(raw())

### The types you will use most are characters, numeric, and logical

### Technically everything that you have produced so far are vectors
### Vectors can be combined using the c() function

VectorA <- 2
VectorB <- c(1L,2L)
c(VectorA,VectorB)
class(c(VectorA,VectorB))
class(c(VectorB))

### A list is an R-object which can contain many different types
### like vectors, functions and even another list inside it.

list(VectorA, VectorB, list(VectorA, VectorB), mean)

### A matrix is a two-dimensional rectangular data set of ONE data type. 
### It can be created using a vector input to the matrix function.
### Create a matrix.
M <- matrix( c('a','a','b','c','b','a'), nrow = 2, ncol = 3, byrow = TRUE)
M

# Hold on, how does the matrix() function work
?matrix

# Compare
M <- matrix(c('a','a','b','c','b','a'), nrow = 2, ncol = 3, byrow = FALSE)
M

# Got it?

### A factor stores the vector and all its unique values
# Create a vector.
apples <- c('iOS','iPhone','MBP','iPhone','MBP')
# Create a factor object.
factor_apples <- factor(apples, levels = c("iOS", "iPhone", "MBP", "Mac"), ordered = T)
factor(apples)

# Have a look
apples
factor(apples)
factor_apples
nlevels(factor_apples)
factor_apples[4]
as.character(factor_apples[4])

### Data Frames are mixed data presented in tabular form
# Create the data frame.
data_types <- data.frame(
  types = c("logical", "numerical","integer", "complex", "character", "raw"), 
  usage_probability = c(1, 1, 1, 0.1, 1, 0.5), 
  got_it = c(rep("yes", 5), "no"),
  answer = rep(42L, 6)
)
boxplot(usage_probability ~ types, data_types)

# Aside from Base R function, you can include
# third party function, objects, and data
# via library

library(tidyverse)

# but before you can use the library, you have to
# install it with the install.packages() function

install.packages("tidyverse")

# you only have to do it once on each new system
# or after upgrading your R version

library(tidyverse)

# The tidyverse package is a library that contains
# a lot of useful features and it is the package, I use
# in almost every R programme
# It has also change the dataframe type to a more modern
# object called tibble

data_types_tibble <- as_tibble(data_types)

# Let's have a look
data_types
data_types_tibble


# Data Structures often used in programming ####

# Strings and arrays

## string in R

newString <- "test"
length(newString)
nchar(newString)
gregexpr('e', newString)[[1]][1]
substr(newString, 2, 2)

##one dimensional arrays of simple types in R are best expressed as vectors. 
# there is the datatype array in R which can deal with multidimensionional array

intArray <- c(7L,8L,9L,10L)
length(intArray)
intArray 

## sidetrack, you do not need to remember this
intRealArray <- array(c(7L,8L,9L,10L),dim = c(4))
intRealArray

## hash tables
## R uses something like it that is called environment and lists
## there is a hashmap library though

# Linked Lists
## linked list are directly implemented in R using list
## R does the memory management for you... ... 

lst <- list() # creates an empty (length zero) list
lst
lst[[1]] <- 1 # automagically extends the lst
lst[[2]] <- 2 # ditto
lst

lst <- vector("list", 5)
lst
lst <- list(1, 2, 3, 4, 5)
lst
lst <- lst[-2]
lst

# Tree  
## Tree is just a list of lists
## (R likes copying (a lot), so if you want to store the data as a more complex graph, you need to use a graph db)

tree <- list(list(1, 2), list(3, list(4, 5)))

# left child: list(1, 2)
tree[[1]]

# right child
tree[[2]]

# left child of right child:list(4, 5)
tree[[2]][[1]]

