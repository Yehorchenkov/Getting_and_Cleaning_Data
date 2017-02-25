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

## Read files with appropriate column names
col_names <- read.csv(file_names, header = FALSE, sep = "")
train <- read.csv(file_train, header = FALSE, sep = "", col.names = col_names$V2)
test <- read.csv(file_test, header = FALSE, sep = "", col.names = col_names$V2)
act_names <- read.csv(file_act_names, header = FALSE, sep = "", col.names = c("N", "activity"))
act_train <- read.csv(file_act_train, header = FALSE, sep = "")
act_test <- read.csv(file_act_test, header = FALSE, sep = "")

## Merge activities names with activity numbers
m_act_train <- merge(act_train, act_names, by.x = "V1", by.y = "N")
m_act_test <- merge(act_test, act_names, by.x = "V1", by.y = "N")
# rename new column
#colnames(m_act_train)[m_act_train$activity] <- "activity"
#colnames(m_act_test)[m_act_test$activity] <- "activity"

## Merge data sets and activity
train <- cbind(train, m_act_train)
test <- cbind(test, m_act_test)

## Merge test and train measurements
mset <- rbind(train, test)

## Extract only the measurements on the mean and standard deviation for each measurement.
# take neccessary column labels. I use escape "\\." to avoid such columns 'fBodyBodyGyroMag-meanFreq()'
coln <- grep("mean\\.|std\\.|activity", names(mset), value = TRUE)
# subset mset data test
mset <- mset[, coln]

## create new data set with means for each activity and subject
# split data set by activities
s <- split(mset, mset$activity)
# calculate mean for each column except the last "activity"
new_mset <- sapply(s, function(x){colMeans(x[, 1:ncol(mset)-1], na.rm = TRUE)})

## The Result!
new_mset