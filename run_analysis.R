library(dplyr)
# setwd to test folder and read in the data
if(getwd() != "/Users/C/Desktop/Coursera-R/RPro/GetCleanData/CourseProject/UCI HAR Dataset/test"){
        setwd("/Users/C/Desktop/Coursera-R/RPro/GetCleanData/CourseProject/UCI HAR Dataset/test")
}
# read in and combine subject, activity, and measure
test_subject <- read.table("subject_test.txt")
test_measure <- read.table("X_test.txt")
test_activity <- read.table("y_test.txt")
test_data<- cbind(test_subject, test_activity, test_measure)
# reapeat above for train data
setwd("/Users/C/Desktop/Coursera-R/RPro/GetCleanData/CourseProject/UCI HAR Dataset/train")
train_subject <- read.table("subject_train.txt")
train_measure <- read.table("X_train.txt")
train_activity <- read.table("y_train.txt")
train_data<- cbind(train_subject, train_activity, train_measure)
# merge train data and test data
total_data_raw <- as.data.frame(rbind(test_data,train_data))
# read feature names and set column names for merged data
setwd("/Users/C/Desktop/Coursera-R/RPro/GetCleanData/CourseProject/UCI HAR Dataset")
feature_names <- read.table("features.txt")
column_names <- append(c("subject","activity"),as.character(feature_names[,2]))
total_data_raw <- `colnames<-`(total_data_raw,column_names)
# subset only means and standard deviation values
total_data_processed <- 
        subset(total_data_raw, 
               select = grep("^subject$|^activity$|.*mean\\(\\).*|.*std\\(\\).*",colnames(total_data_raw)))

# update activity names to be descriptive
activity_names <- read.table("activity_labels.txt", col.names = c("activity","activity_name"))
total_act_labeled <- merge(total_data_processed,activity_names,by = "activity")
total_act_labeled$activity <- total_act_labeled$activity_name
total_act_labeled <- select(total_act_labeled, -activity_name)

# label the columns to be descriptive
total_act_labeled <- `colnames<-`(total_act_labeled, gsub("\\(\\)","",colnames(total_act_labeled))) 
write.table(total_act_labeled,file = "cleaned_data_step4.txt")

# create the new data set
tidy_data <- aggregate(total_act_labeled[,3:ncol(total_act_labeled)],
                       by = list(subject = total_act_labeled$subject,
                                 activity = total_act_labeled$activity),mean)
write.table(tidy_data, file = "new_data_step5.txt")















