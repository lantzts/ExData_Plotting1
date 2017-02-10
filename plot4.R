library("lubridate")

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# init the party

if(!file.exists('./data-zip')){dir.create('./data-zip')}
if(!file.exists('./data')){dir.create('./data')}
if(!file.exists('./data-zip/proj-files.zip')){
        fileurl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        download.file(fileurl, destfile = './data-zip/proj-files.zip')
        unzip(zipfile = './data-zip/proj-files.zip',
              exdir = './data')
}

rm(fileurl)

filename <- list.files("./data", full.names = TRUE)
sod <- grep("1/2/2007", readLines(filename))[1]
eod <- grep("3/2/2007", readLines(filename))[1] 
lod <- eod - sod

header <- read.table(filename, sep = ";", nrows = 1)

data <- read.table(filename, sep = ";", skip = sod - 1, nrows = lod,
                   header = FALSE, na.strings = "?",stringsAsFactors = FALSE)

colnames(data) <- unlist(header)
data$datim <- dmy_hms(with(data, paste(Date, Time)))


png(file = "plot4.png", width = 480, height = 480, units = "px")
par(mfrow = c(2,2))

with(data, plot(Global_active_power~datim, type = "l",
                ylab = "Global Active Power", xlab = NA))

with(data, plot(Voltage~datim, type = "l",
                ylab = "Voltage"))

with(data, {
        plot(Sub_metering_1~datim, type = "n",
             ylab = "Energy sub metering", xlab = NA)
        lines(datim, Sub_metering_1)
        lines(datim, Sub_metering_2, col = cbPalette[2])
        lines(datim, Sub_metering_3, col = cbPalette[3])
        legend("topright", bty = "n",
               legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
               lty = c(1,1,1), col = c("black",cbPalette[2],cbPalette[3]))
})

with(data, plot(Global_reactive_power~datim, type = "l"))


dev.off()

