library(data.table)
library(reshape)
library(reshape2)


# Variables 
data<-"data.zip"
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir<-"./UCI HAR Dataset"
dataSet1<-"data1.txt"
dataSet2<-"data2.txt"


# Download the file if doesn´t exists
if(!file.exists(data)
   {
  
  download.file(fileUrl,data, mode = "wb")
  
  ## UnZip the files
  
  unzip(data)
}

#Read features
features <- read.table(paste(dir, 'features.txt', sep = '/'),header = FALSE)
names(features) <- c('id', 'name')
#Read activity
activity <- read.table(paste(dir, 'activity_labels.txt', sep = '/'),header = FALSE)
names(activity) <- c('id', 'name')

####################Read Train

#TrainX
trainX <- read.table(paste(dir, 'train', 'X_train.txt', sep = '/'),header = FALSE)
names(trainX) <- features$name
#TrainY
trainY <- read.table(paste(dir, 'train', 'Y_train.txt', sep = '/'),header = FALSE)
names(trainY)<-"activity"
#SubTrain
subtrain <- read.table(paste(dir, 'train', 'subject_train.txt', sep = '/'),header = FALSE)
names(subtrain)<-"subject"

###################Read Test

#TestX
testX <- read.table(paste(dir, 'test', 'X_test.txt', sep = '/'),header = FALSE)
names(testX) <- features$name
# TestY 
testY <- read.table(paste(dir, 'test', 'Y_test.txt', sep = '/'),header = FALSE)
names(testY)<-"activity"
# Subtest
subtest <- read.table(paste(dir, 'test', 'subject_test.txt', sep = '/'),header = FALSE)
names(subtest)<-"subject"


################ 1. Merges the training and the test sets to create one data set.
dataX  <-rbind(trainX,testX)
dataY  <-rbind(trainY, testY)
dataSub<-rbind(subtrain,subtest)
total<-cbind(dataX,dataSub,dataY)
write.table(total, dataSet1,sep="|")

################ 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
totalMS<- total[, c(grep('mean|std', features$name),562,563)]


#######################################################################
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive activity names.
#######################################################################

totalMS["desActivity"]<-activity[totalMS$activity,]$name

#Modify the names of columns appropriately
colnames(totalMS) <- gsub('\\(|\\)',"",names(totalMS))
colnames(totalMS) <- gsub('\\-',"",names(totalMS))


#5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject 

# Transpose the mtotalMS data  set

mtotalMS <- melt(totalMS, id=c('subject', 'desActivity'), measured = c("subject","desActivity"))
#Calculate the the average of each variable for each activity and each subject
dtotalMS<-dcast(mtotalMS, desActivity + subject ~ variable, mean)    

# Write the second data set
write.table(dtotalMS, "dataSet2.txt",sep = "|")







