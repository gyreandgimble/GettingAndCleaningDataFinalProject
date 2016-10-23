#README.md, for Coursera Getting and Cleaning Data, final assignment  

This project analyzes a set of wearable computing data collected from the accelerometers from the Samsung Galaxy S smartphone.  
The original project is described at the following URL: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

There is a single R script called "run_analysis.r" which downloads, unzips, and processes the data files.  

**Steps performed in processing the data: **

##Step 1: Obtain data files, create a single data set 
The data files for the project are obtained in a single zipped file, from the URL: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The script checks to see if the file has already been downloaded (since it is large, it avoids downloading the file if it already exists in the specified path); if not already present, it downloads the file and unzips it.  
There are three categories of data: Subjects, Features, and Activities, each contained in separate files.  
There are also separate files for test data and training data (same measurements, but for a different population of volunteers).
These multiple data files, along with labels for the data, are merged to create a single data set with descriptive labels.  
Note: The original zip file also contains Intertial Signal data; this was not used for this project.   

##Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
The script identifies the measurements for mean and standard deviation in the data set by looking for the text "mean" and "std" in the measurement headers.  
The "meanFreq()" measurements were explicitly excluded, as being different than the straight "mean" (meanFreq is defined as the "Weighted average of the frequency components to obtain a mean frequency").  

##Step 3: Use descriptive activity names to name the activities in the data set
The activities are originally identified by (1-6) numerical activity values in the merged data set.  Each numerical value corresponds to a text activity description from the "activity_labels.txt" file:  WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).  The script adds the corresponding activity  label to the data set for each record, to name the activity in a descriptive way.  

##Step 4: Appropriately labels the data set with descriptive variable names.
Descriptive variable names were assigned to each activity in the remaining (mean and frequency) data set, by replacing shortened text in the original data set with longer, more descriptive text.  The original text file "features_info.txt" contained explanations of the variable name meanings. 
For the first component of the naming, f=Frequency, t=Time 
2nd component - Body or Gravity - this is already a clear description, but sometimes BodyBody is repeated - changed to Body
3rd component - Acc [Accelerometer], Jerk [Jerk - no change needed], Gyro [Gyroscope], Mag [Magnitude]
4th component - std [StdDev], mean [Mean]
Double parentheses were also removed for clarity in the activity names.  

##Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
The script creates a new, summarized data set, with the average (mean) for each variable, for each combination of subject and activity identifier. 
The descriptive activity names column is excluded from this data set (as its values cannot be averaged).  
The data set is ordered, by subject and activity identifier.  
This resulting tidy data set is output as a text file named "TidyDataSet.txt".  









