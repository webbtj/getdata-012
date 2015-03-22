#requires dplyr for mutations and reshape2 to melting and dcasting
library(dplyr)
library(reshape2)

#tidy the raw data
tidy_data <- function(){
	
	#gather the combined observations for train and test, see get_observations for more details
	observations <- get_observations()
	
	#add the activity and subjects to the dataframe, see respective functions for more details
	observations <- mutate(observations, activity=get_activities(), subject=get_subjects())
	
	#clean up the column names, see clean_observation_names for more details
	clean_observation_names(observations)
}

#gets the raw observations, only called from tidy_data()
get_observations <- function(){
	
	#read the features from the external file, clean the names to remove the prefix numbers and spaces
	features <- scan(file="features.txt", what=character(), sep="\n")
	features <- gsub("^.*?\\s", "", features)
	
	#read the test data into a dataframe, use the previously fetches "features" as column names
	obs_test <- read.table(file="test/X_test.txt", col.names=features)
	#read the train data into a dataframe, use the previously fetches "features" as column names
	obs_train <- read.table(file="train/X_train.txt", col.names=features)
	
	#as per requirement #2 - extract only the mean and standard deviation measurements
	#for this we are using any measurement that contains "std()" or "mean()" (note: we are not including "meanFreq()" measurements)
	#strip out those columns that do not contain "std.." or "mean.." in the column name
	obs_test <- obs_test[,grepl("(std|mean)\\.\\.", names(obs_test))]
	obs_train <- obs_train[,grepl("(std|mean)\\.\\.", names(obs_train))]
	
	#as per requirement #1 - combine test and train
	#combine the two and return the resulting dataframe
	rbind(obs_test, obs_train)
}

#gets all of the activities for each observation by label, used by tidy_data to mutate activities into observations
get_activities <- function(){
	
	#read the activities from test and train into integer vectors
	act_test  <- scan(file="test/y_test.txt",   what=integer(), sep="\n")
	act_train <- scan(file="train/y_train.txt", what=integer(), sep="\n")
	
	#as per requirement #3 - use descriptive names for the activities - we'll use the names provided with the raw data
	#read the activity names into a data frame
	labels <- read.table(file="activity_labels.txt")
	
	#as per requirement #1 - combine test and train
	#return a character vector of label names a label for each observation (by combining the test and train vectors)
	labels[c(act_test, act_train),]$V2
}

#gets all of the subjects for each observation, used by tidy_data to mutate subjects into observations
get_subjects <- function(){
	
	#read the subjects from test and train into integer vectors
	sub_test  <- scan(file="test/subject_test.txt",   what=integer(), sep="\n")
	sub_train <- scan(file="train/subject_train.txt", what=integer(), sep="\n")
	
	#as per requirement #1 - combine test and train
	#return a vector combining the test and train subjects
	c(sub_test, sub_train)
}

#cleans up the column names in the observations, used by tidy_data to make column names more readable
clean_observation_names <- function(observations){
	
	#as per requirement #4 - use descriptive variable names in the dataframe
	#the names that came with the raw data a descriptive, we'll just clean up some of the punctuation
	#remove duplicate "."s, special characters such as "(", ")", and "-" are replaced with "."s when first reading into R
	names(observations) <- gsub("\\.+", ".", names(observations))
	#remove any trailing "." from column names
	names(observations) <- gsub("\\.$", "", names(observations))
	
	#return the observations with renamed columns
	observations	
}

#as per requirement #5 - a separate function for creating a separate tiny data set with averages of each variable for eaach
#	subject/activity combination
#averages each measurement based on the combination of activity and subject
tidy_averages <- function(){
	
	#collects the tidy_data version of the raw data provided
	tidy_data <- tidy_data()
	
	#melt the data, keeping only "activity" and "subject" as the ids and all other columns as the measured.vars
	#as a short cut, instead of listing all 66 measured.vars, pass the dataframe to names() and return all columns that
	#	are not "activity" or "subject"
	melted <- melt(tidy_data, id=c("activity", "subject"), measure.vars=names(tidy_data)[!names(tidy_data) %in% c("activity", "subject")])
	
	#dcast the melted dataframe into the desired output, that is a dataframe with a row for each activity/subject combination,
	#	and columns for each measurement, as well as columns for activity and subject
	dcast(melted, activity + subject ~ variable,mean)
}