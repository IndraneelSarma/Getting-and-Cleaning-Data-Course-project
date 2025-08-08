library(dplyr)
filename <- "Coursera_DS3_Final.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, y, x)
tidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
tidyData$code <- activities[TidyData$code, 2]
names(tidyData)[2] = "activity"
names(tidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(tidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(tidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(tidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(tidyData)<-gsub("^t", "Time", names(TidyData))
names(tidyData)<-gsub("^f", "Frequency", names(TidyData))
names(tidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(tidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(tidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))
FinalData <- tidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

