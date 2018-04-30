# This scripts plots the data necessary to rebuild the image plot1.pngplot_1

# We will load data from the following location:
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","power_consumption.zip")
unzip("power_consumption.zip")

#list.files()
#read.table("household_power_consumption.txt", nrows=3)

# How much memory are we likely to need
# mem_test <- read.table("household_power_consumption.txt", nrows=200, sep=";", header=TRUE)
# subset_size <- as.numeric(object.size(mem_test))
# no_lines <- system("wc -l household_power_consumption.txt", intern = TRUE)
# no_lines <- as.numeric(strsplit(no_lines, " ")[[1]][2])

# est_mem_requirement_bytes <- (no_lines / 200) * subset_size
# mem_meg_bytes <- est_mem_requirement_bytes / 1000000
# guessing it's less than a GB of memory, maybe less that 500MB

library(lubridate)

house_power <- read.table("household_power_consumption.txt", sep=";", header=TRUE)
# turns out to be only 83MB!

house_power$DateTime <- strptime(paste0(house_power$Date,house_power$Time), "%d/%m/%Y %H:%M:%S")
house_power$Date <- strptime(house_power$Date, "%d/%m/%Y")
house_power_subset <- subset(house_power, house_power$Date >= strptime("2007-02-01", "%Y-%m-%d") & house_power$Date <= strptime("2007-02-02", "%Y-%m-%d"))
house_power_subset2 <- subset(house_power_subset, Global_active_power != '?')

png(filename = "plot3.png",width = 480, height = 480)

with(house_power_subset2, plot(DateTime, as.numeric(as.character(Sub_metering_1)),type="n", xlab="", ylab=""))
lines(house_power_subset2$DateTime, as.numeric(as.character(house_power_subset2$Sub_metering_1)))
lines(house_power_subset2$DateTime, as.numeric(as.character(house_power_subset2$Sub_metering_2)), col="red")
lines(house_power_subset2$DateTime, as.numeric(as.character(house_power_subset2$Sub_metering_3)), col="blue")
title(main="", sub="", 
      ylab="Energy sub metering", xlab="DateTime")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=c(1,1,1),
lwd=c(2.5,2.5, 2.5),col=c("black","red","blue"))

dev.off()
