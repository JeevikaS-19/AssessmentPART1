# Schema Explanation — CodeJudge

CodeJudge is a platform where students attempt programming problems through contests or open practice. Code is submitted, run against test cases, and scored. Faculty manage batches, courses, sessions, and attendance.

---

### batches
An academic cohort — groups students admitted together under a program.

- `batch_id` — PK
- `batch_code` — e.g. "AI2023", unique
- `program` — e.g. B.Tech AIML
- `start_date`, `end_date` — duration
- `batch_status` — active/completed/inactive

---

### courses
Subjects offered on the platform.

- `course_id` — PK
- `course_code` — e.g. "CS301", unique
- `course_title`, `course_status`, `credit_hours`

---

### students
Master record per student.

- `student_id` — PK
- `roll_number`, `email` — both unique (candidate keys)
- `batch_id` — FK → batches
- `admission_date`, `graduation_year`, `enrollment_status`

---

### enrollments
Which student is in which course (many-to-many bridge).

- `student_id`, `course_id` — FKs; pair must be unique
- `enrolled_on`, `enrollment_status`, `final_grade`

---

### problems
Programming problems, each belonging to a course.

- `problem_id` — PK
- `course_id` — FK → courses
- `problem_code` — unique, e.g. "PROB001"
- `title`, `difficulty` (Easy/Medium/Hard), `max_score`, `is_active`

---

### test_cases
Test cases used to evaluate submissions. Each problem has multiple.

- `test_case_id` — PK
- `problem_id` — FK → problems
- `case_no` — sequence within a problem; `(problem_id, case_no)` unique
- `points`, `is_hidden`

---

### contests
A timed evaluation event for a course.

- `contest_id` — PK
- `course_id` — FK → courses
- `start_time`, `end_time`, `contest_status`

---

### contest_problems
Resolves many-to-many between contests and problems.

- `(contest_id, problem_id)` — composite PK
- `problem_order` — display order in contest

---

### submissions
Every code submission by a student for a problem.

- `submission_id` — PK
- `student_id`, `problem_id` — FKs
- `contest_id` — FK → contests, nullable (NULL = open practice)
- `language`, `submitted_at`, `status`, `score`, `runtime_ms`

---

### test_results
Per-test-case result for a submission.

- `result_id` — PK
- `submission_id`, `test_case_id` — FKs; pair must be unique
- `result_status`, `runtime_ms`, `memory_kb`, `awarded_points`

---

### sessions
Individual course meetings (lecture, tutorial, lab).

- `session_id` — PK
- `course_id` — FK → courses
- `session_title`, `session_date`, `session_type`

---

### attendance
Whether a student attended a session.

- `attendance_id` — PK
- `session_id`, `student_id` — FKs; pair must be unique
- `attendance_status` — present/absent/late
- `marked_at`

---

### regrade_requests
Students dispute a submission result.

- `request_id` — PK
- `submission_id`, `student_id` — FKs
- `requested_at`, `reason`, `request_status`, `resolved_at`

---

### plagiarism_flags
Raised when two submissions show high similarity.

- `flag_id` — PK
- `submission_id`, `matched_submission_id` — both FK → submissions
- `similarity_score` (0–100), `flag_status`

---

### raw_student_import
Staging table for bulk student imports. No FK constraints — data is validated before moving to `students`.

- `roll_number`, `full_name`, `email`, `batch_code`, `admission_date`
- `import_status`, `import_notes`

---

### operation_requests
Admin audit log for UPDATE/DELETE requests before execution.

- `operation_id` — PK
- `requested_by`, `operation_type`, `target_table`, `target_record_id`
- `requested_at`, `reason`, `approval_status`, `executed_at`
