# Load R functions and libraries
source("../grades_f.R")
source("../projects_f.R")
source("../scheduling_f.R")

availSurv <- read_csv("../data/Survey_1_Response_Data.csv")
projSurv <- read_csv("../data/Survey_2_Responses_Data.csv")
projInfo <- read_csv("../data/ProjectData - Sheet1.csv")
eligible <- read_csv("../data/Example_Capstone_Prerequisite_Data.csv")

userData <- FALSE
availSurvBool <- FALSE
projSurvBool <- FALSE
eligibleBool <- FALSE
connected <-  TRUE

if(connected == TRUE){
  print("Connected to the DB this is where I am going to clean")
  if(!is.null(availSurv))
  {
    cleanAvailVec <- scheduling(availSurv)
    availSurvBool <- TRUE
  }
  if(!is.null(availSurv))
  {
    if(!is.null(projSurv) & !is.null(projInfo))
    {
      cleanProjVec <- projects(projSurv, projInfo) 
      projSurvBool <- TRUE
    }
    if(!is.null(eligible))
    {
      cleanGradeVec <- grading(eligible)
      eligibleBool <- TRUE
    }
  }
}

if(availSurvBool == TRUE)
{
  student_df <- cleanAvailVec[[1]]
  avail_df <- cleanAvailVec[[2]]
  avail_rel_df <- cleanAvailVec[[3]]
  avail_comm_df <- cleanAvailVec[[4]]
}
if(projSurvBool == TRUE)
{
  interst_df <- cleanProjVec[[1]]
  skill_df <- cleanProjVec[[2]]
  work_style_df <- cleanProjVec[[3]]
  project_rel_df <- cleanProjVec[[4]]
  role_df <- cleanProjVec[[5]]
  interested_in_df <- cleanProjVec[[6]]
  skilled_in_df <- cleanProjVec[[7]]
}
if(eligibleBool == TRUE)
{
  grade_df <- cleanGradeVec[[1]]
  grade_rel_df <- cleanGradeVec[[2]]
}
