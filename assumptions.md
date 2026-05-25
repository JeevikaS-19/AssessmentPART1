# Assumptions — CodeJudge

**Surrogate keys everywhere** — used integer surrogate PKs instead of natural keys like `roll_number` or `email` since those can change; surrogate keys make stable FK references.

**contest_id is nullable in submissions** — a student can submit to a problem outside a contest (open practice). NULL FK = no contest.

**difficulty values** — assumed to be exactly `Easy`, `Medium`, `Hard` based on standard judge platform conventions.

**submission status values** — `Accepted`, `Wrong Answer`, `TLE`, `MLE`, `CE`, `RE`, `Pending`. These are the standard online judge verdicts.

**session_type values** — `lecture`, `tutorial`, `lab` based on a typical CS department setup.

**raw_student_import has no FK constraints** — intentional. It's a staging table. Records might reference batch codes not yet in `batches`. Validation happens when importing into `students`.

**operation_requests has no target FK** — `target_record_id` is TEXT because it can reference records from any table. A generic FK isn't possible in relational design; the application handles that.

**student_id kept in regrade_requests** — technically redundant (derivable via submissions), but kept so the requester is still known even if the submission is deleted.

**is_active and is_hidden as INTEGER** — SQLite has no native BOOLEAN. Using `INTEGER` with `CHECK (col IN (0, 1))` is the standard workaround.

**DATE/DATETIME columns** — SQLite stores these as TEXT internally. The types in the DDL are for documentation clarity; application code handles formatting.

**final_grade is nullable** — course may still be in progress when a student is enrolled.

**resolved_at is nullable** — a pending regrade request has no resolution date yet.
