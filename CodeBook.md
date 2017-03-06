# The Code Book
## Input files for analysis
1. "./train/X_train.txt" - train data set. Contains 561 columns and 7352 rows with different measurements from accelerometers. Contains numeric value for each measurement. 

2. "./test/X_test.txt" - test data set. Contains 561 columns and 2947 rows with different measurements from accelerometers. Contains numeric value for each measurement.

3. "features.txt" - file with column names for the data sets.

4. "./train/y_train.txt" - file with activity types for each row of train data set. It's a numeric value from 1 to 5.

5. "./test/y_test.txt" - file with activity types for each row of train data set. It's a numeric value from 1 to 5.

6. "./tran/subject_train.txt" - file with subject types for each row of train data set. It's a numeric value from 1 to 30.

7. "./test/subject_test.txt" - file with subject types for each row of test data set. It's a numeric value from 1 to 30.

8. "activity_labels.txt" - the label for each activity. Contains two columns with numeric activity number and text labels for activities.

## Read files
Read all files with read.csv. Set header = FALSE and sep = "" into the next variables:

```R
col_names <- read.csv(file_names, header = FALSE, sep = "")
train <- read.csv(file_train, header = FALSE, sep = "")
test <- read.csv(file_test, header = FALSE, sep = "")
act_names <- read.csv(file_act_names, header = FALSE, sep = "", col.names = c("N", "activity"))
act_train <- read.csv(file_act_train, header = FALSE, sep = "")
act_test <- read.csv(file_act_test, header = FALSE, sep = "")
subj_train <- read.csv(file_subj_train, header = FALSE, sep = "", col.names = "subject")
subj_test <- read.csv(file_subj_test, header = FALSE, sep = "", col.names = "subject")
```

## Prepare data
1. Set column names.

```R
names(train) <- col_names[,2]
names(test) <- col_names[,2]
```
2. Merge data sets with subjects and activities.

```R
train <- cbind(train, act_train)
test <- cbind(test, act_test)
train <- cbind(train, subj_train)
test <- cbind(test, subj_test)
```

3. Merge activities names with activity numbers.

```R
train <- merge(train, act_names, by.x = "V1", by.y = "N")
test <- merge(test, act_names, by.x = "V1", by.y = "N")
```

4. Merge test and train measurements.

```R
mset <- rbind(train, test)
```

## Make analysis
1. Take neccessary column labels. I use escape "\\(" to avoid such columns 'fBodyBodyGyroMag-meanFreq()'.

```R
coln <- grep("mean\\(|std\\(|activity|subject", names(mset), value = TRUE)
```

2. Subset mset data test.

```R
mset <- mset[, coln]
```

3. Create a new data set with average of each variable for each activity and each subject.

```R
new_mset <- mset %>% group_by(subject, activity) %>% summarise_each(funs(mean))
```
