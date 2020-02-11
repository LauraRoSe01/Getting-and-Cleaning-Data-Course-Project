#download data sets
library(data.table)
library(dplyr)
urlfile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destination <- "C:/Users/waws0/Documents/R/GalaxyDataset.zip"
download.file(urlfile, destination)

#download train data sets
setwd("~/R/GalaxyDataset/UCI HAR Dataset/train")
list.files()
subject_train <- read.table("~/R/GalaxyDataset/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("~/R/GalaxyDataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("~/R/GalaxyDataset/UCI HAR Dataset/train/y_train.txt")

#change variable nanmes in x_train & y_train df
xtrain_names <- read.table("~/R/GalaxyDataset/UCI HAR Dataset/features.txt")
list_names <- xtrain_names$V2
colnames(x_train) <- list_names
colnames(y_train) <- "traininglabels"

#consolidate train sets
train <- cbind(subject_train, y_train, x_train)
colnames(train)[1] <- "volunteer" 

#download test data sets and change variable´s names 
setwd("~/R/GalaxyDataset/UCI HAR Dataset/test")
subject_test <- read.table("~/R/GalaxyDataset/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("~/R/GalaxyDataset/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("~/R/GalaxyDataset/UCI HAR Dataset/test/y_test.txt")
colnames(x_test) <- list_names
colnames(y_test) <- "traininglabels"

#consolidate test sets
test <- cbind(subject_test, y_test, x_test)
colnames(test)[1] <- "volunteer" 

#combine test & train df
final_table <- rbind(train, test)

#Extracts only the measurements on the mean and standard deviation for each measurement.

  #findout which columns contain mean and std 
  #add volunteer and trainingactivity columns
column_names_mean_sd <- names(test)
select_columns <- c(1, 2, which(grepl("std\\(\\)", column_names_mean_sd)), 
                          which(grepl("mean\\(\\)", column_names_mean_sd)))
select_columns <- sort(select_columns)

#table with only needed variables

final_table_mean_std <- final_table[,select_columns]

#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
   
  #training levels: 
      #1 walking
      #2 walking_upstairs
      #3 walking_downstairs
      #4 sitting
      #5 standing
      #6 laying

colnames(final_table_mean_std)[1] <- "subjectID"
colnames(final_table_mean_std)[2] <- "activity"
final_table_mean_std$activity[which(final_table_mean_std$activity==1)] <- "walking"
final_table_mean_std$activity[which(final_table_mean_std$activity==2)] <- "walking_upstairs"
final_table_mean_std$activity[which(final_table_mean_std$activity==3)] <- "walking_downstairs"
final_table_mean_std$activity[which(final_table_mean_std$activity==4)] <- "sitting"
final_table_mean_std$activity[which(final_table_mean_std$activity==5)] <- "standing"
final_table_mean_std$activity[which(final_table_mean_std$activity==6)] <- "laying"


#creates a second,independent tidy data set
#with the average of each variable for each activity and each subject

new_df <- reshape2::melt(final_table_mean_std, id.vars = c("subjectID", "activity"))
tidy_df <- reshape2::dcast(new_df, subjectID+activity ~ variable, mean)

#save tidy_df
  
write.csv(tidy_df, "C:/Users/waws0/Documents/R/GalaxyDataset/tidydf.csv", row.names = FALSE)



