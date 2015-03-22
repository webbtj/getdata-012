# Getting and Cleaning Data
### Course Assignment

The software contained creates tidy data based on raw data provided by **UCI's Machine Leadning Repository** gathering various datapoints for thirty subjects performing six activities using Samsung smartphones. For more information on the project visit the [**Human Activity Recognition Using Smartphones Data Set**](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

### Requirements
This software requires the following R packges as dependencies:
* dplyr
* reshape2

### What the software does
This software provides two key functions for creating tidy data from the provided raw data.
* `tidy_data()` perfoms the following operations in order to take the provided raw data and return the same data in a tidy data set:
    * Reads all observations provided in `test/X_test.txt` and `train/X_train.txt` whose names contain `std()` or `mean()` into a single dataframe. Each row corresponds to one subject performing one activity
    * Reads all activity IDs from `test/y_test.txt` and `train/y_train.txt`. The human readable activity labels are read from `activity_lables.txt`. A vector of activity labels, based on the read activity IDs, is added to the main dataframe.
    * Reads all subject IDs from `test/subject_test.txt` and `train/subject_train.txt`. The vector of IDs is added to the main dataframe.
* `tidy_averages()` collects the tidy data set from `tidy_data()` and returns a new dataframe. The new dataframe offers a row for each activity/subject combination, and offers columns for `activity`, `subject` and each of the observations columns read into the main dataframe in `tidy_data()`

### How to use this software
1. Download and extract the [dataset zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
2. In the R console, be sure to set the working directory to the directory of the extracted zip file, example: `setwd("~/Downloads/UCI\ HAR\ Dataset")`
3. Source the run_analysis.R file, example: `source("~/R/getdata-012/run_analysis.R")`
4. To return a tidy data set of the raw data collected, run `tidy_data()`. This returns a standard dataframe which can be used as such.
5. To return a tidy data set of averages for each captured measurement based on every observed activity/subject combination, run `tidy_averages()`. This returns a standard dataframe which can be used as such.

### Other Notes
* The code is heavily commented to both explain the operations and to identify which requirements are met by each piece of code.
* For readability, several of the operations have been broken out to separate functions. This was not a course requirement but should make reading and evaluation easier.

### Other Files
* `codebook.md` - details on the variables included in the dataframe, including name, type, precision (where applicable), expected range/values, and description
* `output/tidy_averages.txt` - example output of `tidy_averages()` function, written using R's `write.table()` function with `row.names` set to `FALSE`