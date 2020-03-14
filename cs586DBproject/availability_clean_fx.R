
AvailabilityClean <- function(scheduling_raw)
{
# Renaming columns to make more intuitive sense for the onlooker

names(scheduling_raw) <- c("time", "name", "email", "mon_half1",
                           "tue_half1", "wed_half1", "thu_half1",
                           "fri_half1", "sat_half1", "sun_half1",
                           "mon_half1p", "tue_half1p", "wed_half1p",
                           "thu_half1p", "fri_half1p", "sat_half1p", 
                           "sun_half1p", "mon_half2", "tue_half2", 
                           "wed_half2", "thu_half2", "fri_half2", 
                           "sat_half2", "sun_half2", "mon_half2p",
                           "tue_half2p", "wed_half2p", "thu_half2p",
                           "fri_half2p", "sat_half2p", "sun_half2p",
                           "comments", "unavail_dates", "understandings1",
                           "understandings2", "other")

# Creating a stand-in column for student id's

scheduling_raw$student_id <- 1:37
scheduling_raw <- scheduling_raw[, c("time", "student_id", "name", "email", "mon_half1",
                                     "tue_half1", "wed_half1", "thu_half1",
                                     "fri_half1", "sat_half1", "sun_half1",
                                     "mon_half1p", "tue_half1p", "wed_half1p",
                                     "thu_half1p", "fri_half1p", "sat_half1p", 
                                     "sun_half1p", "mon_half2", "tue_half2", 
                                     "wed_half2", "thu_half2", "fri_half2", 
                                     "sat_half2", "sun_half2", "mon_half2p",
                                     "tue_half2p", "wed_half2p", "thu_half2p",
                                     "fri_half2p", "sat_half2p", "sun_half2p",
                                     "comments", "unavail_dates", "understandings1",
                                     "understandings2", "other")]

# 0: Monday
# 1: Tuesday
# 2: Wednesday
# 3: Thursday
# 4: Friday
# 5: Saturday
# 6: Sunday

days <- c(0, 1, 2, 3, 4, 5, 6)

# 0: First half of the day (6:00 am - 2:00 pm)
# 1: Second half of the day (3:00 pm - 11:00 pm)

halves <- c(0, 1)

# 0: Available
# 1: Preferred

descriptions <- c(0, 1)

# 0: 6:00 am
# 1: 7:00 am
# 2: 8:00 am
# 3: 9:00 am
# 4: 10:00 am
# 5: 11:00 am
# 6: 12:00 am
# 7: 1:00 pm
# 8: 2:00 pm
# 9: 3:00 pm
# 10: 4:00 pm
# 11: 5:00 pm
# 12: 6:00 pm
# 13: 7:00 pm
# 14: 8:00 pm
# 15: 9:00 pm
# 16: 10:00 pm
# 17: 11:00 pm

half1 <- c(0, 1, 2, 3, 4, 5, 6, 7, 8)
half2 <- c(9, 10, 11, 12, 13, 14, 15, 16, 17)

# Essentially, a lookup table for possible availabilities

availability <- data.frame(day = vector("numeric"),
                half = vector("numeric"),
                description = vector("numeric"),
                mtg_time = vector("numeric"))

# Populating the lookup table

for(j in days){
    for(k in halves){
      for(l in descriptions){
        if(k == 0){
          for(m in half1){
            availability <- rbind(availability, c(j, k, l, m))
          }
          
        }else if(k == 1){
          for(m in half2){
            availability <- rbind(availability, c(j, k, l, m))
          }
        }
      }
    }
}

# Creating an availability primary key

availability <- cbind(1:252, availability)

names(availability) <- c("availability_id", "day_of_week",
                         "half", "description", "mtg_time")

availability <- availability[order(availability$day_of_week,
                                   availability$description,
                                   availability$half),]

availability[, "availability_id"] <- 1:252

availability[, "mtg_time"] <- factor(availability[, "mtg_time"],
       labels = c("6:00 am",
                  "7:00 am",
                  "8:00 am",
                  "9:00 am",
                  "10:00 am",
                  "11:00 am",
                  "12:00 pm",
                  "1:00 pm",
                  "2:00 pm",
                  "3:00 pm",
                  "4:00 pm",
                  "5:00 pm",
                  "6:00 pm",
                  "7:00 pm",
                  "8:00 pm",
                  "9:00 pm",
                  "10:00 pm",
                  "11:00 pm"))

# Creating comparable characters to match the times produced 
# by the google form

availability$time_string <- vector("character", 252)
for(i in 1:nrow(availability)){
  availability[i, "time_string"] <- paste0(str_extract(as.character(availability[i, "mtg_time"]),
                                                "[^:]+"),
                                           str_sub(as.character(availability[i, "mtg_time"]),
                                                   -2))
  
}

# Creating the rel table for the many-to-many relationship

availability_rel <- as.tbl(data.frame(student_id = vector("numeric"),
                                      availability_id = vector("numeric")))
# Populating the rel table

for(i in 1:nrow(scheduling_raw)){
  monday_a <- paste(scheduling_raw[i, "mon_half1"],
                    scheduling_raw[i, "mon_half2"],
                    sep = ",")
  tuesday_a <- paste(scheduling_raw[i, "tue_half1"],
                     scheduling_raw[i, "tue_half2"],
                     sep = ",")
  wednesday_a <- paste(scheduling_raw[i, "wed_half1"],
                       scheduling_raw[i, "wed_half2"],
                       sep = ",")
  thursday_a <- paste(scheduling_raw[i, "thu_half1"],
                      scheduling_raw[i, "thu_half2"],
                      sep = ",")
  friday_a <- paste(scheduling_raw[i, "fri_half1"],
                    scheduling_raw[i, "fri_half2"],
                    sep = ",")
  saturday_a <- paste(scheduling_raw[i, "sat_half1"],
                      scheduling_raw[i, "sat_half2"],
                      sep = ",")
  sunday_a <- paste(scheduling_raw[i, "sun_half1"],
                    scheduling_raw[i, "sun_half2"],
                    sep = ",")
  monday_p <- paste(scheduling_raw[i, "mon_half1p"],
                    scheduling_raw[i, "mon_half2p"],
                    sep = ",")
  tuesday_p <- paste(scheduling_raw[i, "tue_half1p"],
                     scheduling_raw[i, "tue_half2p"],
                     sep = ",")
  wednesday_p <- paste(scheduling_raw[i, "wed_half1p"],
                       scheduling_raw[i, "wed_half2p"],
                       sep = ",")
  thursday_p <- paste(scheduling_raw[i, "thu_half1p"],
                      scheduling_raw[i, "thu_half2p"],
                      sep = ",")
  friday_p <- paste(scheduling_raw[i, "fri_half1p"],
                    scheduling_raw[i, "fri_half2p"],
                    sep = ",")
  saturday_p <- paste(scheduling_raw[i, "sat_half1p"],
                      scheduling_raw[i, "sat_half2p"],
                      sep = ",")
  sunday_p <- paste(scheduling_raw[i, "sun_half1p"],
                    scheduling_raw[i, "sun_half2p"],
                    sep = ",")
  
  day_times <- list(monday_a, tuesday_a, wednesday_a, thursday_a,
                    friday_a, saturday_a, sunday_a, monday_p,
                    tuesday_p, wednesday_p, thursday_p, friday_p,
                    saturday_p, sunday_p)
  
  for(j in 1:length(day_times)){
    day_times[[j]] <- unlist(strsplit(day_times[[j]], split = ",", fixed = T))
    for(k in 1:length(day_times[[j]])){
      day_times[[j]][k] <- trimws(day_times[[j]][k])
    }
  }
  
  for(l in 1:length(day_times)){
    for(m in 1:length(day_times[[l]])){
      if(day_times[[l]][m] != "NA"){
        index <- which(day_times[[l]][m] == availability$time_string)
        sub_avail <- availability[index, ]
        if(l == 1){
          sub_avail <- sub_avail[sub_avail$day_of_week == 0 & 
                                   sub_avail$description == 0,
                                 "availability_id"]
        }else if(l == 2){
          sub_avail <- sub_avail[sub_avail$day_of_week == 1 & 
                                   sub_avail$description == 0,
                                 "availability_id"]
        }else if(l == 3){
          sub_avail <- sub_avail[sub_avail$day_of_week == 2 & 
                                   sub_avail$description == 0,
                                 "availability_id"]
        }else if(l == 4){
          sub_avail <- sub_avail[sub_avail$day_of_week == 3 & 
                                   sub_avail$description == 0,
                                 "availability_id"]
        }else if(l == 5){
          sub_avail <- sub_avail[sub_avail$day_of_week == 4 & 
                                   sub_avail$description == 0,
                                 "availability_id"]
        }else if(l == 6){
          sub_avail <- sub_avail[sub_avail$day_of_week == 5 & 
                                   sub_avail$description == 0,
                                 "availability_id"]
        }else if(l == 7){
          sub_avail <- sub_avail[sub_avail$day_of_week == 6 & 
                                   sub_avail$description == 0,
                                 "availability_id"]
        }else if(l == 8){
          sub_avail <- sub_avail[sub_avail$day_of_week == 0 & 
                                   sub_avail$description == 1,
                                 "availability_id"]
        }else if(l == 9){
          sub_avail <- sub_avail[sub_avail$day_of_week == 1 & 
                                   sub_avail$description == 1,
                                 "availability_id"]
        }else if(l == 10){
          sub_avail <- sub_avail[sub_avail$day_of_week == 2 & 
                                   sub_avail$description == 1,
                                 "availability_id"]
        }else if(l == 11){
          sub_avail <- sub_avail[sub_avail$day_of_week == 3 & 
                                   sub_avail$description == 1,
                                 "availability_id"]
        }else if(l == 12){
          sub_avail <- sub_avail[sub_avail$day_of_week == 4 & 
                                   sub_avail$description == 1,
                                 "availability_id"]
        }else if(l == 13){
          sub_avail <- sub_avail[sub_avail$day_of_week == 5 & 
                                   sub_avail$description == 1,
                                 "availability_id"]
        }else if(l == 14){
          sub_avail <- sub_avail[sub_avail$day_of_week == 6 & 
                                   sub_avail$description == 1,
                                 "availability_id"]
        }
        availability_rel <- add_case(availability_rel, 
                                     student_id = unlist(scheduling_raw[i, "student_id"]),
                                     availability_id = unlist(sub_avail))
      }
    }
  }
}
  
availability[, "day_of_week"] <- factor(availability[, "day_of_week"],
                                          labels = c("Monday",
                                                     "Tuesday",
                                                     "Wednesday",
                                                     "Thursday",
                                                     "Friday",
                                                     "Saturday",
                                                     "Sunday"))
  
availability[, "description"] <- factor(availability[, "description"],
                                          labels = c("Available",
                                                     "Preferred"))
  
availability[, "mtg_time"] <- factor(availability[, "mtg_time"],
                                       labels = c("6:00 am",
                                                  "7:00 am",
                                                  "8:00 am",
                                                  "9:00 am",
                                                  "10:00 am",
                                                  "11:00 am",
                                                  "12:00 pm",
                                                  "1:00 pm",
                                                  "2:00 pm",
                                                  "3:00 pm",
                                                  "4:00 pm",
                                                  "5:00 pm",
                                                  "6:00 pm",
                                                  "7:00 pm",
                                                  "8:00 pm",
                                                  "9:00 pm",
                                                  "10:00 pm",
                                                  "11:00 pm"))

# No need to keep the abbreviated version of time or the 
# half of the day around

availability <- availability[, !names(availability) %in% c("half", "time_string")]

student <- data.frame(student_id = scheduling_raw$student_id,
                      email = scheduling_raw$email,
                      name = scheduling_raw$name)

availability_comments <- data.frame(student_id = vector("numeric"),
                                    comment = vector("character"),
                                    unavailability = vector("character"),
                                    other = vector("character"),
                                    stringsAsFactors = F)

for(i in 1:nrow(scheduling_raw)){
  if(!is.na(unlist(scheduling_raw[i, "comments"])) |
     !is.na(unlist(scheduling_raw[i, "unavail_dates"])) |
     !is.na(unlist(scheduling_raw[i, "other"]))){
    availability_comments <- add_case(availability_comments,
                                      student_id = unlist(scheduling_raw[i, "student_id"]),
                                      comment = unlist(scheduling_raw[i, "comments"]),
                                      unavailability = unlist(scheduling_raw[i, "unavail_dates"]),
                                      other = unlist(scheduling_raw[i, "other"]))
  }
}
return(student, availability, availability_rel, availability_comments)
}