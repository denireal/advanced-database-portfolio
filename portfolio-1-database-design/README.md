# Portfolio 1: Database Design and Modelling

**Course:** MIT 8103 Advanced Database Systems (2026/2027, First Semester)
**Case study:** Student Academic Management and Result Processing System (see [`case-study-description.md`](case-study-description.md))
**Database:** `sarms_db` on MySQL 8.0+ or MariaDB 10.4+ (InnoDB), run through WAMP / phpMyAdmin

## Contents

| File | Purpose |
|---|---|
| [`case-study-description.md`](case-study-description.md) | Organisation, users, data, operations, assumptions |
| `ER_Diagram.png` | ER diagram image (all 13 tables, keys, data types, crow's-foot relationships) |
| [`relational-schema.md`](relational-schema.md) | Relations, keys, foreign key map, ER-to-relational mapping |
| [`keys-and-constraints.md`](keys-and-constraints.md) | PK / UNIQUE / FK / CHECK / ENUM / generated columns, deferred rules |
| [`normalisation.md`](normalisation.md) | UNF -> 1NF -> 2NF -> 3NF -> BCNF walkthrough and design decisions |
| `Portfolio_1.pdf` | Your own write-up for the LMS |
| `evidence/` | Your screenshots and saved script output |
| [`../database/01_create_database.sql`](../database/01_create_database.sql) | Creates `sarms_db` (does not drop anything) |
| [`../database/02_create_tables.sql`](../database/02_create_tables.sql) | 13 tables, constraints, indexes |
| [`../database/03_insert_sample_data.sql`](../database/03_insert_sample_data.sql) | Small fictional seed dataset |
| [`../database/04_verification_queries.sql`](../database/04_verification_queries.sql) | Tests proving each constraint is enforced |

## Before you run anything: protect your existing `sarms_db`

You already have a `sarms_db` with Portfolio 2 evidence. `02_create_tables.sql` will **fail safely** (it will not overwrite) if the tables exist, and `01_create_database.sql` contains a commented-out `DROP DATABASE`, which you should leave commented unless you want to delete everything.

To try the new design without risk, test it first in a scratch database: change `sarms_db` to `sarms_db_v2` in the `CREATE DATABASE` and `USE` lines of scripts 01-04, run them, and compare. Then decide whether to migrate your real database. I could not see your current table definitions, so compare `SHOW CREATE TABLE` output with the new script first.

## How to run (WAMP)

**Command line** (use the `mysql.exe` from your WAMP MySQL or MariaDB `bin` folder):

```bash
mysql -u root -p < database/01_create_database.sql
mysql -u root -p < database/02_create_tables.sql
mysql -u root -p < database/03_insert_sample_data.sql
mysql --force --table -u root -p < database/04_verification_queries.sql > portfolio-1-database-design/evidence/verification_output.txt 2>&1
```

`--force` lets the verification script continue after its *intentional* errors. Each test is labelled `EXPECT ERROR` or `EXPECT SUCCESS`.

**phpMyAdmin:** the Import tab works for scripts 01-03. Script 04 stops at the first error, so open the SQL tab and run the tests **one at a time**, taking a screenshot of each result.

## Evidence checklist (take these yourself)

- [ ] `SHOW TABLES;` showing all 13 tables
- [ ] `SHOW CREATE TABLE results\G` (generated columns and CHECKs)
- [ ] `SHOW CREATE TABLE users\G` (role-link CHECK)
- [ ] Output of each verification test (the failing statements and the final transcript join)
- [ ] `ER_Diagram.png` committed in this folder (check it against your own `SHOW TABLES` / `SHOW CREATE TABLE` output)
- [ ] `git log --oneline` showing several commits over time

## Testing note

The scripts were built from scratch and run on **MariaDB 10.11** in a sandbox, and all verification tests behaved as expected. I did **not** have MySQL 8 available, so run them on your own WAMP server and check the results match. CHECK failures report error 3819 on MySQL and 4025 on MariaDB.

## Technical reflection (write this yourself)

The brief awards marks for individual understanding, so write this in your own words, 150-250 words. Prompts to cover:

1. Which design choice are you most and least sure about, and why? (e.g. surrogate keys, ENUM vs lookup tables, generated columns for grades)
2. What was the hardest part of normalising the result sheet, and what did you change as a result?
3. What did the constraint tests teach you that the ER diagram alone did not? (e.g. the CHECK / CASCADE conflict on `users`)
4. What would you change if the polytechnic had 50,000 students? (This leads into Portfolios 2 and 5.)
