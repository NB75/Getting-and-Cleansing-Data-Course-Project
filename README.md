# Getting-and-Cleansing-Data-Course-Project
Repository to collect submission material for Course Assignment of Getting and Cleansing Data, module 3 of Data Science Specialization

# Script ‘run_analysis’, available in this folder, does the following:
#01 Merges the training and the test sets to create one data set.

 ##01.01 Data Extraction

 ###01.01.01 Assignment of the filenames

  ####01.01.01.01 identification of the working directory

  ####01.01.01.02 vector of values to be merged

  ###01.01.02 initialization of data frames to be merged

  ###01.01.03 data extraction
   
  ####01.01.03.01 definition of directory where the data is stored
  ####directories are reconstructed based on the assumption that directory structure has not been modified after file unzip

  ####01.01.03.02 definition of the filenames
  
  ####01.01.03.03 definition of file path
  
  ####01.01.03.04 read data

  ####01.01.03.05 creation of a column to differentiate test and training data

  ####01.01.03.06 addition of columns for activity and subject, derived from “y” and “subject” files

  ####01.01.03.07 copy of temporary data frame (df) to data frames to be merged
  
  ###01.01.04 merge of the two data frames

#02 Extracts only the measurements on the mean and standard deviation for each measurement

  ##02.01 identification of all the variable names

  ##02.02 extraction of "mean" and "std" variable names

#03 Uses descriptive activity names to name the activities in the data set

  ##03.01 identification of the activity labels filename

  ##03.02 activity labels path definition

  ##03.03 activity labels extraction and rename of the V2 field (self-explaining name)
  
  ##03.04 assignment of activity labels to the merged data frame (merge with V1 as key column)
        
#04 Appropriately labels the data set with descriptive variable names. 

  ##04.01 identification of the features filename

  ##04.02 features path definition

  ##04.03 features extraction

  ##04.04 features transpose

  ##04.05 addition of "subject" and "activity" as first columns in header

  ##04.06 assignment of variable names to merged data frame

  ###04.07 reordering of columns in data set (activity labels close to activity codes)

#05 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 
  ##05.01 aggregation of data by subject, activity and act. label (calculation of mean data)

  ##05.02 removal of data type column, previously added to differentiate test and train data

  ##05.03 rename of columns in order to obtain the final data set

  ##05.04 creation of final file

