## ----echo=FALSE------------------------------------------------------------------------------------------------------------
# This chunk is just to make it possible to shrink the typeface in succeeding chunks. Mainly this will be used for the crosstabs.
def.chunk.hook  <- knitr::knit_hooks$get("chunk")
knitr::knit_hooks$set(chunk = function(x, options) {
  x <- def.chunk.hook(x, options)
  ifelse(options$size != "normalsize", paste0("\\", options$size,"\n\n", x, "\n\n \\normalsize"), x)
})


## ----initialize------------------------------------------------------------------------------------------------------------
library(tidyverse)
library(data.table)
# fast for when you are starting out:
nyc311<-fread("311_Service_Requests_from_2010_to_Present.csv",nrow=10000)
# after you get going:
# nyc311<-fread("311_Service_Requests_from_2010_to_Present.csv")
names(nyc311)<-names(nyc311) %>%
  stringr::str_replace_all("\\s", ".")


## ----tabulate, results="asis"----------------------------------------------------------------------------------------------
library(xtable)
options(xtable.comment=FALSE)
options(xtable.booktabs=TRUE)
narrow<-nyc311 %>%
  select(Agency,
	 Complaint.Type,
	 Descriptor,
	 Incident.Zip,
	 Status,
	 Borough)
xtable(head(narrow))


## ----explore---------------------------------------------------------------------------------------------------------------
bigAgency <- narrow %>%
  group_by(Agency) %>%
  summarize(count=n()) %>%
  filter(count>1000)
bigAgency$Agency<-factor(bigAgency$Agency,
  levels=bigAgency$Agency[order(bigAgency$count)])
p<-ggplot(bigAgency,aes(x=Agency,y=count)) +
   geom_bar(stat="identity") +
   coord_flip()
p

s1 <- ggplot(narrow) +
      geom_bar(mapping = aes(Status, fill = Borough), position="fill") +
      coord_flip() +
      ggtitle("Status of SR Submitted in different Boroughs")

s2 <- ggplot(narrow) +
  geom_bar(mapping = aes(Status, fill = Borough), show.legend = FALSE) +
  coord_flip()

if (!require(gridExtra)) {
  install.packages("gridExtra",dependencies=TRUE)
  library(gridExtra)
}

grid.arrange(s1, s2, nrow = 2)

top_complaints <- narrow %>%
  group_by(Complaint.Type) %>%
  summarize(count=n()) %>%
  filter(count>200000)

top_complaints$Complaint.Type <- factor(top_complaints$Complaint.Type,
          levels=top_complaints$Complaint.Type[order(top_complaints$count)])

t <- ggplot(top_complaints,aes(Complaint.Type,count, fill=Complaint.Type)) +
  geom_bar(stat="identity", show.legend = FALSE) +
  coord_polar() +
  xlab("Complaint Type") +
  ggtitle("Common complaint types")

t

complaint_types <- narrow %>%
  group_by(Complaint.Type, Borough) %>%
  summarize(Complaints = length(Complaint.Type)) %>%
  filter(Complaints>100000)

ct <- ggplot(complaint_types) + 
  geom_bar(stat="identity", aes(x=Complaint.Type, y=Complaints, 
                                fill=Complaint.Type),
           show.legend = FALSE) + 
  facet_wrap(~ Borough) +
  coord_flip() +
  xlab("Complaint Type") +
  ggtitle("Top Complaints by Type in different Boroughs")

ct

df<-nyc311 %>%
  select(Agency,
         Complaint.Type,
         Descriptor,
         Incident.Zip,
         Status,
         Borough,
         Created.Date,
         Closed.Date)
xtable(head(df))

df$Response.Time.hrs <- as.numeric(difftime(as.Date(as.character(df$Closed.Date), 
                                              format="%m/%d/%Y %H:%M:%S %p"), 
                                      as.Date(as.character(df$Created.Date), 
                                              format="%m/%d/%Y %H:%M:%S %p")
                                      , units = "hours")) 

df <- df[df$Response.Time.hrs > 0]
cat("Average response time = ", mean(df$Response.Time.hrs) %/% 24 , "days")
  

## ----crosstabs, size='footnotesize'----------------------------------------------------------------------------------------
xtabA<-dplyr::filter(narrow,
  Complaint.Type=='HEATING' |
  Complaint.Type=='GENERAL CONSTRUCTION' |
  Complaint.Type=='PLUMBING'
)
xtabB<-select(xtabA,Borough,Complaint.Type)
library(gmodels)
CrossTable(xtabB$Borough,xtabB$Complaint.Type)

filtered_status<-dplyr::filter(narrow,
                       Status=='Closed' |
                       Status=='Open' |
                       Status=='Pending'
)
CrossTable(filtered_status$Borough,filtered_status$Status)

xtabC<-select(xtabA,Status,Complaint.Type)
CrossTable(xtabC$Status,xtabC$Complaint.Type)
