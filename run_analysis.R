if(!file.exists("./data")) dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "./data/projectData_getCleanData.zip")

listzip <- unzip("./data/projectData_getCleanData.zip")

train.x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
test.x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

traindata <- cbind(train.subject,train.y,train.x)
testdata <- cbind(test.subject,test.y,test.x)
fulldata <- rbind(traindata,testdata)

featurename <- read.table("./data/UCI HAR Dataset/features.txt")[,2]

featureIndex <- grep(("mean\\(\\)|std\\(\\)"),featurename)
finalData <- fulldata[,c(1,2,featureIndex+2)]
colnames(finalData) <- c("subject","activity", featurename[featureIndex])

activityname <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

finalData$activity <- factor(finalData$activity,levels = activityname[,1],labels = activityname[,2])

names(finalData) <- gsub("\\()","",names(finalData))
names(finalData) <- gsub("^t","time",names(finalData))
names(finalData) <- gsub("^t","Time",names(finalData))
names(finalData) <- gsub("^f","Frequency",names(finalData))
names(finalData) <- gsub("-mean","Mean",names(finalData))
names(finalData) <- gsub("-std","Std",names(finalData))

groupData<-aggregate(. ~subject + activity, finalData, mean)

write.table(groupData,"./data/Project.txt",row.names = FALSE)
