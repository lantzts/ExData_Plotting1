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


png(file = "plot2.png", width = 480, height = 480, units = "px")
par(bg=NA)
with(data, plot(Global_active_power~datim, type = "l",
                ylab = "Global Active Power (kilowatts)", xlab = NA))
dev.off()

