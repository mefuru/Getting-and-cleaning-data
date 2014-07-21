# Q1.
library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications
#    Insert your values below - if secret is omitted, it will look it up in
#    the GITHUB_CONSUMER_SECRET environmental variable.
#
#    Use http://localhost:1410 as the callback url

# Set environment variables:
# Sys.setenv(GITHUB_CONSUMER_SECRET = "hooty”)

myapp <- oauth_app("github", "3141f794331d97eee6b6")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)

username <- "jtleek"
url <- paste("https://api.github.com/users/", username, "/repos", sep="")
req <- GET(url, gtoken)
stop_for_status(req)
content(req)
numRepos <- length(content(req))
repoName <- "datasharing"
for(i in 1:numRepos) {
    if(content(req)[[i]]$name == repoName) print(content(req)[[i]]$"created_at")
}

# OR:
# req <- with_config(gtoken, GET(url))
# stop_for_status(req)
# content(req)
# numRepos <- length(content(req))
# repoName <- "datasharing"
# for(i in 1:numRepos) {
#     if(content(req)[[i]]$name == repoName) print(content(req)[[i]]$"created_at")
# }


#Q2
install.packages("sqldf")
library("sqldf")
acs <- read.csv("getdata-data-ss06pid.csv")
sqldf("select pwgtp1 from acs where AGEP < 50")

# Q3
sqldf("select distinct AGEP from acs")$AGEP == unique(acs$AGEP)

# Q4
download.file("http://biostat.jhsph.edu/~jleek/contact.html", "contact.html", method="curl")
htmlData <- readLines("contact.html")
countLines <- nchar(c(htmlData[10], htmlData[20], htmlData[30], htmlData[100]))
# [1] 45 31  7 25

#Q5
# Read a table of fixed width formatted data into a data.frame.
# Skip first four lines and manually enter col widths
sstData <- read.fwf("getdata-wksst8110.for", widths=c(10,5,4,4,5,4), skip=4)
sumCol4 <- sum(sstData$V6)
# [1] 32426.7