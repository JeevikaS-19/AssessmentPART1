-- CodeJudge Schema

PRAGMA foreign_keys = ON;

-- batches
CREATE TABLE batches (
    batch_id      INTEGER PRIMARY KEY,
    batch_code    TEXT    NOT NULL UNIQUE,
    program       TEXT    NOT NULL,
    start_date    DATE    NOT NULL,
    end_date      DATE,
    batch_status  TEXT    NOT NULL DEFAULT 'active'
                          CHECK (batch_status IN ('active','completed','inactive'))
);

-- courses
CREATE TABLE courses (
    course_id      INTEGER PRIMARY KEY,
    course_code    TEXT    NOT NULL UNIQUE,
    course_title   TEXT    NOT NULL,
    course_status  TEXT    NOT NULL DEFAULT 'active'
                           CHECK (course_status IN ('active','archived')),
    credit_hours   INTEGER NOT NULL CHECK (credit_hours > 0)
);

-- students
CREATE TABLE students (
    student_id        INTEGER PRIMARY KEY,
    roll_number       TEXT    NOT NULL UNIQUE,
    full_name         TEXT    NOT NULL,
    email             TEXT    NOT NULL UNIQUE,
    batch_id          INTEGER NOT NULL REFERENCES batches(batch_id),
    admission_date    DATE    NOT NULL,
    enrollment_status TEXT    NOT NULL DEFAULT 'active'
                              CHECK (enrollment_status IN ('active','dropped','graduated')),
    graduation_year   INTEGER
);

-- enrollments
CREATE TABLE enrollments (
    enrollment_id     INTEGER PRIMARY KEY,
    student_id        INTEGER NOT NULL REFERENCES students(student_id),
    course_id         INTEGER NOT NULL REFERENCES courses(course_id),
    enrolled_on       DATE    NOT NULL,
    enrollment_status TEXT    NOT NULL DEFAULT 'active'
                              CHECK (enrollment_status IN ('active','dropped','completed')),
    final_grade       TEXT,
    UNIQUE (student_id, course_id)
);

-- problems
CREATE TABLE problems (
    problem_id    INTEGER PRIMARY KEY,
    course_id     INTEGER NOT NULL REFERENCES courses(course_id),
    problem_code  TEXT    NOT NULL UNIQUE,
    title         TEXT    NOT NULL,
    difficulty    TEXT    NOT NULL CHECK (difficulty IN ('Easy','Medium','Hard')),
    max_score     INTEGER NOT NULL CHECK (max_score > 0),
    created_at    DATETIME NOT NULL,
    is_active     INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1))
);

-- test_cases
CREATE TABLE test_cases (
    test_case_id           INTEGER PRIMARY KEY,
    problem_id             INTEGER NOT NULL REFERENCES problems(problem_id),
    case_no                INTEGER NOT NULL,
    input_label            TEXT,
    expected_output_label  TEXT,
    points                 INTEGER NOT NULL DEFAULT 0 CHECK (points >= 0),
    is_hidden              INTEGER NOT NULL DEFAULT 0 CHECK (is_hidden IN (0, 1)),
    UNIQUE (problem_id, case_no)
);

-- contests
CREATE TABLE contests (
    contest_id      INTEGER PRIMARY KEY,
    course_id       INTEGER  NOT NULL REFERENCES courses(course_id),
    contest_title   TEXT     NOT NULL,
    start_time      DATETIME NOT NULL,
    end_time        DATETIME NOT NULL,
    contest_status  TEXT     NOT NULL DEFAULT 'upcoming'
                             CHECK (contest_status IN ('upcoming','ongoing','ended')),
    CHECK (end_time > start_time)
);

-- contest_problems
CREATE TABLE contest_problems (
    contest_id     INTEGER NOT NULL REFERENCES contests(contest_id),
    problem_id     INTEGER NOT NULL REFERENCES problems(problem_id),
    problem_order  INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (contest_id, problem_id)
);

