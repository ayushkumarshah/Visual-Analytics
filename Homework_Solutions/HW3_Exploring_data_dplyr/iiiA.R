## ----echo=FALSE---------------------------------------------------------------------------------------------------------
# This chunk is just to make it possible to shrink the typeface in succeeding chunks. Mainly this will be used for the crosstabs.
def.chunk.hook  <- knitr::knit_hooks$get("chunk")
knitr::knit_hooks$set(chunk = function(x, options) {
  x <- def.chunk.hook(x, options)
  ifelse(options$size != "normalsize", paste0("\\", options$size,"\n\n", x, "\n\n \\normalsize"), x)
})


## ----initialize---------------------------------------------------------------------------------------------------------
library(tidyverse)
library(data.table)
nyc311<-fread("311_Service_Requests_from_2010_to_Present.csv")
names(nyc311)<-names(nyc311) %>%
  stringr::str_replace_all("\\s", ".")
mini311<-nyc311[sample(nrow(nyc311),10000),]
write.csv(mini311,"mini311.csv")


## ----mapprep------------------------------------------------------------------------------------------------------------
install.packages("devtools",dependencies=TRUE, 
                 repos = "http://cran.us.r-project.org",
                 force = TRUE)
library(devtools)
if(!require("ggmap")) {
devtools::install_github("dkahle/ggmap", ref = "tidyup")
}


## ----mapdisplay---------------------------------------------------------------------------------------------------------
key<-"Google-API-key"
register_google(key = key)
nyc_map = get_map(location = c(lon= -73.9, lat= 40.7),
maptype = "terrain", zoom =12)
# There is a new update regarding google maps requirement
# for API key hence this code above is required.
map <- ggmap(nyc_map) +
geom_point(data=bla,aes(x=bla$Longitude,y=bla$Latitude),
           size= 0.4, alpha=0.2, color= "red") +
ggtitle("Map of bla and bleah") +
theme(plot.title = element_text(hjust = 0.5)) +
xlab("Longitude") + ylab("Latitude")
map

