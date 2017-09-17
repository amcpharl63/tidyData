require(dplyr)

## First download the zip file and unpack it
getHAR <- function() {
  dataset = "UCI HAR Dataset"
  zipFile = "HAR.zip"
  if (!file.exists(dataset)) {
    paste("Downloading ", dataset)
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  destfile = zipFile)
    ## Unpack the zip file
    unzip(zipFile)
    ## NOw remove the original ZIP file
    file.remove(zipFile)
  } else {
    paste(dataset, "already exists")
  }
}

## Combine all data files
## Builds a sigle data set from both the test and train directories
## Cleans the data by naming the observations as per the function list
## and combines the subject ID to the observations. Also adds a descriptive name 
## for each activity
combineTestTrain <- function() {
  ##
  ## The activity names are stored in the second column of the activity_label_text file
  ## So first we read the activity labels.
  rootDir = "UCI HAR Dataset"
  actLabels = read.table(paste(rootDir, "/activity_labels.txt", sep = ""))
  names(actLabels) <- c("activity", "activity_name")
  
  ##
  ## The feature names are stored in second column in the features.txt file
  ## Now we read the features
  
  ## Fixed width file of 561 fields of 16 characters long
  widths = rep(16, 561)
  features <- read.table(paste(rootDir, "/features.txt", sep=""))
  myFeatures = features$V2
  
  first = TRUE
  
  ## Build a list of columns that we want to keep
  ## which are columns that hold, mean or standard diviation data
  columns <- grep("mean|Mean|std|Std", myFeatures)
  
  for (dirName in c("test", "train")) {
    
    ## Read the x file and set the column names to the features in myFeatures
    XfileName = paste(rootDir,"/",dirName,"/","X_",dirName,".txt", sep = "")
    Xfile = read.table(XfileName)
    names(Xfile) <- myFeatures
    
    ## Read the Y file and name the column then replace the activity ID with the 
    ## activity name
    
    Yfilename = paste(rootDir,"/",dirName,"/","y_",dirName,".txt", sep = "")
    Yfile = read.table(Yfilename)
    names(Yfile) <- "activity"
    
    ## Now read the subject data
    Sfilename = paste(rootDir,"/",dirName,"/","subject_",dirName,".txt", sep = "")
    subjects = read.table(Sfilename)
    
    names(subjects) <- "subject"
    
    ## Remove the unwanted columns from Xfile
    Xfile <- Xfile[,columns]
    
    data <- cbind(subjects, Xfile, Yfile)
    
    if (first) {
      paste("Read first file ", dim(data))
      total <- data
      first = FALSE
    } else {
      paste("Reading second file ", dim(data))
      total <- rbind(total, data)
    }
    
  }
  
  total <- merge(total, actLabels, by = "activity")
  ## Just one last cleansing, remove the activity column since we have
  ## the activity name
  total <- total[, 2:ncol(total)]
  return(total)
  
}

## Main - this is the starting function.
## Simply call main and it will download the data file, unzip and then
## combine the test and train data together and produce a tidy dataset
## The data is then written to a tidy.txt file and then compressed into tidy.zip
main <- function() {
  ## First get the data
  getHAR()
  dat <- combineTestTrain()
  
  ## Now save the data into a file and zip it up
  write.table(dat, "tidy_file.txt")
  
  ## find the average of each variable for each activity and each subject
  tidy_dat <- aggregate(dat[,2:ncol(dat)-1], list(dat$activity_name, dat$subject), mean)
  
  ## Now write the results
  write.table(tidy_dat, "tidy_file2.txt")
  
  
}