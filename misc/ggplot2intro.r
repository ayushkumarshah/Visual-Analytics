# NVim-R is a plugin for Vim
cat("\033[2J\033[H") # clear screen

#                                        INTRODUCTION
library(tidyverse)
mpg
head(mpg)
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=hwy))

# Exercises
# 1.
ggplot(data=mpg)
# 2.
dim(mtcars)
dim(mpg)
summary(mtcars)
summary(mpg)
# 3.
?mpg
# 4.
ggplot(data=mpg) +
  geom_point(mapping = aes(x=cyl,y=hwy))
# a better-looking alternative
ggplot(data=mpg) +
  geom_jitter(mapping = aes(x=cyl,y=hwy))
# 5.
ggplot(data=mpg) +
  geom_point(mapping = aes(x=class,y=drv))

ggplot(data=mpg) +
  geom_jitter(mapping = aes(x=class,y=drv))

#                                        AESTHETIC MAPPINGS
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=hwy, color=class))
# a poor aesthetic mapping
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=hwy, size=class))
# another aesthetic mapping
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=hwy, alpha=class))
# yet another aesthetic mapping
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=hwy, shape=class))
# a manually set aesthetic mapping
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=hwy),color="blue")

# Exercises
# 1.
# messed up code
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=hwy,color="blue"))
# 2.
summary(mpg)
mpg
# 3.
# ggplot() will bin the colors
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=cty,color=displ))

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=cty,size=displ))
# shape doesn't work!
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=cty,shape=displ))
# 5.
?geom_point
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "white", fill = "black", size = 5, stroke = 2)
 
ggplot(data=mtcars) +
  geom_point(mapping = aes(x=disp,y=mpg, color=wt<3.500))

#                                        COMMON PROBLEMS

# reminder about putting + at the end of the line

#                                        FACETS
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy)) +
  facet_wrap(~ class, nrow=2)
# facet grid
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy)) +
  facet_grid(drv ~ cyl)
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy)) +
  facet_grid(cyl ~ drv)
# Exercises, page 15
# 1.
# facet on a continuous var
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy)) +
  facet_wrap(~ cty, nrow=2)
# 2.
ggplot(data=mpg) +
  geom_point(mapping=aes(x=drv,y=cyl))
# 3.
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy)) +
  facet_grid(drv~.)

ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy)) +
  facet_grid(.~cyl)

ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy)) +
  facet_wrap(~drv)

# 4.
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy)) +
  facet_wrap(~class,nrow=2)

ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy,color=class))

# 5.
?facet_wrap
# 6.
?facet_grid

# from the facet_grid() help page
     p <- ggplot(mpg, aes(displ, cty)) + geom_point()
     p + facet_grid(drv ~ cyl)
     p + facet_grid(cyl ~ drv)

#                                        GEOMETRIC OBJECTS
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy))

ggplot(data=mpg) +
  geom_smooth(mapping=aes(x=displ,y=hwy))

ggplot(data=mpg) +
  geom_smooth(mapping=aes(x=displ,y=hwy,linetype=drv))

ggplot(data=mpg) +
  geom_smooth(mapping=aes(x=displ,y=hwy,group=drv))

# Bottom of page 17
ggplot(data=mpg,mapping=aes(x=displ,y=hwy,color=drv)) +
  geom_point() +
  geom_smooth(mapping=aes(linetype=drv))

# page 18: http://rstudio.com/cheatsheets

# bottom of page 18: triplet
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
ggplot(data = mpg) +
  geom_smooth(
  mapping = aes(x = displ, y = hwy, color = drv),
  show.legend = FALSE )

# top of page 19: multiple geoms
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy)) +
  geom_smooth(mapping=aes(x=displ,y=hwy))
# same but with global mappings
ggplot(data=mpg,mapping=aes(x=displ,y=hwy)) +
  geom_point() +
  geom_smooth()

# extending or overwriting mappings for individual geoms
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
      geom_point(mapping = aes(color = class)) +
      geom_smooth()

# specify a subset in one geom
# and the whole dataset in another
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
      geom_point(mapping = aes(color = class)) +
      geom_smooth(
        data = filter(mpg, class == "subcompact"),
        se = FALSE )

# Exercises, pp. 20--21
# 1.
# Look at the ggplot2 cheatsheet

# 2.
ggplot(
  data = mpg,
  mapping = aes(x = displ, y = hwy, color = drv)
)+
  geom_point() +
  geom_smooth(se = FALSE)

# 3.
ggplot(data = mpg) +
      geom_smooth(
        mapping = aes(x = displ, y = hwy, color = drv),
) #show.legend = FALSE )

# 4.
?geom_smooth

# 5.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
         geom_point() +
         geom_smooth()

ggplot() +
  geom_point(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  )+
  geom_smooth(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  )

