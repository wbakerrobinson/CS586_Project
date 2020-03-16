-- Table for student information
CREATE TABLE student(
    student_id integer PRIMARY KEY,
    name varchar(50) NOT NULL,
    email varchar(50) UNIQUE NOT NULL,
    CHECK (LENGTH(student_id) == 9)
);

-- Table for student availability
CREATE TABLE availability(
    availability_id integer PRIMARY KEY,
    day_of_week integer NOT NULL,
    mtg_time integer NOT NULL,
    description integer NOT NULL,
    CHECK (description == 1 OR description == 0),
    CHECK (day_of_week >= 0 AND day_of_week <= 6),
    CHECK (mtg_time >= 0 AND mtg_time <= 17)
);

-- Matches students with valid availability
CREATE TABLE availability_rel(
    student_id integer REFERENCES student(student_id),
    availability_id integer REFERENCES availability(availability_id),
    PRIMARY KEY(student_id, availability_id)
);

-- Stores comments on student availability
CREATE TABLE availability_comments(
    student_id integer REFERENCES student(student_id),
    avail_comment text,
    unavailability text,
    other text,
    PRIMARY KEY(student_id)
);

-- Table for project information
CREATE TABLE project(
    project_id integer PRIMARY KEY,
    organization varchar(50),
    contact_name text,
    contact_email text,
    description text
);

-- Table for project rel with student
CREATE TABLE project_rel(
    project_id integer REFERENCES project(project_id),
    student_id integer REFERENCES student(student_id),
    interest integer NOT NULL,
    confidence integer NOT NULL,
    comment text,
    CHECK (interest >= 0 AND interest <= 10),
    CHECK (confidence >= 0 AND confidence <= 5)
);

-- Table for grade / student relation
CREATE TABLE grade_rel(
    student_id integer REFERENCES student(student_id),
    grade_id integer REFERENCES grade(grade_id)
    PRIMARY KEY(student_id, grade_id)
);

-- Table for grades
CREATE TABLE grade(
    grade_id integer PRIMARY KEY,
    course integer NOT NULL,
    grade_value integer NOT NULL,
    CHECK (course >= 0 AND course <= 11),
    CHECK (grade_value >= 0 AND grade_value <= 21)
);

CREATE TABLE interested_in(
    student_id integer REFERENCES student(student_id),
    interested_id integer NOT NULL,
    comment text,
    CHECK (interested_id >= 0 AND interested_id <= 7)
);

CREATE TABLE skilled_in(
    student_id integer REFERENCES student(student_id),
    familiar_id integer NOT NULL,
    comment text,
    CHECK (familiar_id >= 0 AND familiar_id <= 7)
);

CREATE TABLE roll(
    student_id integer REFERENCES student(student_id),
    role_id integer NOT NULL,
    comment text,
    CHECK (role_id >= 0 AND role_id <= 4)
);

CREATE TABLE work_info(
    student_id integer REFERENCES student(student_id),
    strength text NOT NULL,
    weakness text NOT NULL,
    work integer NOT NULL,
    know_about text,
    other text 
);

CREATE TABLE interest(
    student_id integer REFERENCES student(student_id),
    interest_most text NOT NULL,
    interest_least text NOT NULL,
    cs_enjoy text NOT NULL
);

CREATE TABLE skill(
    student_id integer REFERENCES student(student_id),
    know_most text NOT NULL,
    know_least text NOT NULL,
    languages text NOT NULL
);

