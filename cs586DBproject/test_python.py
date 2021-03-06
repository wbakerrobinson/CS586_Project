import psycopg2
import pandas
import io

connected = True
dbData = False
ddl_run = 0

try:
    conn = psycopg2.connect(
      dbname = r.dbName,
      user = r.username,
      host = r.host,
      password = r.password
    )
except psycopg2.Error as error:
    print(error)
    pass
    connected = False
if(connected):
  conn.autocommit = True
  cur = conn.cursor()
  cur.execute("SELECT 1 FROM information_schema.tables WHERE table_name = 'student';")
  if(cur.fetchone() is not None):
    ddl_run = 1
  data_exists = []
  has_data = 0
  # fix with None
  if(ddl_run == 1):
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
      
def to_file_obj( dataframe ):
  s_buf = io.StringIO()
  dataframe.to_csv(s_buf, index = False, header = False, na_rep = 'NULL', sep = '\t')
  s_buf.seek(0)
  return s_buf;
  
if(r.availSurvBool == True):
  student_df = r.student_df.astype({'student_id':'int'})
  avail_df = r.avail_df.astype({'availability_id':'int'})
  avail_rel_df = r.avail_rel_df.astype('int')
  avail_comm_df = r.avail_comm_df.astype({'student_id':'int'})
if(r.projSurvBool == True):
  interest_df = r.interst_df.astype({'student_id':'int'})
  skill_df = r.skill_df.astype({'student_id':'int'})
  work_style_df = r.work_style_df.astype({'student_id':'int'})
  project_df = r.project_df.astype({'project_id':'int'})
  project_rel_df = r.project_rel_df.astype({'project_id':'int', 'student_id':'int', 'interest':'int', 'confidence':'int'})
  role_df = r.role_df.astype({'student_id':'int', 'role_id':'int'})
  interested_in_df = r.interested_in_df.astype({'student_id':'int'})
  skilled_in_df = r.skilled_in_df.astype({'student_id':'int'})
if(r.eligibleBool == True):
  grade_df = r.grade_df.astype({'grade_id':'int'})
  grade_rel_df = r.grade_rel_df.astype({'student_id':'int', 'grade_id':'int'})

if (connected == True and r.availSurvBool == True and ddl_run == 0):
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
  day_of_week varchar(10) NOT NULL,
  mtg_time varchar(10) NOT NULL,
  description varchar(10) NOT NULL
  );
  """,
  """ CREATE TABLE availability_rel(
  student_id integer REFERENCES student(student_id),
  availability_id integer REFERENCES availability(availability_id),
  PRIMARY KEY (student_id, availability_id)
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
  organization varchar(150),
  contact_name text,
  contact_email text,
  project_name text,
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
  """ CREATE TABLE grade(
  grade_id integer PRIMARY KEY,
  course varchar(6) NOT NULL,
  grade_value varchar(4) NOT NULL
  );
  """,
  """ CREATE TABLE grade_rel(
  student_id integer REFERENCES student(student_id),
  grade_id integer REFERENCES grade(grade_id),
  PRIMARY KEY (student_id, grade_id)
  );
  """,
  """ CREATE TABLE interested_in(
  student_id integer REFERENCES student(student_id),
  interested_id integer NOT NULL,
  comment text
  );
  """,
  """ CREATE TABLE skilled_in(
  student_id integer REFERENCES student(student_id),
  familiar_id integer NOT NULL,
  comment text
  );
  """,
  """ CREATE TABLE role(
  student_id integer REFERENCES student(student_id),
  role_id integer NOT NULL,
  comment text,
  CHECK (role_id >= 0 AND role_id <= 4)
  );
  """,
  """ CREATE TABLE work_style(
  student_id integer REFERENCES student(student_id),
  strength text NOT NULL,
  weakness text NOT NULL,
  work varchar(18) NOT NULL,
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
  except psycopg2.DatabaseError as error:
    pass
    print(error)
  
  # upload availability survey
  try:
    cur.copy_from(to_file_obj(student_df), 'student', sep = '\t', null = 'NULL')
    cur.copy_from(to_file_obj(avail_df), 'availability', sep = '\t', null = 'NULL')
    cur.copy_from(to_file_obj(avail_rel_df), 'availability_rel', sep = '\t', null = 'NULL')
    cur.copy_from(to_file_obj(avail_comm_df), 'availability_comments', sep = '\t', null = 'NULL')
    ddl_run = 1
  except psycopg2.DatabaseError as error:
    pass
    print(error)
if (connected == True and ddl_run == 1):
  if(r.projSurvBool == True):
    print("project data will be uploaded here")
    try:
      cur.copy_from(to_file_obj(interest_df), 'interest', sep = '\t', null = 'NULL')
      cur.copy_from(to_file_obj(skill_df), 'skill', sep = '\t', null = 'NULL')
      cur.copy_from(to_file_obj(work_style_df), 'work_style', sep = '\t', null = 'NULL')
      cur.copy_from(to_file_obj(project_df), 'project', sep = '\t', null = 'NULL')
      cur.copy_from(to_file_obj(project_rel_df), 'project_rel', sep = '\t', null = 'NULL')
      cur.copy_from(to_file_obj(role_df), 'role', sep = '\t', null = 'NULL')
      cur.copy_from(to_file_obj(interested_in_df), 'interested_in', sep = '\t', null = 'NULL')
      cur.copy_from(to_file_obj(skilled_in_df), 'skilled_in', sep = '\t', null = 'NULL')
    except psycopg2.DatabaseError as error:
      pass
      print(error)
  if(r.eligibleBool == True):
    print("grade data will be uploaded here")
    try:
      cur.copy_from(to_file_obj(grade_df), 'grade', sep = '\t', null = 'NULL')
      cur.copy_from(to_file_obj(grade_rel_df), 'grade_rel', sep = '\t', null = 'NULL')
    except psycopg2.DatabaseError as error:
      pass
      print(error)
  else:
    print("Connected, and database is setup. No data to upload or database already has data")
elif(connected == True and r.availSurvBool == False and ddl_run == 0):
  print("ERROR: Connected but no data exists in the database, and no data provided to add")
else:
  print("Not connected")
# Check if you can query the table for the questions below
if (connected == True and r.availSurvBool == True and ddl_run == 0):
  cur.execute("DROP TABLE availability_rel;")
  cur.execute("DROP TABLE availability_comments;")
  cur.execute("DROP TABLE interest;")
  cur.execute("DROP TABLE skill CASCADE;")
  cur.execute("DROP TABLE work_style;")
  cur.execute("DROP TABLE role;")
  cur.execute("DROP TABLE interested_in;")
  cur.execute("DROP TABLE skilled_in;")
  cur.execute("DROP TABLE project_rel cascade;")
  cur.execute("DROP TABLE project cascade;")
  cur.execute("DROP TABLE grade_rel;")
  cur.execute("DROP TABLE grade;")
  cur.execute("DROP TABLE availability cascade;")
  cur.execute("DROP TABLE student cascade;")
if(connected):
  conn.close()

