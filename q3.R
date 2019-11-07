library(data.table)
library(ggplot2)

if (!file.exists("./data/activity.csv")){
    unzip("activity.zip", exdir = "./data")
} else {
    print("There's no need to unzip!")
}

active_data <- as.data.table(read.csv("./data/activity.csv", header = T))

### transorm date column into real dates
active_data$date <- as.Date(as.character(active_data$date))

num_of_na = as.numeric(summary(active_data$steps)[7])
print(paste("Nmumber of NA's in steps column:", num_of_na))

num_steps_int <- active_data[, list(steps = mean(steps, na.rm=T)), 
                             by=interval]

insert_na = function(active_data, num_steps_int){
    ff_data = active_data
    for(i in 1:dim(ff_data)[1]){
        if(is.na(ff_data[i, 1])){
            int = as.numeric(ff_data[i, 3])
            ff_data[i, 1] = num_steps_int[interval == int, 2]
            }
    }
    ff_data
}

new_dt = insert_na(active_data = active_data, num_steps_int = num_steps_int)
steps_per_day_raw = active_data[, list(steps = sum(steps, na.rm = F)), by = date]
steps_mean_raw = mean(steps_per_day_raw$steps, na.rm = T)
steps_median_raw = median(steps_per_day_raw$steps, na.rm = T)
print(paste0("mean == ", round(steps_mean_raw, 2))) 
print(paste0("median == ", round(steps_median_raw, 2))) 

steps_per_day = new_dt[, list(steps = sum(steps)), by = date]
steps_mean = mean(steps_per_day$steps)
steps_median = median(steps_per_day$steps)
print(paste0("mean == ", round(steps_mean, 2))) 
print(paste0("median == ", round(steps_median, 2)))
