if (!require("data.table") && !require("reshape2")) {
        install.packages("reshape2")
        install.packages("data.table")
}

require("data.table")
require("reshape2")

# 1. Merges the training and the test sets to create one data set.

# get labels
features <- read.table("UCI HAR Dataset/features.txt")[,2]
activityLabel <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]

# TEST DATA
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
names(X_test) = features

y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_test[,2] = activityLabel[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
names(subject_test) = "subject"

testData <- cbind(subject_test, y_test, X_test)


# TRAIN DATA
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
names(X_train) = features

y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
y_train[,2] = activityLabel[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
names(subject_train) = "subject"

trainData <- cbind(subject_train, y_train, X_train)

# Merge test and train data
data = rbind(testData, trainData)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

meanStdColumn = grepl("mean|std", colnames(data))
meanStdColumn[1:3] = TRUE
meanData = data[,meanStdColumn]

# 4. Appropriately labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


idLabel = c("subject", "Activity_ID", "Activity_Label")
labels = setdiff(colnames(meanData), idLabel)
meltData = melt(meanData, id = idLabel, measure.vars = labels)
secondSet = dcast(meltData, subject + Activity_Label ~ variable, mean)
file.create("secondSet.txt", showWarnings = TRUE)
write.table(secondSet, file = "secondSet.txt", row.name=FALSE )

