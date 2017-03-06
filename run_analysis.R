## Connect library
library(dplyr)

## file path
# train data set
file_train <- "./train/X_train.txt"
# column names
file_names <- "features.txt"
# test data set
file_test <- "./test/X_test.txt" 
# activities for test data set
file_act_test <- "./test/y_test.txt"
# activities for train data set
file_act_train <- "./train/y_train.txt"
# activities names file
file_act_names <- "activity_labels.txt"
# subject fules
file_subj_train <- "./train/subject_train.txt"
file_subj_test <- "./test/subject_test.txt"

## Read files with appropriate column names
col_names <- read.csv(file_names, header = FALSE, sep = "")
train <- read.csv(file_train, header = FALSE, sep = "")
test <- read.csv(file_test, header = FALSE, sep = "")
act_names <- read.csv(file_act_names, header = FALSE, sep = "", col.names = c("N", "activity"))
act_train <- read.csv(file_act_train, header = FALSE, sep = "")
act_test <- read.csv(file_act_test, header = FALSE, sep = "")
subj_train <- read.csv(file_subj_train, header = FALSE, sep = "", col.names = "subject")
subj_test <- read.csv(file_subj_test, header = FALSE, sep = "", col.names = "subject")

## Set names
names(train) <- col_names[,2]
names(test) <- col_names[,2]

## Merge data sets and activity
train <- cbind(train, act_train)
test <- cbind(test, act_test)
train <- cbind(train, subj_train)
test <- cbind(test, subj_test)

## Merge activities names with activity numbers
train <- merge(train, act_names, by.x = "V1", by.y = "N")
test <- merge(test, act_names, by.x = "V1", by.y = "N")

## Merge test and train measurements
mset <- rbind(train, test)

## Extract only the measurements on the mean and standard deviation for each measurement.
# take neccessary column labels. I use escape "\\(" to avoid such columns 'fBodyBodyGyroMag-meanFreq()'
coln <- grep("mean\\(|std\\(|activity|subject", names(mset), value = TRUE)
# subset mset data test
mset <- mset[, coln]

## create new data set with means for each activity and subject
new_mset <- mset %>% group_by(subject, activity) %>% summarise_each(funs(mean))

## The Result!
new_mset