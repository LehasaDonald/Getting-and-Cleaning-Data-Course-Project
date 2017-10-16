## Download and unzip the dataset

if (!file.exists("Create_dataset.zip")) {
    dir.create("Create_dataset.zip"))
    fileURL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, destfile = "Create_dataset.zip", method="curl")
}

if (!file.exists("UCI HAR Dataset")) { 
   dir.create("UCI HAIR Dataset")
   unzip("Create_dataset.zip",) 
}

# Load activity labels + features
dataActivityLab = read.table("UCI HAR Dataset/activity_labels.txt")
dataActivityLab[,2] = as.character(dataActivityLab[,2])
dataFeat = read.table("UCI HAR Dataset/features.txt")
dataFeat[,2] = as.character(dataFeat[,2])

# Extract only the data on mean and standard deviation
features = grep(".*mean.*|.*std.*", dataFeat[,2])
features.names = dataFeat[features,2]
features.names = gsub('-mean', 'Mean', features.names)
features.names = gsub('-std', 'Std', features.names)
features.names = gsub('[-()]', '', features.names)


# Load the datasets
train = read.table("UCI HAR Dataset/train/X_train.txt")[features]
trainAct = read.table("UCI HAR Dataset/train/Y_train.txt")
trainSub = read.table("UCI HAR Dataset/train/subject_train.txt")
train = cbind(trainSub, trainAct, train)

test = read.table("UCI HAR Dataset/test/X_test.txt")[features]
testAct = read.table("UCI HAR Dataset/test/Y_test.txt")
testSub = read.table("UCI HAR Dataset/test/subject_test.txt")
test = cbind(testSub, testAct, test)

# merge datasets and add labels
Merged = rbind(train, test)
colnames(Merged) = c("subject", "activity", features.names)

# turn activities & subjects into factors
Merged$activity = factor(Merged$activity, levels = dataActivityLab[,1], labels = dataActivityLab[,2])
Merged$subject = as.factor(Merged$subject)

Merged.melted = melt(Merged, id = c("subject", "activity"))
Merged.mean = dcast(Merged.melted, subject + activity ~ variable, mean)

write.table(Merged.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
