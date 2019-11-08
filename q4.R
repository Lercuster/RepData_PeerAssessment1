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

#new_dt = insert_na(active_data = active_data, num_steps_int = num_steps_int)

weekday = c("Ïí", "Âò", "Ñð", "×ò", "Ïò")
active_data$weekday = factor((weekdays(active_data$date, T) %in% weekday), 
                             levels = c(F, T), 
                             labels = c("weekday", "weekend"))

plot = ggplot(data = active_data, 
              aes(x = interval, y = steps)) + 
    geom_line() + 
    labs(title="The average  number of steps taken 
                   in certain 5-minute interval", x = "5-minute unterval", 
         y = "Number of steps taken") + 
    theme_light() + 
    facet_grid(facets = weekday~.)

print(plot)

