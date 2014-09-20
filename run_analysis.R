setwd("E:/Users/Paul/Desktop/Getting and Cleaning Data/Course project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/")

#these lines of code all read in the varios .txt files
features <- read.table("features.txt")
activity <- read.table("activity_labels.txt")

subject.test <- read.table("test/subject_test.txt")
subject.train <- read.table("train/subject_train.txt")

x.test <- read.table("test/X_test.txt")
x.train <- read.table("train/X_train.txt")
y.test <- read.table("test/y_test.txt")
y.train <- read.table("train/y_train.txt")

#the following three lines merge all of the test data into one data frame
fulldata.test <- x.test
fulldata.test <- cbind(fulldata.test, subject.test)
fulldata.test <- cbind(fulldata.test, y.test)

#the following three lines merge all of the training data into one data frame 
fulldata.train <- x.train
fulldata.train <- cbind(fulldata.train, subject.train)
fulldata.train <- cbind(fulldata.train, y.train)

#this merges the full test and full training dataframes. did it in this order because they would have the same # of columns
fulldata <- rbind(fulldata.test, fulldata.train)

#These 5 lines of code set up the vector used to pull out the mean and std columns from the full data set
extract <- as.character(features$V2) #makes sure the column values are characters
extract.mean <- grep("-mean", extract) #uses grep to search for any values features that has the -mean string
extract.std <- grep("-std", extract) #uses grep to search for any values features that has the -std string
col.extract <- c(extract.mean, extract.std) #combines mean and std extract into one vector
col.extract <- sort(col.extract) #sorts the vector so that the columns will be in the same order as the original data set 

#extracts the mean, std, subject, and activity columns from the full data set
fulldata.clean <- fulldata[,c(col.extract, 562,563)] 

#creates the column names
names <- features[c(col.extract),]
names <- names$V2
names <- gsub("BodyBody", "Body", names) #fixes the some of the names that were BodyBody instead of Body
names <- c(names,"Subject", "Activity") #adds subject and activity to the list

#changes column names
colnames(fulldata.clean) <- names

#give descriptive names to the activity column
fulldata.clean$Activity <- activity$V2[match(fulldata.clean$Activity, activity$V1)] 
#matches the value from colum 1 of activity (1-6) to the value in fulldata.clean$Activity and then replaces with the name of the activity


#Creating new data frame with averages of each variable for each subject and activity
library(plyr)
data.summary <- ddply(fulldata.clean, .(Subject, Activity), numcolwise(mean))

#data.summary is the file that I submitted.

write.table(data.summary, "data_averaged.txt", row.name =FALSE)

