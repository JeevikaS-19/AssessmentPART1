# Normalization Notes — CodeJudge

## Redundancy in Raw Data

**batch_code in raw_student_import**
`raw_student_import` stores `batch_code` as a plain string instead of a FK. Once records are validated and moved to `students`, the batch code gets resolved to `batch_id`. The staging table is temporary, so this is acceptable.

**course_id appearing in multiple tables**
`problems`, `contests`, and `sessions` all have `course_id` — this is correct normalization, not redundancy. Course metadata stays in `courses`; other tables just reference it.

**student_id in regrade_requests**
Technically derivable via `regrade_requests → submissions`, but kept here on purpose so that if a submission gets deleted, the requester is still identifiable.

---

## Why Tables Were Separated

**batches vs students**
Without `batches`, program name, dates, and status would repeat for every student row. The `batches` table stores it once and `students` references it via FK — this is what 3NF requires.

**test_cases vs problems**
Keeping test cases inline in `problems` would mean modifying the problem row every time a test case changes. Separating them lets each problem have multiple test cases independently, and `test_results` can score per test case.

---

## Functional Dependencies

**students**
`student_id → roll_number, full_name, email, batch_id, admission_date, enrollment_status, graduation_year`
All attributes depend on the PK. Batch attributes (program, dates) depend on `batch_id` and live in `batches` — so no transitive dependency here. ✓ 3NF

**enrollments**
`(student_id, course_id) → enrolled_on, enrollment_status, final_grade`
All non-key attributes depend on the full composite pair, not on either column alone. ✓ 2NF and 3NF

---

## Normal Forms

**1NF** — All columns are atomic, no repeating groups. ✓

**2NF** — Single-column PKs are automatically in 2NF. Tables with composite PKs (`enrollments`, `contest_problems`, `attendance`, `test_results`) — all non-key attributes depend on the full key. ✓

**3NF** — No transitive dependencies in any table. Batch/course/student metadata is separated into their own tables; nothing in a child table depends on a non-key attribute. ✓

---

## Trade-offs

| Decision | Why |
|---|---|
| Keeping `student_id` in `regrade_requests` | Audit integrity if submission is deleted |
| Surrogate `enrollment_id` instead of composite PK | Easier for FK references; uniqueness enforced via UNIQUE constraint |
| `contest_id` nullable in `submissions` | Allows open-practice submissions |
| `raw_student_import` not fully normalized | It's a staging table — doesn't need to be |
