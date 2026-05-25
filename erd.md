# ERD — CodeJudge

Tables and how they connect:

**batches** → students (one batch, many students)

**courses** connects to:
- enrollments (students enroll in courses)
- problems (problems belong to a course)
- contests (contests run per course)
- sessions (lectures/labs per course)

**students** connects to:
- enrollments
- submissions
- attendance
- regrade_requests

**problems** → test_cases (each problem has multiple test cases)

**contests ↔ problems** — many-to-many, resolved via **contest_problems**

**submissions** connects to:
- test_results (one result per test case per submission)
- regrade_requests
- plagiarism_flags (both submission_id and matched_submission_id point here)

`contest_id` in submissions is nullable — a student can submit outside a contest (open practice).

**sessions** → attendance (tracks per-student per-session)

**raw_student_import** — staging table, no FK constraints  
**operation_requests** — admin audit log, no FK constraints

---

## Relationships

| From | To | Type | Via |
|---|---|---|---|
| batches | students | 1:M | students.batch_id |
| students | enrollments | 1:M | enrollments.student_id |
| courses | enrollments | 1:M | enrollments.course_id |
| courses | problems | 1:M | problems.course_id |
| problems | test_cases | 1:M | test_cases.problem_id |
| courses | contests | 1:M | contests.course_id |
| contests | contest_problems | 1:M | contest_problems.contest_id |
| problems | contest_problems | 1:M | contest_problems.problem_id |
| students | submissions | 1:M | submissions.student_id |
| problems | submissions | 1:M | submissions.problem_id |
| contests | submissions | 1:M | submissions.contest_id |
| submissions | test_results | 1:M | test_results.submission_id |
| test_cases | test_results | 1:M | test_results.test_case_id |
| courses | sessions | 1:M | sessions.course_id |
| sessions | attendance | 1:M | attendance.session_id |
| students | attendance | 1:M | attendance.student_id |
| submissions | regrade_requests | 1:M | regrade_requests.submission_id |
| submissions | plagiarism_flags | 1:M | both FK columns in plagiarism_flags |
