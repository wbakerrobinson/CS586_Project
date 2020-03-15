library(tidyr)

# Let prerequisites be the .csv file for the grades

# This function outputs a grade and grade_rel table

grading <- function(prerequisites){

  suppressWarnings(grades_raw <- prerequisites)
  
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
  
  grade_value <- 0:21
  
  # Essentially, a lookup table for possible grades
  
  grade <- data.frame(course = vector("numeric"),
                       grade_value = vector("numeric"))
  
  # Populating the lookup table
  
  for(k in course){
    for(l in grade_value){
      grade <- rbind(grade, c(k, l))
    }
  }
  
  # Creating a grade primary key
  
  grade <- cbind(1:nrow(grade), grade)
  
  names(grade) <- c("grade_id", "course",
                     "grade_value")
  
  grade[, "course"] <- factor(grade[, "course"],
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
  
  grade[, "grade_value"] <- factor(grade[, "grade_value"],
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
  
  grade_rel <- as.tbl(data.frame(student_id = vector("numeric"),
                                  grade_id = vector("numeric")))
  # Populating the rel table
  
  for(i in 1:nrow(grades_long)){
    if(!is.na(str_detect(grades_long$grade[i], ",")) &
       str_detect(grades_long$grade[i], ",")){
      multiple <- unlist(strsplit(grades_long$grade[i], split = ",", fixed = T))
      multiple <- sapply(multiple, trimws)
      for(j in 1:length(multiple)){
        course_name <- unlist(grades_long[i, "class"])
        matches_c <- which(as.character(grade$course) == course_name)
        grade_name <- unlist(grades_long[i, "grade"])
        matches_g <- which(as.character(grade$grade_value) == multiple[j])
        grade_rel <- add_case(grade_rel, 
                               student_id = grades_long$student_id[i],
                               grade_id = unlist(grade[matches_g[matches_g %in% 
                                                                     matches_c], "grade_id"]))
      }
    }else if(!is.na(str_detect(grades_long$grade[i], ",")) &
             str_detect(grades_long$grade[i], ",") == F){
      course_name <- unlist(grades_long[i, "class"])
      matches_c <- which(as.character(grade$course) == course_name)
      grade_name <- unlist(grades_long[i, "grade"])
      matches_g <- which(as.character(grade$grade_value) == grade_name)
      grade_rel <- add_case(grade_rel, 
                             student_id = grades_long$student_id[i],
                             grade_id = unlist(grade[matches_g[matches_g %in% 
                                                                   matches_c], "grade_id"]))
    }
  }
  return(list(grade, grade_rel))
}
