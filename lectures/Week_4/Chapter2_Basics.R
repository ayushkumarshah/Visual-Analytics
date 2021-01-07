
# (x <- 1) is used to assign and display at same time
(x <- seq(1:6))
typeof(x)
class(x)
attributes(x)
length(x)
str(x) # structure of x

# c means combine or concatenate
(y <- c(1, 2, 3, 4, 5, 6))

# pairwise test for equality
x == y

# adding L forces to integer rather than double
y <- c(1L, 2L, 3L, 4L, 5L, 6L)

# still equal
x == y

# nesting doesn't alter a vector
(x <- c(1, 2, c(3, 4, c(5,6))))

z <- x==y
# z is a logical vector
typeof(z)
is.numeric(z)

as.numeric(z)
typeof(z)

(z <- x + y)

z[c(1,2,3)]
z[1:3]
z[c(1:3)]
