# program: run_analysis
# author: matt connock
# 
# purpose of program is to merge a set of test and training data with the relevent subjects and activities.
# activities should be referenced by name rather than id to provide a descriptive data set.
# one the data sets are merged the mean should be calculated for all measures relating to mean and std deviation.
#

# read files into data structures
library("reshape2")
run_analysis  <- function() {
 
    #Read in the 'X' files with the right column names defined
    dfXCols  <- read.csv("data/features.txt", sep="", header=FALSE)
    dfXTest  <- read.csv("data/test/X_test.txt", col.names=dfXCols[,2], sep="", na.string=TRUE)
    dfXTrain  <- read.csv("data/train/X_train.txt", sep="", col.names=dfXCols[,2], na.string=TRUE)
    
    #Read in the Subject information and assign a column name
    dfTestSubject  <- read.csv("data/test/subject_test.txt", col.names="subject")
    dfTrainSubject  <- read.csv("data/train/subject_train.txt", col.names="subject")
    
    #Read in the 'Y' files (activity) and assign a column names
    dfYTest  <<- read.csv("data/test/Y_test.txt", col.names="activity")
    dfYTrain  <<- read.csv("data/train/Y_train.txt", col.names="activity")
    
    #Bind the rows together for subjects, activities and measures and then put them into one dataset
    dfTmpSubject  <- rbind(dfTestSubject, dfTrainSubject)
    dfTmpX  <- rbind(dfXTest, dfXTrain)
    dfTmpY  <- rbind(dfYTest, dfYTrain)    
    dfXAndY  <- cbind(dfTmpSubject, dfTmpY, dfTmpX)
    
    # Use regex to extract all mean and std features (but get rid of meanFreq and any values for Z as we are only looking at X and Y values)
    # Then extract the features found by the grep function into a 'filtered' dataset
    dfTidyCols  <- grep("subject|activity|(.*)mean[^F](.*)[^Z]$|(.*)std(.*)[^Z]$", names(dfXAndY))
    dfTmpSet  <<- dfXAndY[,dfTidyCols]
    
    # Label the actitivites with descriptive names by loading in the reference data
    # and merging the reference data with the dataset
    activityNames  <- read.csv("data/activity_labels.txt", sep="", header=FALSE, col.names=c("activity", "ActivityName"))
    m1 <<- merge(activityNames, dfTmpSet, by.x = "activity", by.y = "activity")
    
    # Create second dataset with average of each variable for each activity and subject
    # The melt function collapses the structure into 1 row per activity, subject and measure
    # dcast provides the aggregate function for the output and then we write it out to an output file.
    m2  <<- melt(m1, id.vars=(1:3), na.rm=TRUE)
    dfOut  <<- dcast(m2, ActivityName + subject ~ variable, mean)
    write.csv(dfOut, "data/out.txt")

}