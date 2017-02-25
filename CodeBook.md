# The Code Book
## Input files for analysis
1. "./train/X_train.txt" - train data set. Contains 561 columns and 7352 rows with different measurements from accelerometers. Contains numeric value for each measurement. 

2. "./test/X_test.txt" - test data set. Contains 561 columns and 2947 rows with different measurements from accelerometers. Contains numeric value for each measurement.

3. "features.txt" - file with column names for the data sets.

4. "./train/y_train.txt" - file with activity types for each row of train data set. It's numeric value from 1 to 5.

5. "./test/y_test.txt" - file with activity types for each row of train data set. It's numeric value from 1 to 5.

6. "activity_labels.txt" - the label for each activity. Contains two columns with numeric activity number and text labels for activities.

## Read files
Read all files with read.csv. Set header = FALSE and sep = "" into the next variables:

```R
col_names <- read.csv(file_names, header = FALSE, sep = "")
train <- read.csv(file_train, header = FALSE, sep = "", col.names = col_names$V2)
test <- read.csv(file_test, header = FALSE, sep = "", col.names = col_names$V2)
act_names <- read.csv(file_act_names, header = FALSE, sep = "", col.names = c("N", "activity"))
act_train <- read.csv(file_act_train, header = FALSE, sep = "")
act_test <- read.csv(file_act_test, header = FALSE, sep = "")
```

For files "X_train.txt" and "X_test.txt" set column names from file "features.txt" with parameter "col.names = ".
For file activity set column names also.

## Prepare data
1. Merge activities names with activity numbers

```R
m_act_train <- merge(act_train, act_names, by.x = "V1", by.y = "N")
m_act_test <- merge(act_test, act_names, by.x = "V1", by.y = "N")
```
2. Merge data sets and activities

```R
train <- cbind(train, m_act_train)
test <- cbind(test, m_act_test)
```

3. Merge test and train measurements

```R
mset <- rbind(train, test)
```

## Make analysis
1. Take neccessary column labels. I use escape "\\." to avoid such columns 'fBodyBodyGyroMag-meanFreq()'

```R
coln <- grep("mean\\.|std\\.|activity", names(mset), value = TRUE)
```

2. Subset mset data test

```R
mset <- mset[, coln]
```

3. Split data set by activities

```R
s <- split(mset, mset$activity)
```

4. Calculate mean for each column except the last "activity".

```R
new_mset <- sapply(s, function(x){colMeans(x[, 1:ncol(mset)-1], na.rm = TRUE)})
```

