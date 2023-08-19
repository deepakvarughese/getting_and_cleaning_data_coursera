## Loading Libraries
library(tidyverse)
library(here)
library(rio)


## All Imports =================================================
## Importing All files from Training Data Folder
x_train <- import(here("getcleandata","UCI HAR Dataset", "train", "X_train.txt"))
y_train <- import(here("getcleandata","UCI HAR Dataset", "train", "Y_train.txt"))
subject_train <- import(here("getcleandata","UCI HAR Dataset", "train", "subject_train.txt"))

## Importing All files from Test Data Folder
x_test <- import(here("getcleandata","UCI HAR Dataset", "test", "X_test.txt"))
y_test <- import(here("getcleandata","UCI HAR Dataset", "test", "Y_test.txt"))
subject_test <- import(here("getcleandata","UCI HAR Dataset", "test", "subject_test.txt"))

## Importing all files from features file
col_names <-  import(here("getcleandata","UCI HAR Dataset","features.txt"))

## Importing Activity Labels
activity_labels <- import(here("getcleandata","UCI HAR Dataset","activity_labels.txt"))



## Assigning Label Names
colnames(x_train) <- col_names[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- col_names[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activity_labels) <- c("activityID", "activityType")

## Merging all datasets into one set

alltrain <- cbind(y_train, subject_train, x_train)
alltest <- cbind(y_test, subject_test, x_test)
finaldataset <- rbind(alltrain, alltest)


## Extracting only the mean and sd

filtered_df <- finaldataset %>%
  select(
    contains("activityID") |
      contains("subjectID") |
      contains("mean") |
      contains("std")
  )


## Adding the Activity Names from the activity labels dataset
dataset_with_activity_names <- filtered_df %>%
  left_join(activity_labels, by = "activityID") %>% 
  select(activityType, everything())

summary_table <-  dataset_with_activity_names %>% 
  select(-activityID) %>% 
  group_by(subjectID, activityType) %>%
  summarise_all(mean, na.rm = TRUE) %>%
  arrange(subjectID, activityType)

## exporting summarydataset

export(summary_table, "summary_dataset.txt")
