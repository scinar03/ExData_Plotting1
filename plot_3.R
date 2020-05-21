rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(dplyr)
library(lubridate)
#####Loading the data#####
fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile = "./dt.zip", method = "curl")
#List all files and paths
as.character(unzip("./dt.zip", list = TRUE)$Name) 
#[1] "household_power_consumption.txt"
#Saving the dataset
hpc_orig <- read.table(unzip("./dt.zip", files = "household_power_consumption.txt", overwrite = TRUE), 
                       sep=";", header = TRUE, stringsAsFactors = FALSE)

####Quick data preparation
#Filter and replace missing values
hpc<-hpc_orig%>%filter(Date %in% c('2/2/2007','1/2/2007'))%>%mutate_all(~ replace(.,.=='?', NA))
#Create combined date/time variable
hpc$date_time<-dmy_hms(paste(hpc$Date,hpc$Time))
hpc$Global_active_power<-as.numeric(hpc$Global_active_power)

####Creating the vizual:
png(file="./plot_3.png",  width = 480, height = 480, units = "px")

with(hpc, plot(date_time, Sub_metering_1, type = "n",  ylab = "Energy Sub Metering",
               xlab = "", main = ""))
with(hpc, points(date_time, Sub_metering_1, type = "l",  
                 xlab = "", main = ""))
with(hpc, points(date_time, Sub_metering_2, type = "l", 
                 xlab = "", main = "", col='red'))
with(hpc, points(date_time, Sub_metering_3, type = "l",  
                 xlab = "", main = "", col='blue'))
legend("topright", lwd=1, col = c("black","blue", "red"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3")  )

dev.off()


