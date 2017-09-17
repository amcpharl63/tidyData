# tidyData
Tidy Data Week 4 Assignment

The run_analysis.R script has a main() function that is the starting point.
To run the script simply type main()

The main function calls getHAR which downloads the UCI HAR Dataset ZIP file, unpacks the ZIP file and then removes the original ZIP file. To avoid constantly downloading the data, getHAR checks if the data has been previously downloaded before downloading.
The main function then calls combineTestTrain() which reads in the test data from X_test.txt, sets the variable names to the fields in the function.txt file. The the activity data is read from the y_test.txt and the subject data from the subject_test.txt file. Unwanted columns are stripped out of the X_file data and then the X_file, y_file and subject files are combined. The same is down for the train data and then the data rows are combined. The activity IDs are replaced with the activity name and the activity ID is removed for better readability.
Tha main function then takes the combined data and writes the table to tidy_data.txt
Lastly the main function groups the data in tidy_data by activity_name and subject and calculates the average of the observations. This data is then written to tidy_data2.txt


