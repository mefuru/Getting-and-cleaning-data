# 1. Create a logical vector that identifies the households on greater than 10
# acres who sold more than $10,000 worth of agriculture products. Assign that
# logical vector to the variable agricultureLogical. Apply the which() function
# like this to identify the rows of the data frame where the logical vector is
# TRUE. which(agricultureLogical) What are the first 3 values that result?

df <- read.csv('getdata-data-ss06hid.csv')
agricultureLogical <- df$ACR==3 & df$AGS ==6
ans <- which(agricultureLogical)[1:3]

# 2. Using the jpeg package read in the following picture of your instructor
# into R https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the
# resulting data? (some Linux systems may produce an answer 638 different for
# the 30th quantile)

install.packages('jpeg')
library('jpeg')
img <- readJPEG("getdata-jeff.jpg", native = TRUE)
ans <- quantile(img, probs=c(0.3,0.8))

# 3. Load the Gross Domestic Product data for the 190 ranked countries in this
# data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# Load the educational data from this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode. How many of the IDs match? Sort
# the data frame in descending order by GDP rank (so United States is last).
# What is the 13th country in the resulting data frame?
# Original data sources: 
# http://data.worldbank.org/data-catalog/GDP-ranking-table 
# http://data.worldbank.org/data-catalog/ed-stats

gdprankings <- read.csv('getdata-data-GDP.csv', skip=4, stringsAsFactors = FALSE)
# Remove empty cols and ammend colnames
gdprankings[,3] <- gdprankings[,6] <- gdprankings[,7] <- gdprankings[,8] <- gdprankings[,9] <- gdprankings[,10]  <- NULL
colnames(gdprankings) <- c("abbreviation", "ranking", "economy", "gdp")
gdprankings <- gdprankings[gdprankings$abbreviation != "", ] # Remove entries w/ no abbreviation
gdprankings <- gdprankings[1:190,] ## Remove regions - just keep countries
gdprankings[,2] <- as.numeric(gdprankings[,2])
gdprankings[,4] <- gsub(",", "", gdprankings[,4]) # Remove "," to allow coercion
gdprankings[,4] <- as.integer(gdprankings[,4])
gdprankings <- gdprankings[order(gdp[,2], ] ## Order by "gdp" descending
gdprankings[1:13,]

# 4. What is the average GDP ranking for the "High income: OECD" and "High
# income: nonOECD" group?
edstats <- read.csv('getdata-data-EDSTATS_Country.csv', stringsAsFactors = FALSE)
mergeddata <- merge(gdprankings, edstats, by.x = "abbreviation", by.y = "CountryCode", all = FALSE)
res1 <- mean(mergeddata[mergeddata$Income.Group=="High income: OECD",]$ranking)
res2 <- mean(mergeddata[mergeddata$Income.Group=="High income: nonOECD",]$ranking)
ans <- c(res1, res2)

# 5. Cut the GDP ranking into 5 separate quantile groups. Make a table versus
# Income.Group. How many countries are Lower middle income but among the 38
# nations with highest GDP?
quantile(x = mergeddata$gdp, probs=c(0.2,0.4,0.6,0.8,1))