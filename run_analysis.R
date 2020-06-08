library(tidyverse)
library(reshape2)

setwd("//chws3092/PPM Admin File/Pricing Product General/Users/Carey C/Coursera/Getting and cleaning data")

# find out which activities we want to keep
activityLabels <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR dataset/activity_labels.txt")
labels <- as.character(activityLabels$V2)
feats <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
features <- as.character(feats$V2)
which_features <- grep(".*mean|.*std.*", features)
# apply filter to get their names
features <- features[which_features]
feature_names <- feats$V2 %>% as.character()

# load in datasets
# train

train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")[which_features]
train_activities <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

# test

test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")[which_features]
test_activities <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

# combine

train <- cbind(train, train_activities, train_subjects)
test <- cbind(test, test_activities, test_subjects)
all_data <- rbind(train, test)
colnames(all_data) <- c(feature_names[which_features], "Activity", "Subject")
all_data$Activity <- factor(all_data$Activity, levels = activityLabels[, 1], labels = labels)
all_data$Subject <- as.factor(all_data$Subject)

# tidy up data

all_data_tidy <- all_data %>% melt(id = c("Subject", "Activity"))
all_data_mean <- all_data_tidy %>%
  group_by(Subject, Activity, variable) %>% 
  summarise(Mean = mean(value))

# write the data

write.table(all_data_mean, "tidy_data_mean.txt", row.names = FALSE)
