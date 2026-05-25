# Part 1 — Relational Design, Keys & Normalization

## Dataset
CodeJudge — an online coding-practice and evaluation platform used by a CS department.

## Repository Contents

| File | Purpose |
|---|---|
| `schema_explanation.md` | Raw data understanding — what each table/column means |
| `keys_and_relationships.md` | Primary, foreign, candidate, alternate, composite keys per table |
| `normalization_notes.md` | Redundancy analysis, FDs, 1NF/2NF/3NF reasoning |
| `schema.sql` | DDL to create the cleaned relational schema |
| `erd.md` | Text-based ERD showing all tables, PKs, FKs, and relationships |
| `assumptions.md` | Design decisions and assumptions made |

## How to Run

```bash
sqlite3 codejudge.db < schema.sql
```
