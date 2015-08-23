# PREVIOUS PREPARATION

# Check if plyr library is loaded.
if (!"package:plyr" %in% search()) {
  # If not, loaded plyr library
  library("plyr")
}


# Prepare zip file, directory and URL names
filedata <- "getdata-projectfiles-UCI HAR Dataset.zip"
dir <- "UCI HAR Dataset"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Check if zip file exists
if (!file.exists(filedata)) {
  # If not, download zip file
  download.file(url, filedata, method="curl")
}  
# Check if folder in zipped file exist
if (file.exists(dir)) {
  # If exists, delete it
  unlink("UCI HAR Dataset/",recursive = TRUE)
}

# Unzip file
unzip(filedata)

# Release(remove) names
rm(filedata, dir, url)




# PROJECT STEPS

# STEP 1: Merging datasets
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Loading raw data
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
subTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merging data
xData <- rbind(xTrain, xTest)
yData <- rbind(yTrain, yTest)
subData <- rbind(subTrain, subTest)

# Release(remove) loaded raw data
rm(xTrain, yTrain, subTrain, xTest, yTest, subTest)


# STEP 2: Extract measurements
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Loading features file
features <- read.table("UCI HAR Dataset/features.txt")

# Getting mean() or std() in their names
meanSD <- grep("-(mean|std)\\(\\)", features[, 2])

# Subsetting data
xData <- xData[, meanSD]
names(xData) <- features[meanSD, 2]

# Release(remove) loaded features file
rm(features, meanSD)


# STEP 3: Naming activities
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Loading activity labels file
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# Update names
yData[, 1] <- activities[yData[, 1], 2]
names(yData) <- "activity"

# Release(remove) loaded activity labels file
rm(activities)


# STEP 4: Labeling with descriptive variable names
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Change column name
names(subData) <- "subject"

# Binding entire data
Data <- cbind(xData, yData, subData)

# Release(remove) merged data
rm(xData, yData, subData)


# STEP 5: Creating tidy data
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tidyData <- ddply(Data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidyData, "tidyData.txt", row.name=FALSE)