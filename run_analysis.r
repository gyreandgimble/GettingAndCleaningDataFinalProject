## Getting and Cleaning Data course project
## file name: run_analysis.r 


setwd("C:/Users/karensanmillan/Documents/Coursera Data Science/CleaningDataFinalProj")


## Create destination folder (if doesn't already exist)
## Method from week 1, Reading Local Files lecture, slide 3  
if (!file.exists("CleaningDataFinalProj")) {
  print ("Creating destination folder")
  dir.create("CleaningDataFinalProj")
}

## Obtain data set from source site (if not already found in download location)
## Method from week 1, Reading Local Files lecture, slide 3 

## Check if data file already exists in destination location - if not, 
## Download data file from URL and Unzip file

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfilename <- "getdata_projectfiles_UCI HAR Dataset.zip"

# Download and unzip file, if not already done  
if (!file.exists(zipfilename)){
  download.file(fileUrl, destfile=zipfilename, mode="wb")
  dateDownloaded <- date()
  unzip(zipfilename, exdir="./CleaningDataFinalProj/UCI HAR Dataset")
} else {
  print ("File already downloaded and unzipped")
}

## change directory into folder "UCI HAR Dataset" 
setwd("C:/Users/karensanmillan/Documents/Coursera Data Science/CleaningDataFinalProj/UCI HAR Dataset")

print ("Working")

## Step 1. Merge the training and the test sets to create one data set.

## SUBJECT IDs  
## Read in Subject files from train and test subfolders, and add column header of 'Subject' to each
SubjectTest <- read.table("test/subject_test.txt", col.names=c("Subject"))
SubjectTrain <- read.table("train/subject_train.txt", col.names=c("Subject"))
## Use rbind to merge the Subject training and test sets to create one data set 
SubjectCombined <- rbind(SubjectTrain, SubjectTest)
## Confirmed count in merged set is correct:  2947 + 7352 = 10299
## which is a rough match to the README - The obtained dataset has been randomly partitioned into two sets, 
## where 70% [7352] of the volunteers was selected for generating the training data and 30% [2947] the test data. 

## FEATURES (X files) 
## Read in Feature data files from train and test subfolders 
FeaturesTest <- read.table("test/X_test.txt")
FeaturesTrain <- read.table("train/X_train.txt")
## Use rbind to merge the Features training and test sets to create one data set 
FeaturesCombined <- rbind(FeaturesTest, FeaturesTrain)

## FEATURE headers  
## Read in Features file from UCI HAR Dataset folder 
Features <- read.table("features.txt", col.names=c("Index", "FeatureLabel"))
## Convert list of Feature headers (as read from file) into a single row for use as column header names 
FeatureHeaders <- Features$FeatureLabel

## Add Feature column headers to combined FEATURES data set 
colnames(FeaturesCombined) <- FeatureHeaders

## ACTIVITIES (Y files) 
## Read in Activity data files from train and test subfolders, and add column header of 'Activity' to each 
ActivitiesTest <- read.table("test/Y_test.txt", col.names=c("Activity"))
ActivitiesTrain <- read.table("train/Y_train.txt", col.names=c("Activity"))
## Use rbind to merge the Activities training and test sets to create one data set 
ActivitiesCombined <- rbind(ActivitiesTest, ActivitiesTrain)

## ACTIVITY value labels  
## Read in Activity labels file from UCI HAR Dataset folder (tags for activity values 1-6)
## Will need these for Step 3
ActivityLabels <- read.table("activity_labels.txt", col.names=c("Index", "ActivityLabel"))

## FINAL MERGE 
## Combine the Subject, Feature, and Activity data into a single set by using column merge 
FinalDataSet <- cbind(SubjectCombined, ActivitiesCombined, FeaturesCombined)


## Step 2. Extract only the measurements on the mean and standard deviation for each measurement.
## which are identified by having "mean" or "std" in the column labels 

## Fetch the column names from the FinalDataSet, so that you can select from this the "mean" and "std" columns 
FinalDataSetColNames <- colnames(FinalDataSet)

