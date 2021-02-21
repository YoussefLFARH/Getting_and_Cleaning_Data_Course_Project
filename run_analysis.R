library(dplyr)

#Part 1: Downloding and unzipping the data:

if(!file.exists("./data")){dir.create("./data")}
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Part 2: Reading the data:

##2.1 Training datasets:

      x_train = read.table("./data/UCI HAR Dataset/train/X_train.txt")
      y_train = read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train = read.table("./data/UCI HAR Dataset/train/subject_train.txt")

##2.2 Testing datasets:
      x_test = read.table("./data/UCI HAR Dataset/test/X_test.txt")
      y_test = read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test = read.table("./data/UCI HAR Dataset/test/subject_test.txt")


##2.3 Features data:
features = read.table('./data/UCI HAR Dataset/features.txt')

##2.4 Activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

##############################################################

                  #### QUESTION 4 #####
#Part 3: Creating the One data:

##3.1 Labeling the columns:
### X columns:
colnames(x_train) = features[,2]
colnames(x_test) = features[,2]

### y columns:
colnames(y_train) = "ActivityId"
colnames(y_test) = "ActivityId"

### Subject set:
colnames(subject_train) = "SubjectId"
colnames(subject_test) = "SubjectId"

### Activity labels:
colnames(activityLabels) = c("ActivityId","ActivityLabel")


                 #### QUESTION 1 #####
##3.2 Merging all in one:

TRAIN = cbind(y_train,subject_train,x_train)
TEST = cbind(y_test,subject_test,x_test)
#### The whole data:
DATA = rbind(TRAIN,TEST)



##############################################################
#Part 4: Extracting the wanted data (Mean & std data):

                 #### QUESTION 2 #####

colNames = colnames(DATA)
#### We are searching for mean and std columns 
Criterion = (grepl("ActivityId",colNames)| 
             grepl("SubjectId",colNames)|
             grepl("mean..",colNames)|
             grepl("std..",colNames)
              )
#### Appliying the criterion on our DATA:
Data_mean_std = DATA[, Criterion == TRUE]

                #### QUESTION 3 #####
#### Lets add Activity labels to our data:

DATA_labled = merge(Data_mean_std, activityLabels,by='ActivityId',all.x=TRUE)

  
                #### QUESTION 5 #####
##############################################################
#Part 5: Creating the seconde tidy data:

##5.1 Grouping and avereging:
TIDY_DATA = aggregate(. ~SubjectId + ActivityId, DATA_labled,mean) 
TIDY_DATA = TIDY_DATA[order(TIDY_DATA$SubjectId,TIDY_DATA$ActivityId),]

##5.2 Exporting the Final TidySet:
write.table(TIDY_DATA, "TIDY_DATA.txt", row.name=FALSE)




