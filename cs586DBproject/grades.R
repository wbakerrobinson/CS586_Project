# Reading in the .csv file

library(tidyr)

grades_raw <- read_excel(
  ".\\Example Data\\Example Capstone Prerequisite Data.xlsx")

grades_long <- gather(grades_raw, class, grade, c("CS161",
                                                  "CS162",
                                                  "CS163",
                                                  "CS201",
                                                  "CS202",
                                                  "CS250",
                                                  "CS251",
                                                  "CS300",
                                                  "CS320",
                                                  "CS333",
                                                  "CS350",
                                                  "PPP"))

names(grades_long) <- c("name", "student_id", "CS469",
                        "xfer1", "xfer2", "class", "grade")

# Don't need CS469, since they're all IP, student name, or Xfer

grades_long <- grades_long[, names(grades_long) %in% c("student_id",
                                                       "class",
                                                       "grade")]

# 0: CS161
# 1: CS162
# 2: CS163
# 3: CS201
# 4: CS202
# 5: CS250
# 6: CS251
# 7: CS300
# 8: CS320
# 9: CS333
# 10: CS350
# 11: PPP

course <- 0:11

# 0: A
# 1: A-
# 2: B+
# 3: B
# 4: B-
# 5: C+
# 6: C
# 7: C-
# 8: D+
# 9: D
# 10: D-
# 11: F
# 12: P
# 13: NP
# 14: I
# 15: IP
# 16: W
# 17: W*
# 18: AU
# 19: X
# 20: M
# 21: RF

grade <- 0:21

# Essentially, a lookup table for possible grades

grades <- data.frame(course = vector("numeric"),
                     grade = vector("numeric"))

# Populating the lookup table

for(k in course){
  for(l in grade){
    grades <- rbind(grades, c(k, l))
  }
}

# Creating a grades primary key

grades <- cbind(1:nrow(grades), grades)

names(grades) <- c("grade_id", "course",
                   "grade")

grades[, "course"] <- factor(grades[, "course"],
                             labels = c("CS161",
                                        "CS162",
                                        "CS163",
                                        "CS201",
                                        "CS202",
                                        "CS250",
                                        "CS251",
                                        "CS300",
                                        "CS320",
                                        "CS333",
                                        "CS350",
                                        "PPP"))

grades[, "grade"] <- factor(grades[, "grade"],
                            labels = c("A",
                                       "A-",
                                       "B+",
                                       "B",
                                       "B-",
                                       "C+",
                                       "C",
                                       "C-",
                                       "D+",
                                       "D",
                                       "D-",
                                       "F",
                                       "P",
                                       "NP",
                                       "I",
                                       "IP",
                                       "W",
                                       "W*",
                                       "AU",
                                       "X",
                                       "M",
                                       "RF"))

# Creating the rel table for the many-to-many relationship

grades_rel <- as.tbl(data.frame(student_id = vector("numeric"),
                                grades_id = vector("numeric")))
# Populating the rel table

for(i in 1:nrow(grades_long)){
  if(!is.na(str_detect(grades_long$grade[i], ",")) &
     str_detect(grades_long$grade[i], ",")){
    multiple <- unlist(strsplit(grades_long$grade[i], split = ",", fixed = T))
    multiple <- sapply(multiple, trimws)
    for(j in 1:length(multiple)){
      course_name <- unlist(grades_long[i, "class"])
      matches_c <- which(as.character(grades$course) == course_name)
      grade_name <- unlist(grades_long[i, "grade"])
      matches_g <- which(as.character(grades$grade) == multiple[j])
      grades_rel <- add_case(grades_rel, 
                             student_id = grades_long$student_id[i],
                             grades_id = unlist(grades[matches_g[matches_g %in% 
                                                                   matches_c], "grade_id"]))
    }
  }else if(!is.na(str_detect(grades_long$grade[i], ",")) &
           str_detect(grades_long$grade[i], ",") == F){
    course_name <- unlist(grades_long[i, "class"])
    matches_c <- which(as.character(grades$course) == course_name)
    grade_name <- unlist(grades_long[i, "grade"])
    matches_g <- which(as.character(grades$grade) == grade_name)
    grades_rel <- add_case(grades_rel, 
                           student_id = grades_long$student_id[i],
                           grades_id = unlist(grades[matches_g[matches_g %in% 
                                                                 matches_c], "grade_id"]))
  }
}

rm(list = setdiff(ls(), c("availability", "availability_comments", "availability_rel", "grades", "grades_rel", "project", "project_rel", "student")))
