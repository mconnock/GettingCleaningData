GettingCleaningData
===================

Coursera "Getting and Cleaning Data" study

The run_analysis.R script holds one function run_analysis().  This function looks in the data directory and reads the following files
+ X_test
+ X_train
+ Y_test
+ Y_train

It then reads in subject and activity data from the following files:
+ subject_test
+ subject_train

With the data read in, the function create one data set that combines each of the X test and X train files into one (binding by rows) and the Y test and Y train files by rows.  Then the subject test and and train files and combined.

Care is taken to ensure that test and train files are matched in the same order.

The resulting files and turned into one data set by binding the files by column into one file.  We then look for the mean and standard deviation features by searching the field names. Remembering to include activity and subject information this is turned into a smaller dataset.

Next we match the activity reference data (held in features.txt) to turn reference ids into meaningful activity labels.

Finally we rotate the dataset to group the measures by activity and subject and then calculate the mean across activity and subject to provide an output file which is written to data/out.txt



