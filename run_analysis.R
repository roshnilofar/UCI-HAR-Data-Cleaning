#enter file name
  filename <- "UCI_HAR_Dataset.zip"

#check if zip file exits 
  if(!file.exists(filename))
    {
      #download and unzip zip file
      download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",filename,method="curl")
      unzip(filename)
    }
  if(!file.exists("./UCI HAR DATASET"))
  {
    unzip(filename)
  }

#load all individual files into variables
    features <- read.table("./UCI HAR DATASET/features.txt", col.names=c("no","functions"))
    activities <- read.table("./UCI HAR DATASET/activity_labels.txt", col.names=c("actv","label"))
    
#loading training variables
    subject_train <- read.table("./UCI HAR DATASET/train/subject_train.txt", col.names="subject")
    Xtrain <- read.table("./UCI HAR DATASET/train/X_train.txt", col.names=features$functions)
    Ytrain <- read.table("./UCI HAR DATASET/train/Y_train.txt", col.names="code")

#loading testing variables
    subject_test <- read.table("./UCI HAR DATASET/test/subject_test.txt", col.names="subject")
    Xtest <- read.table("./UCI HAR DATASET/test/X_test.txt", col.names=features$functions)
    Ytest <- read.table("./UCI HAR DATASET/test/Y_test.txt", col.names="code")

#row bind train value and test values
    X_data <-rbind(Xtrain,Xtest)
    Y_data <-rbind(Ytrain,Ytest)
    subject <-rbind(subject_train,subject_test)

#column bind the different attributes
    dataframe<-cbind(subject,X_data,Y_data)

#selecting only the mean and std devitaion variables
    library(dplyr)
    DF_subset <- select(dataframe,subject,code,contains("mean"),contains("std"))

#Uses descriptive activity names to name the activities in the data set.
    DF_subset$code <- activities[DF_subset$code,2]

#Appropriately labels the data set with descriptive variable names
    names(DF_subset)[2] = "activity"
    names(DF_subset)<-gsub("Acc", "Accelerometer", names(DF_subset))
    names(DF_subset)<-gsub("Gyro", "Gyroscope", names(DF_subset))
    names(DF_subset)<-gsub("BodyBody", "Body", names(DF_subset))
    names(DF_subset)<-gsub("Mag", "Magnitude", names(DF_subset))
    names(DF_subset)<-gsub("^t", "Time", names(DF_subset))
    names(DF_subset)<-gsub("^f", "Frequency", names(DF_subset))
    names(DF_subset)<-gsub("tBody", "TimeBody", names(DF_subset))
    names(DF_subset)<-gsub("-mean()", "Mean", names(DF_subset), ignore.case = TRUE)
    names(DF_subset)<-gsub("-std()", "STD", names(DF_subset), ignore.case = TRUE)
    names(DF_subset)<-gsub("-freq()", "Frequency", names(DF_subset), ignore.case = TRUE)
    names(DF_subset)<-gsub("angle", "Angle", names(DF_subset))
    names(DF_subset)<-gsub("gravity", "Gravity", names(DF_subset))

#Create a new dataset using average
    Data <- DF_subset %>%
      group_by(subject, activity) %>%
      summarise_all(funs(mean))
    write.table(Data, "Final_clean_data.txt", row.name=FALSE)
    print(Data)
