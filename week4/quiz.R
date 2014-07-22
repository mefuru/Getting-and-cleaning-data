#1.
df <- read.csv("getdata-data-ss06hid.csv")
ans <- strsplit(names(df), "wgtp")[123]

# 2.
gdprankings <- read.csv('getdata-data-GDP.csv', skip=4, stringsAsFactors = FALSE)
# Remove empty cols and ammend colnames
gdprankings[,3] <- gdprankings[,6] <- gdprankings[,7] <- gdprankings[,8] <- gdprankings[,9] <- gdprankings[,10]  <- NULL
colnames(gdprankings) <- c("abbreviation", "ranking", "economy", "gdp")
gdprankings <- gdprankings[gdprankings$abbreviation != "", ] # Remove entries w/ no abbreviation
gdprankings <- gdprankings[1:190,] ## Remove regions - just keep countries
gdprankings[,2] <- as.numeric(gdprankings[,2])
gdprankings[,4] <- gsub(",", "", gdprankings[,4]) # Remove "," to allow coercion
gdprankings[,4] <- as.integer(gdprankings[,4])
ans <- mean(gdprankings[,4])

# 3
countryNames <- gdprankings$economy
countryNamesBeginWithUnited <- countryNames[grep("^United",countryNames)]
ans <- length(countryNamesBeginWithUnited)

# 4.
edstats <- read.csv('getdata-data-EDSTATS_Country.csv', stringsAsFactors = FALSE)
mergeddata <- merge(gdprankings, edstats, by.x = "abbreviation", by.y = "CountryCode", all = FALSE)
## Fiscal year end data is included in the Special.Notes column
specialnotes <- mergeddata$Special.Notes
## Special.Notes that contain Jun/jun
specialnoteswithjune <- specialnotes[(grep("[jJ]une", specialnotes))]
## Filter to notes that contain fiscal year end
specialnoteswithjune[(grep("[fF]iscal", specialnoteswithjune))]
ans <- nrow(specialnoteswithjune[(grep("[fF]iscal", specialnoteswithjune))])

# 5.
install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
formatdates <- format(sampleTimes, "%a %y")
values12 <- formatdates[grep("12", formatdates)] ## Subset on dates in 2012
valuesMonday12 <- values12[grep("Mon", values12)] ## Subset on Mondays
ans <- c(length(values12), length(valuesMonday12))
