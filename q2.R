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

num_steps_int <- active_data[, list(steps = mean(steps, na.rm=T)), 
                                                by=interval]

plot = ggplot(data = num_steps_int, 
              aes(x = interval, y = steps)) + 
       geom_line() + 
       labs(title="The average  number of steps taken 
                   in certain 5-minute interval", x = "5-minute unterval", 
                   y = "Number of steps taken") + 
       theme_light()
print(plot)

pair = num_steps_int[steps == max(steps), ]
print(paste("The interval contains max of taken steps is", pair[, 1], 
                "and the value is:", round(pair[, 2], 2)))