# Let survey_2 be the .csv file for the student
# responses to the projects question and project_desc
# the table of the project descriptions and contact information

# This function outputs a project rel table

projects <- function(survey_2, project_desc){

  projects_raw <- survey_2

  # Making shorter attribute names

  names(projects_raw) <- c("time", "student_id", "email", "name", "p1_interest",
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

  # Reading in the projects spreadsheet

  project <- project_desc

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
}