# 6.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(se=FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy,group=drv)) +
  geom_point() +
  geom_smooth(se=FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy,color=drv,group=drv)) +
  geom_point() +
  geom_smooth(se=FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color=drv)) +
  geom_smooth(se=FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color=drv)) +
  geom_smooth(se=FALSE, mapping=aes(linetype=drv))

# cribbed from Jeffrey Arnold
ggplot(data = mpg, mapping = aes(x = displ, y = hwy,color=drv)) +
  geom_point(shape = 21, colour = "white", fill = "white", size = 4, stroke = 2) +
  geom_point(mapping = aes(color=drv),size=3) 

#                                        STATISTICAL TRANSFORMATIONS
ggplot(data=diamonds) +
  geom_bar(mapping=aes(x=cut))

# find out the default stat for geom_bar()
?geom_bar

# gives the same result as above
ggplot(data=diamonds) +
  stat_count(mapping=aes(x=cut))

# a rowwise way to specify a tibble
demo <- tribble(
          ~a,      ~b,
          "bar_1", 20,
          "bar_2", 30,
          "bar_3", 40
)

# use a different stat than the default
ggplot(data = demo) +
  geom_bar(
    mapping = aes(x = a, y = b), stat = "identity"
  )

# a bar chart of proportion
ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, y = ..prop.., group = 1)
  )

# draw attention to the summary with stat_summary()
ggplot(data=diamonds)+
  stat_summary(
    mapping=aes(x=cut,y=depth),
    fun.ymin=min,
    fun.ymax=max,
    fun.y=median
  )

?stat_summary()

# Exercises, page 26

# 1.
?stat_summary()

?geom_pointrange()
ggplot(data=diamonds,aes(cut,depth))+
  geom_pointrange(
    stat="summary"
  )

# cribbed from Jeffrey Arnold, I think
ggplot(data=diamonds,aes(cut,depth))+
  geom_pointrange(
    stat="summary",
    fun.ymin=min,
    fun.ymax=max,
    fun.y=median
  )

# 2.
?geom_col()

?geom_bar()

# 3.
# read the ggplot2 cheatsheet

# 4.
?stat_smooth()

# 5.
# problem is that they use the entire sample of x
# values, as if you said group=cut

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..,group=1))

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = color, y = ..prop..,group=1)
  )

#                                        POSITION ADJUSTMENTS

# provides a colored outline around the bars
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, color = cut))

# provides completely colored bars
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))

# a stacked bar chart
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

# an identity position adjustment causes overlapping
# use alpha transparency to compensate partially
ggplot(
  data = diamonds,
  mapping = aes(x = cut, fill = clarity)
)+
  geom_bar(alpha = 1/5, position = "identity")

# or completely eliminate the fill so only the
# outlines of the bars are shown
ggplot(
  data = diamonds,
  mapping = aes(x = cut, color = clarity)
)+
  geom_bar(fill = NA, position = "identity")

# using position="fill" makes it easy to compare groups
ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = "fill"
  )

# position = "dodge" puts the bars side by side
ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = "dodge"
  )

# position= "jitter" ameliorates the overplotting problem
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy),
    position = "jitter"
  )

# Exercises, page 31

# 1.
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
          geom_point()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
          geom_jitter()

# 2.
?geom_jitter()

# 3.
?geom_count()

ggplot(diamonds,aes(cut,color))+geom_count()
ggplot(diamonds,aes(cut,color))+geom_jitter()
ggplot(diamonds,aes(cut,color))+geom_count()+geom_jitter()

# 4.
?geom_boxplot()
ggplot(data=mpg,mapping=aes(x=cyl,y=hwy)) +
  geom_boxplot(mapping=aes(group=cyl))

#                                         COORDINATE SYSTEMS

# first, a standard presentation
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
# then, flip it
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()+
  coord_flip()

# a geographic coordinate system example
nz<-map_data("nz")
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black")
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

# A ggplot is an object so you can use an assignment
# operator,  <-, with it. In the following
# specification, you are assigning it to the identifier
# "bar" and then reusing that object a couple of times.
#
# Up until now you have been relying on a side effect of
# the creation of these objects, which is to display
# them as they are created. When you use the assignment
# operator, that side effect vanishes and you have to
# name the object as a separate command to R to display
# it.

bar <- ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = FALSE,
    width = 1
  )+
  theme(aspect.ratio = 1) + labs(x = NULL, y = NULL)
# Now display it three different ways.
bar
# a sideways bar chart
bar+coord_flip()
# a coxcomb plot
bar+coord_polar()

# Exercises, page 33

# 1.
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))+
  coord_polar()
# oops! It's a coxcomb plot. A better solution from the
# online solutions of Jeffrey Arnold is
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill") +
  coord_polar(theta = "y")

# 2.
?labs()

# 3.
?coord_quickmap()

# 4.
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter() +
  geom_abline()

?coord_fixed()
?geom_abline()
