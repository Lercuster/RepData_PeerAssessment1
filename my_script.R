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

### here 61 days with 288 observations each day (with NA)

### question 1

steps_per_day = active_data[, list(steps = sum(steps, na.rm = F)), by = date]


plot = ggplot(data = steps_per_day, aes(x=steps))+
       geom_histogram(na.rm = F, 
                      breaks=seq(0, 22000, by = 1000), 
                      color="Black", fill="darkgrey") + 
       labs(title="Steps histogram plot",
           x="Amount of steps per day", y="Days") +
       theme_minimal()

print(plot)

steps_mean = mean(steps_per_day$steps, na.rm = T)
steps_median = median(steps_per_day$steps, na.rm = T)

print(paste0("mean == ", round(steps_mean, 2))) 
print(paste0("median == ", round(steps_median, 2))) 

### question 2




print("DONE")