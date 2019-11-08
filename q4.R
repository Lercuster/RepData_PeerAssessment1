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
weekday = c("Ïí", "Âò", "Ñð", "×ò", "Ïò")
active_data$weekday = factor((weekdays(active_data$date, T) %in% weekday), 
                             levels = c(F, T), 
                             labels = c("weekday", "weekend"))
