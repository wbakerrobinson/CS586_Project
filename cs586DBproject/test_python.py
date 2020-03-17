# CHUNK 1
import psycopg2
import pandas
import io

connected = True
dbData = False

try:
    conn = psycopg2.connect(
      dbname = 'win20db2',
      user = 'win20db2',
      host = 'dbclass.cs.pdx.edu',
      password = '426Hillside!'
    )
except:
    print("ERROR: Unable to connect to database")
    connected = False
if(connected):
    conn.autocommit = True
    cur = conn.cursor()
    cur.execute("SELECT 1 FROM information_schema.tables WHERE table_name = 'student';")
    if(cur.fetchone() is None):
      ddl_run = 0
    else:
      ddl_run = 1
    data_exists = []
    has_data = 0
    # fix with None
    if(ddl_run):
      cur.execute("SELECT 1 FROM project;")
      if(cur.fetchone() is None):
        has_data = 0
      else:
        has_data = 1
      data_exists.append(has_data)
      cur.execute("SELECT 1 FROM grade;")
      if(cur.fetchone() is None):
        has_data = 0
      else:
        has_data = 1
      data_exists.append(has_data)
    else:
      data_exists.append(0)
      data_exists.append(0)
      
# function to change python to file
def to_file_obj( dataframe ):
  s_buf = io.StringIO()
  dataframe.to_csv(s_buf, index = False, header = False)
  s_buf.seek(0)
  return s_buf;

if(r.availSurvBool == True):
  student_df = r.student_df.astype({'student_id':'int'})
  avail_df = r.avail_df.astype({'availability_id':'int'})
  avail_rel_df = r.avail_rel_df.astype('int')
  avail_comm_df = r.avail_comm_df.astype({'student_id':'int'})
if(r.projSurvBool == True):
  interest_df = r.interst_df.astype({'student_id':'int'})
  skill_df = r.skill_df({'student_id':'int'})
  work_style_df = r.work_style_df({'student_id':'int'})
  project_rel_df = r.project_rel_df.astype({'project_id':'int', 'student_id':'int', 'interest':'int', 'confidence':'int'})
  role_df = r.role_df.astype({'student_id':'int', 'role_id':'int'})
  interested_in_df = r.interested_in_df.astype({'student_id':'int'})
  skilled_in_df = r.skilled_in_df.astype({'student_id':'int'})
if(r.eligibleBool == True):
  grade_df = r.grade_df({'student_id':'int'})
  grade_rel_df = r.grade_rel_df.astype({'student_id':'int', 'grade_id':'int'})

if (connected == True and r.availSurvBool == True and ddl_run == False):
  print("Connected, user supplied data, time to run DDL")
  commands = (
  """  CREATE TABLE student (
  student_id integer PRIMARY KEY,
  name varchar(50) NOT NULL,
  email varchar(50) UNIQUE NOT NULL
  );
  """,
  """ CREATE TABLE availability(
  availability_id integer PRIMARY KEY,
  day_of_week integer NOT NULL,
  mtg_time integer NOT NULL,
  description integer NOT NULL,
  CHECK (description == 1 OR description == 0),
  CHECK (day_of_week >= 0 AND day_of_week <= 6),
  CHECK (mtg_time >= 0 AND mtg_time <= 17)
  );
  """,
  """ CREATE TABLE availability_rel(
  student_id integer REFERENCES student(student_id),
  availability_id integer REFERENCES availability(availability_id),
  PRIMARY KEY(student_id, availability_id)
  );
  """,
  """ CREATE TABLE availability_comments(
  student_id integer REFERENCES student(student_id),
  avail_comment text,
  unavailability text,
  other text,
  PRIMARY KEY(student_id)
  );
  """,
  """ CREATE TABLE project(
  project_id integer PRIMARY KEY,
  organization varchar(50),
  contact_name text,
  contact_email text,
  description text
  );
  """,
  """ CREATE TABLE project_rel(
  project_id integer REFERENCES project(project_id),
  student_id integer REFERENCES student(student_id),
  interest integer NOT NULL,
  confidence integer NOT NULL,
  comment text,
  CHECK (interest >= 0 AND interest <= 10),
  CHECK (confidence >= 0 AND confidence <= 5)
  );
  """,
  """ CREATE TABLE grade_rel(
  student_id integer REFERENCES student(student_id),
  grade_id integer REFERENCES grade(grade_id)
  PRIMARY KEY(student_id, grade_id)
  );
  """,
  """ CREATE TABLE grade(
  grade_id integer PRIMARY KEY,
  course integer NOT NULL,
  grade_value integer NOT NULL,
  CHECK (course >= 0 AND course <= 11),
  CHECK (grade_value >= 0 AND grade_value <= 21)
  );
  """,
  """ CREATE TABLE interested_in(
  student_id integer REFERENCES student(student_id),
  interested_id integer NOT NULL,
  comment text,
  CHECK (interested_id >= 0 AND interested_id <= 7)
  );
  """,
  """ CREATE TABLE skilled_in(
  student_id integer REFERENCES student(student_id),
  familiar_id integer NOT NULL,
  comment text,
  CHECK (familiar_id >= 0 AND familiar_id <= 7)
  );
  """,
  """ CREATE TABLE roll(
  student_id integer REFERENCES student(student_id),
  role_id integer NOT NULL,
  comment text,
  CHECK (role_id >= 0 AND role_id <= 4)
  );
  """,
  """ CREATE TABLE work_info(
  student_id integer REFERENCES student(student_id),
  strength text NOT NULL,
  weakness text NOT NULL,
  work integer NOT NULL,
  know_about text,
  other text 
  );
  """,
  """ CREATE TABLE interest(
  student_id integer REFERENCES student(student_id),
  interest_most text NOT NULL,
  interest_least text NOT NULL,
  cs_enjoy text NOT NULL
  );
  """,
  """ CREATE TABLE skill(
  student_id integer REFERENCES student(student_id),
  know_most text NOT NULL,
  know_least text NOT NULL,
  languages text NOT NULL
  );
  """)
  try:
    for command in commands:
      cur.execute(command)
  except:
    print("Error unable to execute DDL commands")
  print("DDL run, now time to upload data!")
  # upload availability survey
  cur.copy_from(to_file_obj(student_df), 'student', sep = ',')
  cur.copy_from(to_file_obj(avail_df), 'availability', sep = ',')
  cur.copy_from(to_file_obj(avail_rel_df), 'availability_rel', sep = ',')
  cur.copy_from(to_file_obj(avail_comm_df), 'availability_comments', sep = ',')
if (connected == True and ddl_run == True):
  if(r.projSurvBool == True):
    print("project data will be uploaded here")
  if(r.eligibleBool == True):
    print("grade data will be uploaded here")
  else:
    print("Connected, and database is setup. No data to upload or database already has data")
elif(connected == True and r.availSurvBool == False and ddl_run == False):
  print("ERROR: Connected but no data exists in the database, and no data provided to add")
else:
  print("Not connected")
# Check if you can query the table for the questions below

if(connected):
  conn.close()
