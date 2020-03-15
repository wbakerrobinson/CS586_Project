library(tibble)

# Let survey_2 be the .csv file for the student
# responses to the projects questions and project_desc
# the table of the project descriptions and contact information

# This function outputs a interest table, skill table,
# work_style table, project rel table, 
# role rel table, familiar rel table, and interested rel table

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
  
  interest <- projects_raw[, c("student_id",
                                 "s_interest_m",
                                 "s_interest_l",
                                 "enjoyed")]
  
  skill <- projects_raw[, c("student_id",
                               "s_knowledge_m",
                               "s_knowledge_l",
                               "languages")]
  
  work_style <- projects_raw[, c("student_id",
                                 "strength",
                                 "weakness",
                                 "work",
                                 "know_about",
                                 "other")]
  
  work_style[["work"]] <- as.factor(work_style[["work"]])
  
  role_rel_pre <- projects_raw[, c("student_id",
                               "roles")]
  
  # 0: Code writing
  # 1: Research
  # 2: Design
  # 3: Planning
  # 4: Other
  
  # Creating the rel table for the many-to-many relationship
  
  role_rel <- as.tbl(data.frame(student_id = vector("numeric"),
                                 role_id = vector("numeric"),
                                comment = vector("character"),
                                stringsAsFactors = F))
  # Populating the rel table
  
  for(i in 1:nrow(role_rel_pre)){
    if(!is.na(str_detect(role_rel_pre$roles[i], ",")) &
       str_detect(role_rel_pre$roles[i], ",")){
      multiple <- unlist(strsplit(role_rel_pre$roles[i], split = ",", fixed = T))
      multiple <- sapply(multiple, trimws)
      for(j in 1:length(multiple)){
        if(multiple[j] == "Code Writing"){
          role <- 0
          comments <- NA
        }else if(multiple[j] == "Research"){
          role <- 1
          comments <- NA
        }else if(multiple[j] == "Design"){
          role <- 2
          comments <- NA
        }else if(multiple[j] == "Planning"){
          role <- 3
          comments <- NA
        }else{
          role <- 4
          comments <- multiple[j]
        }
        role_rel <- add_case(role_rel, 
                              student_id = role_rel_pre$student_id[i],
                              role_id = role,
                              comment = comments)
      }
    }else if(!is.na(str_detect(role_rel_pre$roles[i], ",")) &
             str_detect(role_rel_pre$roles[i], ",") == F){
      if(unlist(role_rel_pre[i, "roles"]) == "Code Writing"){
        role <- 0
        comments <- NA
      }else if(unlist(role_rel_pre[i, "roles"]) == "Research"){
        role <- 1
        comments <- NA
      }else if(unlist(role_rel_pre[i, "roles"]) == "Design"){
        role <- 2
        comments <- NA
      }else if(unlist(role_rel_pre[i, "roles"]) == "Planning"){
        role <- 3
        comments <- NA
      }else{
        role <- 4
        comments <- unlist(role_rel_pre[i, "roles"])
      }
      role_rel <- add_case(role_rel, 
                           student_id = role_rel_pre$student_id[i],
                           role_id = role,
                           comment = comments)
    }
  }
  
  role_rel[["role_id"]] <- as.factor(role_rel[["role_id"]])
    
  familiar_rel_pre <- projects_raw[, c("student_id",
                                  "familiar")]
  
  # 0: Front-end development
  # 1: Back-end development
  # 2: Server side
  # 3: Web development
  # 4: Mobile development
  # 5: Embedded systems
  # 6: UI
  # 7: UX
  # 8: None of these
  # 9: Other
  
  # Creating the rel table for the many-to-many relationship
  
  familiar_rel <- as.tbl(data.frame(student_id = vector("numeric"),
                                familiar_id = vector("numeric"),
                                comment = vector("character"),
                                stringsAsFactors = F))
  # Populating the rel table
  
  for(i in 1:nrow(familiar_rel_pre)){
    if(!is.na(str_detect(familiar_rel_pre$familiar[i], ",")) &
       str_detect(familiar_rel_pre$familiar[i], ",")){
      multiple <- unlist(strsplit(familiar_rel_pre$familiar[i], split = ",", fixed = T))
      multiple <- sapply(multiple, trimws)
      for(j in 1:length(multiple)){
        if(multiple[j] == "Front-end development"){
          familiar <- 0
          comments <- NA
        }else if(multiple[j] == "Back-end development"){
          familiar <- 1
          comments <- NA
        }else if(multiple[j] == "Server side"){
          familiar <- 2
          comments <- NA
        }else if(multiple[j] == "Web development"){
          familiar <- 3
          comments <- NA
        }else if(multiple[j] == "Mobile development"){
          familiar <- 4
          comments <- NA
        }else if(multiple[j] == "Embedded systems"){
          familiar <- 5
          comments <- NA
        }else if(multiple[j] == "UI"){
          familiar <- 6
          comments <- NA
        }else if(multiple[j] == "UX"){
          familiar <- 7
          comments <- NA
        }else if(multiple[j] == "None of these"){
          familiar <- 8
          comments <- NA
        }else{
          familiar <- 9
          comments <- multiple[j]
        }
        familiar_rel <- add_case(familiar_rel, 
                             student_id = familiar_rel_pre$student_id[i],
                             familiar_id = familiar,
                             comment = comments)
      }
    }else if(!is.na(str_detect(familiar_rel_pre$familiar[i], ",")) &
             str_detect(familiar_rel_pre$familiar[i], ",") == F){
      if(unlist(familiar_rel_pre$familiar[i]) == "Front-end development"){
        familiar <- 0
        comments <- NA
      }else if(unlist(familiar_rel_pre$familiar[i]) == "Back-end development"){
        familiar <- 1
        comments <- NA
      }else if(unlist(familiar_rel_pre$familiar[i]) == "Server side"){
        familiar <- 2
        comments <- NA
      }else if(unlist(familiar_rel_pre$familiar[i]) == "Web development"){
        familiar <- 3
        comments <- NA
      }else if(unlist(familiar_rel_pre$familiar[i]) == "Mobile development"){
        familiar <- 4
        comments <- NA
      }else if(unlist(familiar_rel_pre$familiar[i]) == "Embedded systems"){
        familiar <- 5
        comments <- NA
      }else if(unlist(familiar_rel_pre$familiar[i]) == "UI"){
        familiar <- 6
        comments <- NA
      }else if(unlist(familiar_rel_pre$familiar[i]) == "UX"){
        familiar <- 7
        comments <- NA
      }else if(unlist(familiar_rel_pre$familiar[i]) == "None of these"){
        familiar <- 8
        comments <- NA
      }else{
        familiar <- 9
        comments <- unlist(familiar_rel_pre$familiar[i])
      }
      familiar_rel <- add_case(familiar_rel, 
                           student_id = familiar_rel_pre$student_id[i],
                           familiar_id = role,
                           comment = comments)
    }
  }
  
  familiar_rel[["familiar_id"]] <- as.factor(familiar_rel[["familiar_id"]])
    
  interested_rel_pre <- projects_raw[, c("student_id",
                                     "interested")]
  
  # 0: Front-end development
  # 1: Back-end development
  # 2: Server side
  # 3: Web development
  # 4: Mobile development
  # 5: Embedded systems
  # 6: UI
  # 7: UX
  # 8: None of these
  # 9: Other
  
  # Creating the rel table for the many-to-many relationship
  
  interested_rel <- as.tbl(data.frame(student_id = vector("numeric"),
                                    interested_id = vector("numeric"),
                                    comment = vector("character"),
                                    stringsAsFactors = F))
  # Populating the rel table
  
  for(i in 1:nrow(interested_rel_pre)){
    if(!is.na(str_detect(interested_rel_pre$interested[i], ",")) &
       str_detect(interested_rel_pre$interested[i], ",")){
      multiple <- unlist(strsplit(interested_rel_pre$interested[i], split = ",", fixed = T))
      multiple <- sapply(multiple, trimws)
      for(j in 1:length(multiple)){
        if(multiple[j] == "Front-end development"){
          interested <- 0
          comments <- NA
        }else if(multiple[j] == "Back-end development"){
          interested <- 1
          comments <- NA
        }else if(multiple[j] == "Server side"){
          interested <- 2
          comments <- NA
        }else if(multiple[j] == "Web development"){
          interested <- 3
          comments <- NA
        }else if(multiple[j] == "Mobile development"){
          interested <- 4
          comments <- NA
        }else if(multiple[j] == "Embedded systems"){
          interested <- 5
          comments <- NA
        }else if(multiple[j] == "UI"){
          interested <- 6
          comments <- NA
        }else if(multiple[j] == "UX"){
          interested <- 7
          comments <- NA
        }else if(multiple[j] == "None of these"){
          interested <- 8
          comments <- NA
        }else{
          interested <- 9
          comments <- multiple[j]
        }
        interested_rel <- add_case(interested_rel, 
                                 student_id = interested_rel_pre$student_id[i],
                                 interested_id = interested,
                                 comment = comments)
      }
    }else if(!is.na(str_detect(interested_rel_pre$interested[i], ",")) &
             str_detect(interested_rel_pre$interested[i], ",") == F){
      if(unlist(interested_rel_pre$interested[i]) == "Front-end development"){
        interested <- 0
        comments <- NA
      }else if(unlist(interested_rel_pre$interested[i]) == "Back-end development"){
        interested <- 1
        comments <- NA
      }else if(unlist(interested_rel_pre$interested[i]) == "Server side"){
        interested <- 2
        comments <- NA
      }else if(unlist(interested_rel_pre$interested[i]) == "Web development"){
        interested <- 3
        comments <- NA
      }else if(unlist(interested_rel_pre$interested[i]) == "Mobile development"){
        interested <- 4
        comments <- NA
      }else if(unlist(interested_rel_pre$interested[i]) == "Embedded systems"){
        interested <- 5
        comments <- NA
      }else if(unlist(interested_rel_pre$interested[i]) == "UI"){
        interested <- 6
        comments <- NA
      }else if(unlist(interested_rel_pre$interested[i]) == "UX"){
        interested <- 7
        comments <- NA
      }else if(unlist(interested_rel_pre$interested[i]) == "None of these"){
        interested <- 8
        comments <- NA
      }else{
        interested <- 9
        comments <- unlist(interested_rel_pre$interested[i])
      }
      interested_rel <- add_case(interested_rel, 
                           student_id = interested_rel_pre$student_id[i],
                           interested_id = role,
                           comment = comments)
    }
  }
  
  interested_rel[["interested_id"]] <- as.factor(interested_rel[["interested_id"]])
  return(interest, skill, work_style, project_rel, role_rel, familiar_rel, interested_rel)
}