-- submissions
CREATE TABLE submissions (
    submission_id  INTEGER  PRIMARY KEY,
    student_id     INTEGER  NOT NULL REFERENCES students(student_id),
    problem_id     INTEGER  NOT NULL REFERENCES problems(problem_id),
    contest_id     INTEGER  REFERENCES contests(contest_id),
    language       TEXT     NOT NULL,
    submitted_at   DATETIME NOT NULL,
    status         TEXT     NOT NULL
                            CHECK (status IN ('Accepted','Wrong Answer','TLE','MLE','CE','RE','Pending')),
    score          REAL     NOT NULL DEFAULT 0 CHECK (score >= 0),
    runtime_ms     INTEGER  CHECK (runtime_ms >= 0)
);

-- test_results
CREATE TABLE test_results (
    result_id      INTEGER PRIMARY KEY,
    submission_id  INTEGER NOT NULL REFERENCES submissions(submission_id),
    test_case_id   INTEGER NOT NULL REFERENCES test_cases(test_case_id),
    result_status  TEXT    NOT NULL
                           CHECK (result_status IN ('pass','fail','TLE','MLE','CE','RE')),
    runtime_ms     INTEGER CHECK (runtime_ms >= 0),
    memory_kb      INTEGER CHECK (memory_kb >= 0),
    awarded_points INTEGER NOT NULL DEFAULT 0 CHECK (awarded_points >= 0),
    UNIQUE (submission_id, test_case_id)
);

-- sessions
CREATE TABLE sessions (
    session_id     INTEGER PRIMARY KEY,
    course_id      INTEGER NOT NULL REFERENCES courses(course_id),
    session_title  TEXT    NOT NULL,
    session_date   DATE    NOT NULL,
    session_type   TEXT    NOT NULL
                           CHECK (session_type IN ('lecture','tutorial','lab'))
);

-- attendance
CREATE TABLE attendance (
    attendance_id      INTEGER  PRIMARY KEY,
    session_id         INTEGER  NOT NULL REFERENCES sessions(session_id),
    student_id         INTEGER  NOT NULL REFERENCES students(student_id),
    attendance_status  TEXT     NOT NULL
                                CHECK (attendance_status IN ('present','absent','late')),
    marked_at          DATETIME,
    UNIQUE (session_id, student_id)
);

-- regrade_requests
CREATE TABLE regrade_requests (
    request_id      INTEGER  PRIMARY KEY,
    submission_id   INTEGER  NOT NULL REFERENCES submissions(submission_id),
    student_id      INTEGER  NOT NULL REFERENCES students(student_id),
    requested_at    DATETIME NOT NULL,
    reason          TEXT,
    request_status  TEXT     NOT NULL DEFAULT 'pending'
                             CHECK (request_status IN ('pending','approved','rejected')),
    resolved_at     DATETIME
);

-- plagiarism_flags
CREATE TABLE plagiarism_flags (
    flag_id                INTEGER  PRIMARY KEY,
    submission_id          INTEGER  NOT NULL REFERENCES submissions(submission_id),
    matched_submission_id  INTEGER  NOT NULL REFERENCES submissions(submission_id),
    similarity_score       REAL     NOT NULL CHECK (similarity_score BETWEEN 0 AND 100),
    flag_status            TEXT     NOT NULL DEFAULT 'pending'
                                    CHECK (flag_status IN ('pending','confirmed','dismissed')),
    created_at             DATETIME NOT NULL
);

-- raw_student_import (staging table, no FK constraints)
CREATE TABLE raw_student_import (
    raw_row_id      INTEGER PRIMARY KEY,
    roll_number     TEXT,
    full_name       TEXT,
    email           TEXT,
    batch_code      TEXT,
    admission_date  TEXT,
    import_status   TEXT DEFAULT 'pending'
                         CHECK (import_status IN ('pending','imported','failed')),
    import_notes    TEXT
);

-- operation_requests
CREATE TABLE operation_requests (
    operation_id       INTEGER  PRIMARY KEY,
    requested_by       TEXT     NOT NULL,
    operation_type     TEXT     NOT NULL CHECK (operation_type IN ('UPDATE','DELETE')),
    target_table       TEXT     NOT NULL,
    target_record_id   TEXT     NOT NULL,
    requested_at       DATETIME NOT NULL,
    reason             TEXT,
    approval_status    TEXT     NOT NULL DEFAULT 'pending'
                                CHECK (approval_status IN ('pending','approved','rejected')),
    executed_at        DATETIME
);
