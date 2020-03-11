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

# Temporarily allow for an attribute representing academic term

grades_long$quarter <- vector("character", nrow(grades_long))

courses <- data.frame(unique(grades_long$class))
names(courses) <- "course_id"

course_rel <- as.tbl(data.frame(student_id = vector("numeric"),
                                course_id = vector("character"),
                                grade = vector("character"),
                                term = vector("character")))

for(i in 1:length(grades_long$student_id)){
  final_grade <- ""
  if(!is.na(unlist(grades_long[i, "grade"])) & 
            str_detect(unlist(grades_long[i, "grade"]), ",")){
    grades <- unlist(strsplit(unlist(grades_long[i, "grade"]),
                       split = ",", fixed = T))
    for(j in 1:length(grades)){
      grades[j] <- trimws(grades[j])
    }
    
    # This section is for if we want the "highest" grade
    
    # highest_index <- match(grades, c("A", "A-", "B+", "B", "B-",
    #                                  "C+", "C", "C-", "D+", "D",
    #                                  "D-", "F", "RF", "W*", "IP",
    #                                  "I", "X", "M", "AU", "P", "NP"))
    # if(sum(highest_index %in% 1:12) > 0){
    #   final_grade <- c("A", "A-", "B+", "B", "B-",
    #                    "C+", "C", "C-", "D+", "D",
    #                    "D-", "F", "RF", "W*", "IP",
    #                    "I", "X", "M", "AU", "P", "NP")[min(highest_index)]
    # }else{
    #   final_grade <- "No letter grade"
    # }
  }else{
    final_grade <- unlist(grades_long[i, "grade"])
  }
  course_rel <- add_case(course_rel,
                        student_id = unlist(grades_long[i, "student_id"]),
                        course_id = unlist(grades_long[i, "class"]),
                        grade = final_grade,
                        term = unlist(grades_long[i, "quarter"]))
}