## Use grep (grepl logical vector) to find the columns that are mean() and std(), but *NOT meanFreq() 
## as MeanFreq has a different meaning: Weighted average of the frequency components to obtain a mean frequency
## and also retain the Activity and Subject columns 
FindMeanAndStdColumns <- (grepl("Activity" , FinalDataSetColNames) | 
                            grepl("Subject" , FinalDataSetColNames) | 
                            grepl("mean\\(\\).." , FinalDataSetColNames) | 
                            grepl("std\\(\\).." , FinalDataSetColNames) 
)

## Apply this logical vector to the Final data set, to get just the mean and std columns 
MeanAndStdDataSet <- FinalDataSet[ , FindMeanAndStdColumns == TRUE]


## Step 3. Use descriptive activity names to name the activities in the data set
## Use the Activity Labels values to replace the (1-6) numerical activity values in the MeanAndStdDataSet data set 
## From README: Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, 
## SITTING, STANDING, LAYING)

## Activity labels file was already read during Stepp 1 above while we were reading from text files - ActivityLabels 

## Merge (lookup and add to data set) the Activity Label value 
MeanStdDataSetWithActivityLabels <- merge(x=MeanAndStdDataSet, y=ActivityLabels,
                                          by.x='Activity', by.y='Index')

## Checked and confirmed all records are still there - 10299 rows - so join was OK 


## Step 4. Appropriately label the data set with descriptive variable names.
## From README: A 561-feature vector with time and frequency domain variables; 
## so prefix (1st component) f=Frequency, prefix t=Time 
names(MeanStdDataSetWithActivityLabels)<-gsub("^t", "Time", names(MeanStdDataSetWithActivityLabels))
names(MeanStdDataSetWithActivityLabels)<-gsub("^f", "Frequency", names(MeanStdDataSetWithActivityLabels))

## Text file "features_info.txt" has explanation of the variable name meanings 
## 2nd component - Body or Gravity - this is already a clear description, but sometimes BodyBody is repeated - change to Body
names(MeanStdDataSetWithActivityLabels)<-gsub("BodyBody", "Body", names(MeanStdDataSetWithActivityLabels))

## 3rd component - Acc [Accelerometer], Jerk [Jerk - no change needed], Gyro [Gyroscope], Mag [Magnitude]
names(MeanStdDataSetWithActivityLabels)<-gsub("Acc", "Accelerometer", names(MeanStdDataSetWithActivityLabels))
names(MeanStdDataSetWithActivityLabels)<-gsub("Gyro", "Gyroscope", names(MeanStdDataSetWithActivityLabels))
names(MeanStdDataSetWithActivityLabels)<-gsub("Mag", "Magnitude", names(MeanStdDataSetWithActivityLabels))

## 4th component - std [StdDev], mean [Mean]
names(MeanStdDataSetWithActivityLabels)<-gsub("std", "StdDev", names(MeanStdDataSetWithActivityLabels))
names(MeanStdDataSetWithActivityLabels)<-gsub("mean", "Mean", names(MeanStdDataSetWithActivityLabels))

## and get rid of double parentheses - needs escape chars in front of parens 
names(MeanStdDataSetWithActivityLabels)<-gsub("\\()", "", names(MeanStdDataSetWithActivityLabels))


## Step 5. From the data set in step 4, create a second, independent tidy data set with the average 
## of each variable for each activity and each subject. (Matrix of all permutations of activity + subject, 
## with mean for each)

## Get rid of ActivityLabel column from dataset - averaging it is meaningless 
MeanDataNoActivityLabel = MeanStdDataSetWithActivityLabels[,names(MeanStdDataSetWithActivityLabels) != 'ActivityLabel'];

## Use aggregate function to get mean by Activity, Subject 
SecondTidyDataSet <-aggregate(. ~Subject + Activity, MeanDataNoActivityLabel, mean)

## Order the records 
SecondTidyDataSet<-SecondTidyDataSet[order(SecondTidyDataSet$Subject,SecondTidyDataSet$Activity),]

## Write to a text file, TidyDataSet.txt  
write.table(SecondTidyDataSet, file = "TidyDataSet.txt", row.names = FALSE)

print ("Done")
