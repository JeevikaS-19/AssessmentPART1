# Keys and Relationships — CodeJudge

## Key Types

| Term | Meaning |
|---|---|
| PK | Uniquely identifies each row |
| Candidate Key | Any column(s) that could be PK |
| Alternate Key | Candidate key not chosen as PK |
| FK | References PK of another table |
| Composite Key | PK made of two or more columns |

---

### batches
- PK: `batch_id`
- Alternate Key: `batch_code` (unique, not chosen as PK)

### courses
- PK: `course_id`
- Alternate Key: `course_code` (UNIQUE)
- CHECK: `credit_hours > 0`

### students
- PK: `student_id`
- Alternate Keys: `roll_number`, `email` (both UNIQUE)
- FK: `batch_id → batches`

### enrollments
- PK: `enrollment_id`
- Composite Candidate Key: `(student_id, course_id)` — enforced via UNIQUE
- FK: `student_id → students`, `course_id → courses`

### problems
- PK: `problem_id`
- Alternate Key: `problem_code` (UNIQUE)
- FK: `course_id → courses`
- CHECK: `max_score > 0`, `difficulty IN ('Easy','Medium','Hard')`

### test_cases
- PK: `test_case_id`
- Composite Candidate Key: `(problem_id, case_no)` — enforced via UNIQUE
- FK: `problem_id → problems`

### contests
- PK: `contest_id`
- FK: `course_id → courses`
- CHECK: `end_time > start_time`

### contest_problems
- Composite PK: `(contest_id, problem_id)`
- FK: `contest_id → contests`, `problem_id → problems`

### submissions
- PK: `submission_id`
- FK: `student_id → students`, `problem_id → problems`, `contest_id → contests` (nullable)
- CHECK: `score >= 0`

### test_results
- PK: `result_id`
- Composite Candidate Key: `(submission_id, test_case_id)` — enforced via UNIQUE
- FK: `submission_id → submissions`, `test_case_id → test_cases`

### sessions
- PK: `session_id`
- FK: `course_id → courses`
- CHECK: `session_type IN ('lecture','tutorial','lab')`

### attendance
- PK: `attendance_id`
- Composite Candidate Key: `(session_id, student_id)` — UNIQUE
- FK: `session_id → sessions`, `student_id → students`

### regrade_requests
- PK: `request_id`
- FK: `submission_id → submissions`, `student_id → students`

### plagiarism_flags
- PK: `flag_id`
- FK: `submission_id → submissions`, `matched_submission_id → submissions`
- CHECK: `similarity_score BETWEEN 0 AND 100`

### raw_student_import
- PK: `raw_row_id`
- No FK constraints (staging table)

### operation_requests
- PK: `operation_id`
- CHECK: `operation_type IN ('UPDATE','DELETE')`

---

## Relationship Summary

| Relationship | Type | Via |
|---|---|---|
| students ↔ batches | Many-to-One | students.batch_id |
| students ↔ courses | Many-to-Many | enrollments |
| courses ↔ problems | One-to-Many | problems.course_id |
| problems ↔ test_cases | One-to-Many | test_cases.problem_id |
| contests ↔ courses | Many-to-One | contests.course_id |
| contests ↔ problems | Many-to-Many | contest_problems |
| students ↔ submissions | One-to-Many | submissions.student_id |
| problems ↔ submissions | One-to-Many | submissions.problem_id |
| submissions ↔ test_results | One-to-Many | test_results.submission_id |
| test_cases ↔ test_results | One-to-Many | test_results.test_case_id |
| courses ↔ sessions | One-to-Many | sessions.course_id |
| sessions ↔ attendance | One-to-Many | attendance.session_id |
| students ↔ attendance | One-to-Many | attendance.student_id |
| submissions ↔ regrade_requests | One-to-Many | regrade_requests.submission_id |
| submissions ↔ plagiarism_flags | One-to-Many | both FK columns in plagiarism_flags |
