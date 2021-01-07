# EDA

Ask questions about data.

- What kind of variation occurs within variables?
- What kind of covariation occurs between variables?

## Variation

### Bar chart 

(`geom_bar`)to visualize variation in categorical variables.

### Histogram 
(`geom_hist` and `freq_poly`) to visualize variation in continuous variables.

### Categorical and continuous together using color parameter for categorical variable.

### Typical values

Set bin_width to a very low value to find most common and
rare values.

### Unusual values

To make it easy to see the unusual values, zoom in to small
values of the y-axis with `coord_cartesian(ylim=c(0,upper_limit))`.

Note: ggplot's xlim and ylim thro away the data whereas this doesn't.

### Missing Values

2 options to deal with unusual data:

1. Drop the entire row with the strange values:

```r
diamonds2 <- diamonds %>%
filter(between(y, 3, 20))
```

2. Replace unusual data with missing values. (Better)

```r
diamonds2 <- diamonds %>%
mutate(y = ifelse(y < 3 | y > 20, NA, y))
```

To suppress missing data removed warning in ggplot,

```r
ggplot(....) +
geom_point(na.rm=TRUE)
```


## Covariation

If variation describes the behavior within a variable, covariation
describes the behavior between variables. Covariation is the tendency
for the values of two or more variables to vary together in a
related way.

### A categorical and a continuous

- freq_poly with `y = ..density..` to change y-axis instead of count to compare different
categories (which have different distribution) fairly.

- box_plot

### 2 categorical variables

geom_tile

### 2 continuous variables

- Scatter_plots
- For huge data, add transparency using alpha for better visualization.
- Other options are Hex_bin (`geom_hex`) and `geom_bin2d`
- Treat one continuous variable as categorical by binning it and then use
    previous techniques (1 categorical and 1 continuous).

## Patterns and models

**Patterns**

Patterns in your data provide clues about relationships. If a systematic
relationship exists between two variables it will appear as a pattern
in the data.

Patterns reveal covariation. If variation is a phenomenon
that creates uncertainty, covariation is a phenomenon that
reduces it. If two variables covary, you can use the values of one
variable to make better predictions about the values of the second. If
the covariation is due to a causal relationship (a special case), then
you can use the value of one variable to control the value of the second.

**Models**

Models are a tool for extracting patterns out of data

```r
library(modelr)
mod <- lm(log(price) ~ log(carat), data = diamonds)
```


