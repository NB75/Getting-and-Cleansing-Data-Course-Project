run_analysis <- function() {
  
  library(dplyr)
  
  # Script does the following:
  #01 Merges the training and the test sets to create one data set.
  
  ##01.01 Data Extraction
  
  ###01.01.01 Assignment of the filenames
  
  ####01.01.01.01 identification of the working directory
  wd <- getwd()
  
  ####01.01.01.02 vector of values to be merged
  val_types <- c("test","train")
  len_vt <- length(val_types)
  
  ###01.01.02 initialization of data frames to be merged
  df <- data.frame()
  test_df <- data.frame()
  train_df <- data.frame()
  
  ###01.01.03 data extraction
  for (i in 1:len_vt) {
    
    ####01.01.03.01 definition of directory where the data is stored
    ####directories are reconstructed based on the assumption that directory structure has not been modified after file unzip
    fold <- val_types[i]
    dir <- paste(wd,fold,sep="/")
    
    ####01.01.03.02 definition of the filenames
    fn_X <- paste("X_",val_types[i],".txt",sep="")
    fn_y <- paste("y_",val_types[i],".txt",sep="")
    fn_subject <- paste("subject_",val_types[i],".txt",sep="")
    
    ####01.01.03.03 definition of file path
    path_X <- paste(dir,"/",fn_X,sep="")
    path_y <- paste(dir,"/",fn_y,sep="")
    path_subject <- paste(dir,"/",fn_subject,sep="")
    
    ####01.01.03.04 read data
    df_X <- read.table(path_X,header=FALSE)
    
    ####01.01.03.05 creation of a column to differentiate test and training data
    if (i == 1) {
      rownum_test <- nrow(df_X)
      data_type <- rep("test",times=rownum_test)
      df <- data.frame(data_type,df_X)
    } else if (i == 2) {
      train_df <- df
      rownum_train <- nrow(df_X)
      data_type <- rep("train",times=rownum_train)
      df <- data.frame(data_type,df_X)
    }
    
    ####01.01.03.06 addition of columns for activity and subject, derived from "y" and "subject" files
    activity <- read.table(path_y,header=FALSE,colClasses="character")
    subject <- read.table(path_subject,header=FALSE,colClasses="character")
    
    df <- data.frame(subject,activity,df)
    
    ####01.01.03.07 copy of temporary data frame (df) to data frames to be merged
    if (i == 1) {
      test_df <- df
    } else if (i == 2) {
      train_df <- df
    }
  }
  
  ###01.01.04 merge of the two data frames
  merged_df <- rbind(test_df,train_df)
  
  #02 Extracts only the measurements on the mean and standard deviation for each measurement
  
  ##02.01 identification of all the variable names
  var_names <- names(merged_df)
  
  ##02.02 extraction of "mean" and "std" variable names
  mean_var <- var_names[grepl(".[M,m]ean.",var_names)]
  std_var <- var_names[grepl(".[S,s]td.",var_names)]
  
  #03 Uses descriptive activity names to name the activities in the data set
  
  ##03.01 identification of the activity labels filename
  act_fn <- "activity_labels.txt"
  
  ##03.02 activity labels path definition
  act_path <- paste(wd,act_fn,sep="/")
  
  ##03.03 activity labels extraction and rename of the V2 field (self-explaining name)
  act_lab <- read.table(act_path,sep=" ")
  act_lab <- rename(act_lab,activity_label=V2)
  
  ##03.04 assignment of activity labels to merged data frame (merge with V1 as key column)
  merged_df <- merge(merged_df,act_lab,by="V1")
  
  #04 Appropriately labels the data set with descriptive variable names. 
  
  ##04.01 identification of the features filename
  feat_fn <- "features.txt"
  
  ##04.02 features path definition
  feat_path <- paste(wd,feat_fn,sep="/")
  
  ##04.03 features extraction
  feat <- read.table(feat_path,sep=" ")
  
  ##04.04 features transpose
  nfeat <- nrow(feat)
  string <- as.character()
  
  for (i in 1:nfeat) {
    cfeat <- feat[i,2]
    if (i==1){
      string <- paste(cfeat)
    } else {
      string <- paste(string,cfeat,sep=";")
    }
  }
  
  header <- unlist(strsplit(string,";"))
  
  ##04.05 addition of "subject" and "activity" as first columns in header
  header <- c("subject","activity","data_type",header,"activity_label")
  
  ##04.06 assignment of variable names to merged data frame
  merged_df <- setNames(merged_df,header)
  
  ###04.07 reordering of columns in data set (activity labels close to activity codes)
  first_3 <- merged_df[,1:2]
  activity_label <- merged_df[,565]
  var_col <- merged_df[,3:564]
  
  tidy_df <- data.frame(first_3,activity_label,var_col)
  
  #05 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
  ##05.01 aggregation of data by subject, activity and act. label (calculation of mean data)
  mean_df <- data.frame(aggregate(tidy_df[,-c(1:3)],by=list(tidy_df$subject,tidy_df$activity,tidy_df$activity_label),FUN=mean,na.rm=TRUE))
  
  ##05.02 removal of data type column, previously added to differentiate test and train data
  mean_df <- mean_df[,-4]
  
  ##05.03 rename of columns in order to obtain the final data set
  key_col <- c("subject","activity","activity_label")
  num_col <- unlist(names(mean_df[,4:564]))
  new_header <- c(key_col,num_col)
  
  mean_df <- setNames(mean_df,new_header)
  
  ##05.04 creation of final file
  write.table(mean_df,"tidy_dataset.txt")
  
}
