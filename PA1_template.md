---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
header-includes:
   - \usepackage[russian]{babel}
---
## Loading libraries

We will need ggplot2 and data.table libraries, let's go load them:


```r
library(data.table)
library(ggplot2)
```


## Loading and preprocessing the data


```r
if (!file.exists("./data/activity.csv")){
      unzip("activity.zip", exdir = "./data")
} else {
      print("There's no need to unzip!")
}
```

```
## [1] "There's no need to unzip!"
```

```r
active_data <- as.data.table(read.csv("./data/activity.csv", header = T))
active_data$date <- as.Date(as.character(active_data$date))
```


## What is mean total number of steps taken per day?

Now i'm going to calculate the total amount of steps taken per day.  
I will notice that activity data set contains some missing values, so i prefer not to remove them
because i think it's more accurate instead of counting them as zeros.
Here i create new dataset based on active_data where i will have 2 columns, for total amount of steps taken per day and corresponding date. 



```r
steps_per_day = active_data[, list(steps = sum(steps, na.rm = F)), by = date]
```

Now let's check out the histogram of total number of steps...


```r
plot = ggplot(data = steps_per_day, aes(x=steps))+
       geom_histogram(breaks=seq(0, 22000, by = 1000), 
                      color="Black", fill="darkgrey") + 
       labs(title="Steps histogram plot",
           x="Amount of steps per day", y="Days") +
       theme_minimal()

print(plot)
```

```
## Warning: Removed 8 rows containing non-finite values (stat_bin).
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

... and calculate mean and median number of steps for this dataset.


```r
steps_mean = round(mean(steps_per_day$steps, na.rm = T), 2)
steps_median = median(steps_per_day$steps, na.rm = T)
```

As wee can see, the mean value is 1.076619\times 10^{4} and the median is 10765.

## What is the average daily activity pattern?

Now let's inspect daily activity. To do that, at firts, i'm going to calculate new data set with 2 columns, first one - average number of steps taken during 5-minute interval and the second column - corresonding interval.


```r
num_steps_int <- active_data[, list(steps = mean(steps, na.rm=T)), 
                                                by=interval]
```

Now let's visualize this data by creating time-series plot of 5-minute interval (x-axis) and number of steps (y-axis).


```r
plot = ggplot(data = num_steps_int, 
              aes(x = interval, y = steps)) + 
       geom_line() + 
       labs(title="The average  number of steps taken 
                   in certain 5-minute interval", x = "5-minute unterval", 
                   y = "Number of steps taken") + 
       theme_light()
print(plot)
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

And let's find out certain interval in which wee have maximum of steps:


```r
pair = num_steps_int[steps == max(steps), ]
pair$steps = round(pair$steps, 2)
```

It turns out that data have maximum of 206.17 steps in 835 interval.

## Imputing missing values

As it was mentioned above we have some missing values in our dataset, so it may be useful to fill it with some data.  
To start with let's calculate the exact amount of missing values (NA) in dataset.


```r
num_of_na = as.numeric(summary(active_data$steps)[7])
```

Tt turns out that we have 2304 missing values. I want to replace them with mean values for appropriate interval withal we've already calculate that. This way of fullfilling NA's may be not very accurate but it seems at least logical and we dont need more right now.

To replace NA's i will use following function:


```r
insert_na = function(active_data, num_steps_int){
    ff_data = active_data
    ff_data$steps = as.numeric(ff_data$steps)
    ff_data$int = as.numeric(ff_data$interval)
    for(i in 1:dim(ff_data)[1]){
        if(is.na(ff_data[i, 1])){
            int = as.numeric(ff_data[i, 3])
            ff_data[i, 1] = num_steps_int[interval == int, 2]
            }
    }
    ff_data
}
```

And now let's use it to create new filled dataset:


```r
filled_dt = insert_na(active_data = active_data, num_steps_int = num_steps_int)
```

So, now we have to datasets to compare. Let's look to the mean and median of steps column in each data to see if there is any differencies and how big they are:


```r
steps_per_day_filled = filled_dt[, list(steps = sum(steps)), by = date]
steps_mean_filled = round(mean(steps_per_day_filled$steps), 2)
steps_median_filled = round(median(steps_per_day_filled$steps), 2)
```

I remind that in raw dataset wee had 1.076619\times 10^{4} as a mean value and 10765 as a median. In filled dataset mean of steps is 1.076619\times 10^{4} and median is 1.076619\times 10^{4}.  
(i actually don't now how to fix that type of representation of these values, so if you do, *pleease!!* let me now in the comments below)

## Are there differences in activity patterns between weekdays and weekends?

And as a last thing to exanine in this data set let's take a look at differencies of nember of steps taken in week or in weekend days. To do so i will add new factor varible in the (filled) dataset, which will indicate is current day weekday or not. 
(sorry, i'm a russian speaker, so i will name day in russian, just believe it's correct)


```r
weekday = c('Пн', 'Вт', 'Ср', 'Чт', 'Пт')
filled_dt$weekday = factor((weekdays(filled_dt$date, T) %in% weekday), 
                             levels = c(F, T), 
                             labels = c("weekday", "weekend"))
```

Now when factor is added in dataset, let's plot this. It will time-series plot, where wee have 5-minute interval on x-axis and number of steps in that interval on y-axis.


```r
table(filled_dt$weekday)
```

```
## 
## weekday weekend 
##    4608   12960
```


```r
plot = ggplot(data = filled_dt, 
              aes(x = interval, y = steps)) + 
    geom_line() + 
    labs(title="The average  number of steps taken 
                   in certain 5-minute interval", x = "5-minute unterval", 
         y = "Number of steps taken") + 
    theme_light() + 
    facet_grid(facets = weekday~.)

print(plot)
```

![](PA1_template_files/figure-html/unnamed-chunk-15-1.png)<!-- -->

Well, that's all folks. Thanks, i'd love to see your comments in the comments section below!
