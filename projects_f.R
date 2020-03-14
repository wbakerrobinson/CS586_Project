# Reading in the .csv file

projects_raw <- read_csv(
  ".\\data\\Survey_2_Responses_Data.csv", col_types = cols())

# Making shorter attribute names

names(projects_raw) <- c("time", "email", "name", "p1_interest",
                         "p1_confidence", "p1_comments", "p2_interest", 
                         "p2_confidence", "p2_comments", "p3_interest",
                         "p3_confidence", "p3_comments", "p4_interest", 
                         "p4_confidence", "p4_comments", "p5_interest", 
                         "p5_confidence", "p5_comments", "p6_interest", 
                         "p6_confidence", "p6_comments", "p7_interest", 
                         "p7_confidence", "p7_comments", "p8_interest",
                         "p8_confidence", "p8_comments", "s_interest_m",
                         "s_interest_l", "s_knowledge_m", "s_knowledge_l",
                         "familiar", "interested", "strength", "weakness",
                         "enjoyed", "languages", "work", "roles", "know_about",
                         "understandings1", "understandings2", "other")

# Placeholder for student id

projects_raw$student_id <- 1:nrow(projects_raw)

# Reading in the projects spreadsheet

project <- read_csv(
  ".\\data\\ProjectData - Sheet1.csv", col_types = cols())

names(project) <- c("project_id", "organization", "contact",
                    "contact_email", "project_name", "description")

project_rel <- data.frame(project_id = vector("numeric"),
                          student_id = vector("numeric"),
                          interest = vector("numeric"),
                          confidence = vector("numeric"),
                          comment = vector("character"),
                          stringsAsFactors = F)

for(i in 1:nrow(projects_raw)){
  for(j in 1:8){
    c1 <- which(names(projects_raw) == paste0("p", j, "_interest"))
    c2 <- which(names(projects_raw) == paste0("p", j, "_confidence"))
    c3 <- which(names(projects_raw) == paste0("p", j, "_comments"))
    project_rel <- add_case(project_rel,
                            student_id = projects_raw[i, "student_id"],
                            project_id = j,
                            interest = unlist(projects_raw[i, c1]),
                            confidence = unlist(projects_raw[i, c2]),
                            comment = unlist(projects_raw[i, c3]))
  }
}