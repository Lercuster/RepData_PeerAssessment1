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
    ff_data$steps = as.numeric(ff_data$steps)
    for(i in 1:dim(ff_data)[1]){
        if(is.na(ff_data[i, 1])){
            int = as.numeric(ff_data[i, 3])
            step = num_steps_int[interval == int, 2]
            ff_data[i, 1] = step
            }
    }
    ff_data
}

