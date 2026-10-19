-- =====================================================================
-- MIT 8103 Advanced Database Systems - Portfolio 2
-- Query Processing and Optimisation
-- Case study: Luma Polytechnic (simulated) - database `lumapoly`
-- Target: MySQL 8.0.18+ (EXPLAIN ANALYZE needs 8.0.18; tested on 8.0.46)
--
-- HOW TO USE
--   1. Run Portfolio 1 first:  mysql -u root -p < relational-schema.sql
--      (seed_data.sql is NOT needed: PART 0 below regenerates all data)
--   2. Run this file top to bottom, or one PART at a time.
--      Total runtime is about 3 to 5 minutes on a small machine.
--   3. For each query, note the time the client prints, e.g. (3.54 sec),
--      and screenshot the EXPLAIN ANALYZE output for your evidence.
--      Run each timed query 3 to 5 times; ignore the first (cold cache).
--
-- NOTE: scores are generated with RAND(), so row counts are fixed but the
-- scores (and therefore some results, e.g. the number of at-risk students)
-- will differ slightly from run to run and from the reference run in
-- brief-performance-analysis.md. Timings depend on your machine.
--
-- PARTS
--   0  Generate realistic data at scale (about 1.7 million rows)
--   1  Baseline workload: queries Q1-Q10 on the Portfolio 1 indexes
--   2  Baseline execution plans (EXPLAIN ANALYZE)
--   3  Optimisation experiments (indexes, rewrites, summary table)
--   4  Regression check on the final index set
--   5  Reset to baseline (commented out; run it to repeat the experiments)
-- =====================================================================

USE lumapoly;

-- =====================================================================
-- PART 0: DATA GENERATION
-- Result: 8 departments, 16 programmes, 300 lecturers, 400 courses,
-- 7 terms, 2,800 offerings, 40,000 students, 960,000 registrations,
-- 784,000 scores (terms 1-6 are graded; term 7 is the current term).
-- =====================================================================

-- Start from a clean slate: every table is emptied and regenerated
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE grade_scale; TRUNCATE grades; TRUNCATE registrations; TRUNCATE course_offerings;
TRUNCATE students; TRUNCATE courses; TRUNCATE lecturers;
TRUNCATE programmes; TRUNCATE departments; TRUNCATE academic_terms;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO grade_scale (grade_letter,min_score,max_score,grade_point) VALUES
 ('A',75,100,4.00),('AB',70,74,3.50),('B',65,69,3.25),('BC',60,64,3.00),
 ('C',55,59,2.75),('CD',50,54,2.50),('D',45,49,2.25),('E',40,44,2.00),
 ('F',0,39,0.00);

SET SESSION cte_max_recursion_depth = 1000000;
SET SESSION unique_checks = 0;
SET SESSION foreign_key_checks = 0;

-- Helper numbers table 1..40000
DROP TABLE IF EXISTS nums;
CREATE TABLE nums (n INT UNSIGNED PRIMARY KEY) ENGINE=InnoDB;
INSERT INTO nums
WITH RECURSIVE s AS (SELECT 1 AS n UNION ALL SELECT n+1 FROM s WHERE n < 40000)
SELECT n FROM s;

-- 8 departments
INSERT INTO departments (code,name) VALUES
 ('CSC','Computer Science'),('EEE','Electrical/Electronic Engineering'),
 ('MEC','Mechanical Engineering'),('CVE','Civil Engineering'),
 ('ACC','Accountancy'),('BAM','Business Administration'),
 ('SLT','Science Laboratory Technology'),('MAC','Mass Communication');

-- 16 programmes (ND + HND per department)
INSERT INTO programmes (department_id,name,award,duration_years)
SELECT d.department_id, d.name, a.award, 2
FROM departments d JOIN (SELECT 'ND' AS award UNION ALL SELECT 'HND') a;

-- 300 lecturers
INSERT INTO lecturers (staff_no,full_name,email,department_id,academic_rank)
SELECT CONCAT('LP/ST/',LPAD(n,4,'0')), CONCAT('Lecturer ',LPAD(n,4,'0')),
       CONCAT('lecturer',n,'@lumapoly.example'), 1 + MOD(n,8),
       ELT(1 + MOD(n,6),'ASSISTANT_LECTURER','LECTURER_II','LECTURER_I',
                        'SENIOR_LECTURER','PRINCIPAL_LECTURER','CHIEF_LECTURER')
FROM nums WHERE n <= 300;

-- 400 courses
INSERT INTO courses (department_id,course_code,title,credit_units,course_level)
SELECT 1 + MOD(n,8), CONCAT('C',LPAD(n,4,'0')), CONCAT('Course ',LPAD(n,4,'0'),' Studies'),
       2 + MOD(n,3), ELT(1 + MOD(n,4),'ND1','ND2','HND1','HND2')
FROM nums WHERE n <= 400;

-- 7 terms: 2023/2024 .. 2026/2027 FIRST (current)
INSERT INTO academic_terms (session_label,semester,start_date,end_date,is_current) VALUES
 ('2023/2024','FIRST','2023-10-02','2024-02-09',FALSE),
 ('2023/2024','SECOND','2024-03-04','2024-07-12',FALSE),
 ('2024/2025','FIRST','2024-10-07','2025-02-14',FALSE),
 ('2024/2025','SECOND','2025-03-03','2025-07-11',FALSE),
 ('2025/2026','FIRST','2025-10-06','2026-02-13',FALSE),
 ('2025/2026','SECOND','2026-03-02','2026-07-10',FALSE),
 ('2026/2027','FIRST','2026-10-05','2027-02-12',TRUE);

-- 2,800 offerings: every course offered in every term (offering_id = (term-1)*400 + course)
INSERT INTO course_offerings (offering_id,course_id,term_id,lecturer_id,capacity)
SELECT (t.term_id-1)*400 + c.course_id, c.course_id, t.term_id,
       1 + MOD(c.course_id*7 + t.term_id, 300), 300 + MOD(c.course_id,5)*100
FROM courses c JOIN academic_terms t;

-- 40,000 students, four entry cohorts (2023-2026)
INSERT INTO students (matric_no,full_name,email,phone,date_of_birth,gender,programme_id,entry_year,status)
SELECT CONCAT('LP/',RIGHT(2023+MOD(n,4),2),'/',LPAD(n,6,'0')),
       CONCAT('Student ',LPAD(n,6,'0')),
       CONCAT('student',n,'@student.lumapoly.example'),
       CONCAT('080',LPAD(n,8,'0')),
       DATE_ADD('1999-01-01', INTERVAL MOD(n*37,2800) DAY),
       IF(MOD(n,2)=0,'M','F'),
       1 + MOD(n,16), 2023 + MOD(n,4),
       CASE WHEN MOD(n,33)=0 THEN 'WITHDRAWN'
            WHEN MOD(n,4)=0 THEN 'GRADUATED' ELSE 'ACTIVE' END
FROM nums;

-- Registrations: each student takes up to 4 terms from their entry term, 8 courses per term
INSERT INTO registrations (student_id,offering_id,registered_at,status)
SELECT s.student_id,
       (t.term_id-1)*400 + 1 + MOD(s.student_id*7919 + t.term_id*104729 + j.j*13, 400),
       DATE_ADD(t.start_date, INTERVAL MOD(s.student_id + j.j*3, 14) DAY),
       IF(MOD(s.student_id*31 + j.j*7 + t.term_id, 50)=0,'DROPPED','REGISTERED')
FROM students s
JOIN (SELECT 0 AS k UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) k
JOIN (SELECT 0 AS j UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
      UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7) j
JOIN academic_terms t ON t.term_id = (s.entry_year-2023)*2 + 1 + k.k AND t.term_id <= 7;

-- Scores for all completed terms (1-6); current term 7 has no scores yet
INSERT INTO grades (registration_id,ca_score,exam_score,entered_by)
SELECT r.registration_id,
       FLOOR(RAND(2026)*26) + 5,
       FLOOR(RAND()*40) + FLOOR(RAND()*31),
       o.lecturer_id
FROM registrations r
JOIN course_offerings o ON o.offering_id = r.offering_id
WHERE r.status = 'REGISTERED' AND o.term_id <= 6;

SET SESSION unique_checks = 1;
SET SESSION foreign_key_checks = 1;
DROP TABLE nums;

ANALYZE TABLE students, registrations, grades, course_offerings;


-- Sanity check: row counts
SELECT 'students' AS tbl, COUNT(*) AS row_count FROM students
UNION ALL SELECT 'registrations', COUNT(*) FROM registrations
UNION ALL SELECT 'grades', COUNT(*) FROM grades
UNION ALL SELECT 'course_offerings', COUNT(*) FROM course_offerings;

-- =====================================================================
-- PART 1: BASELINE WORKLOAD (only the indexes from Portfolio 1 exist)
-- =====================================================================

-- Q1: Student transcript (point lookup)
--   Business use: student portal, view own transcript.
--   Expected: fast; uq_students_matric gives a single-row lookup.
SELECT *
FROM v_transcript
WHERE matric_no = 'LP/24/021345'
ORDER BY session_label, semester, course_code;

-- Q2: Top 10 semester GPAs for 2025/2026 SECOND (min 15 units)
--   Business use: dean's list after results release.
--   Uses the v_semester_gpa view from Portfolio 1.
SELECT matric_no, full_name, units_taken, gpa
FROM v_semester_gpa
WHERE term_id = 6 AND units_taken >= 15
ORDER BY gpa DESC, units_taken DESC, matric_no
LIMIT 10;

-- Q3: Course performance report for 2025/2026 SECOND (10 lowest pass rates)
--   Business use: quality assurance, which courses have the weakest pass rates.
SELECT c.course_code, c.title,
       COUNT(*) AS enrolled,
       ROUND(AVG(g.total_score), 1) AS avg_score,
       ROUND(100 * AVG(g.total_score >= 40), 1) AS pass_pct
FROM course_offerings o
JOIN courses c       ON c.course_id = o.course_id
JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
JOIN grades g        ON g.registration_id = r.registration_id
WHERE o.term_id = 6
GROUP BY o.offering_id, c.course_code, c.title
ORDER BY pass_pct ASC, c.course_code
LIMIT 10;

-- Q4: Lecturer workload, current term (top 10)
--   Business use: workload planning for the current semester.
SELECT l.staff_no, l.full_name,
       COUNT(DISTINCT o.offering_id) AS courses,
       COUNT(r.registration_id)      AS students
FROM lecturers l
JOIN course_offerings o ON o.lecturer_id = l.lecturer_id AND o.term_id = 7
JOIN registrations r    ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
GROUP BY l.lecturer_id, l.staff_no, l.full_name
ORDER BY students DESC, l.staff_no
LIMIT 10;

-- Q5: Dropped registrations per day, first week of current term
--   Business use: registry monitors late course drops.
--   No index exists on registered_at or on status.
SELECT DATE(registered_at) AS reg_day, COUNT(*) AS drops
FROM registrations
WHERE status = 'DROPPED'
  AND registered_at >= '2026-10-05' AND registered_at < '2026-10-12'
GROUP BY DATE(registered_at)
ORDER BY reg_day;

-- Q6: Top 20 highest scores ever recorded (>= 90)
--   Business use: prizes and honours list.
--   No index exists on total_score.
SELECT s.matric_no, s.full_name, c.course_code, g.total_score
FROM grades g
JOIN registrations r    ON r.registration_id = g.registration_id
JOIN students s         ON s.student_id = r.student_id
JOIN course_offerings o ON o.offering_id = r.offering_id
JOIN courses c          ON c.course_id = o.course_id
WHERE g.total_score >= 90
ORDER BY g.total_score DESC, g.registration_id
LIMIT 20;

-- Q7: Pass count and average CA for passing scores (low selectivity filter)
--   Same column as Q6 but a filter that keeps about 76% of the rows.
SELECT COUNT(*) AS passes, ROUND(AVG(ca_score), 1) AS avg_ca
FROM grades
WHERE total_score >= 40;

-- Q8a: Best score per course, 2025/2026 SECOND: correlated subquery
--   Business use: best performer per course (ties kept) for department 1.
--   The subquery is re-evaluated for every outer row.
SELECT o.offering_id, r.student_id, g.total_score
FROM course_offerings o
JOIN courses c       ON c.course_id = o.course_id AND c.department_id = 1 AND c.course_id <= 160
JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
JOIN grades g        ON g.registration_id = r.registration_id
WHERE o.term_id = 6
  AND g.total_score = (SELECT MAX(g2.total_score)
                       FROM registrations r2
                       JOIN grades g2 ON g2.registration_id = r2.registration_id
                       WHERE r2.offering_id = o.offering_id AND r2.status = 'REGISTERED')
ORDER BY o.offering_id, r.student_id;

-- Q9: Students at academic risk: CGPA below 1.5
--   Business use: academic-risk report across ALL terms (reads every score).
SELECT COUNT(*) AS at_risk
FROM v_cgpa
WHERE cgpa < 1.5;

-- Q10: Optimiser row estimate for a filter on an un-indexed column
--   Used later to show how a histogram improves row estimates.
SELECT COUNT(*) AS high_exam
FROM grades
WHERE exam_score >= 65;


-- =====================================================================
-- PART 2: BASELINE EXECUTION PLANS
-- Screenshot or copy each output into execution-plans.md.
-- EXPLAIN ANALYZE actually runs the query and shows measured time and rows
-- next to the optimiser's estimate. Compare "cost/rows" with "actual".
-- =====================================================================

-- Q1 plan
EXPLAIN ANALYZE
SELECT *
FROM v_transcript
WHERE matric_no = 'LP/24/021345'
ORDER BY session_label, semester, course_code;

-- Q2 plan
EXPLAIN ANALYZE
SELECT matric_no, full_name, units_taken, gpa
FROM v_semester_gpa
WHERE term_id = 6 AND units_taken >= 15
ORDER BY gpa DESC, units_taken DESC, matric_no
LIMIT 10;

-- Q3 plan
EXPLAIN ANALYZE
SELECT c.course_code, c.title,
       COUNT(*) AS enrolled,
       ROUND(AVG(g.total_score), 1) AS avg_score,
       ROUND(100 * AVG(g.total_score >= 40), 1) AS pass_pct
FROM course_offerings o
JOIN courses c       ON c.course_id = o.course_id
JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
JOIN grades g        ON g.registration_id = r.registration_id
WHERE o.term_id = 6
GROUP BY o.offering_id, c.course_code, c.title
ORDER BY pass_pct ASC, c.course_code
LIMIT 10;

-- Q4 plan
EXPLAIN ANALYZE
SELECT l.staff_no, l.full_name,
       COUNT(DISTINCT o.offering_id) AS courses,
       COUNT(r.registration_id)      AS students
FROM lecturers l
JOIN course_offerings o ON o.lecturer_id = l.lecturer_id AND o.term_id = 7
JOIN registrations r    ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
GROUP BY l.lecturer_id, l.staff_no, l.full_name
ORDER BY students DESC, l.staff_no
LIMIT 10;

-- Q5 plan
EXPLAIN ANALYZE
SELECT DATE(registered_at) AS reg_day, COUNT(*) AS drops
FROM registrations
WHERE status = 'DROPPED'
  AND registered_at >= '2026-10-05' AND registered_at < '2026-10-12'
GROUP BY DATE(registered_at)
ORDER BY reg_day;

-- Q6 plan
EXPLAIN ANALYZE
SELECT s.matric_no, s.full_name, c.course_code, g.total_score
FROM grades g
JOIN registrations r    ON r.registration_id = g.registration_id
JOIN students s         ON s.student_id = r.student_id
JOIN course_offerings o ON o.offering_id = r.offering_id
JOIN courses c          ON c.course_id = o.course_id
WHERE g.total_score >= 90
ORDER BY g.total_score DESC, g.registration_id
LIMIT 20;

-- Q7 plan
EXPLAIN ANALYZE
SELECT COUNT(*) AS passes, ROUND(AVG(ca_score), 1) AS avg_ca
FROM grades
WHERE total_score >= 40;

-- Q8a plan
EXPLAIN ANALYZE
SELECT o.offering_id, r.student_id, g.total_score
FROM course_offerings o
JOIN courses c       ON c.course_id = o.course_id AND c.department_id = 1 AND c.course_id <= 160
JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
JOIN grades g        ON g.registration_id = r.registration_id
WHERE o.term_id = 6
  AND g.total_score = (SELECT MAX(g2.total_score)
                       FROM registrations r2
                       JOIN grades g2 ON g2.registration_id = r2.registration_id
                       WHERE r2.offering_id = o.offering_id AND r2.status = 'REGISTERED')
ORDER BY o.offering_id, r.student_id;

-- Q9 plan
EXPLAIN ANALYZE
SELECT COUNT(*) AS at_risk
FROM v_cgpa
WHERE cgpa < 1.5;

-- Q10 plan
EXPLAIN ANALYZE
SELECT COUNT(*) AS high_exam
FROM grades
WHERE exam_score >= 65;

-- Tabular plan for a quick look at access type, key and rows (Q5 and Q6)
EXPLAIN
SELECT DATE(registered_at) AS reg_day, COUNT(*) AS drops
FROM registrations
WHERE status = 'DROPPED'
  AND registered_at >= '2026-10-05' AND registered_at < '2026-10-12'
GROUP BY DATE(registered_at)
ORDER BY reg_day;
EXPLAIN
SELECT s.matric_no, s.full_name, c.course_code, g.total_score
FROM grades g
JOIN registrations r    ON r.registration_id = g.registration_id
JOIN students s         ON s.student_id = r.student_id
JOIN course_offerings o ON o.offering_id = r.offering_id
JOIN courses c          ON c.course_id = o.course_id
WHERE g.total_score >= 90
ORDER BY g.total_score DESC, g.registration_id
LIMIT 20;


-- =====================================================================
-- PART 3: OPTIMISATION EXPERIMENTS
-- Each experiment states the problem, the change, and what to compare.
-- Part 3 is NOT re-runnable on its own: run Part 5 first to repeat it.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 3.1  Q2 (3.5 s): three-step optimisation
--      Plan finding: 156,800 rows were joined to students before the
--      top 10 were chosen, and grade_scale was a range join re-planned
--      for every row.
--      Step 1: aggregate first, join students last (late join).
--      Step 2: replace the range join with an equality join on a small
--              lookup table (one row per possible score 0..100).
--      Step 3: covering index so registrations is not read from the table.
-- ---------------------------------------------------------------------
-- Q2b: Q2 rewrite 1: aggregate first, join students last
SELECT s.matric_no, s.full_name, t.units_taken, t.gpa
FROM (SELECT r.student_id,
             SUM(c.credit_units) AS units_taken,
             ROUND(SUM(c.credit_units * gs.grade_point) / SUM(c.credit_units), 2) AS gpa
      FROM course_offerings o
      JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
      JOIN grades g        ON g.registration_id = r.registration_id
      JOIN courses c       ON c.course_id = o.course_id
      JOIN grade_scale gs  ON g.total_score BETWEEN gs.min_score AND gs.max_score
      WHERE o.term_id = 6
      GROUP BY r.student_id
      HAVING units_taken >= 15) t
JOIN students s ON s.student_id = t.student_id
ORDER BY t.gpa DESC, t.units_taken DESC, s.matric_no
LIMIT 10;

CREATE TABLE grade_lookup (
  score        TINYINT UNSIGNED PRIMARY KEY,   -- every possible total score 0..100
  grade_letter VARCHAR(2)   NOT NULL,
  grade_point  DECIMAL(3,2) NOT NULL
) ENGINE=InnoDB;
INSERT INTO grade_lookup (score, grade_letter, grade_point)
WITH RECURSIVE s AS (SELECT 0 AS score UNION ALL SELECT score + 1 FROM s WHERE score < 100)
SELECT s.score, gs.grade_letter, gs.grade_point
FROM s JOIN grade_scale gs ON s.score BETWEEN gs.min_score AND gs.max_score;
SELECT COUNT(*) AS lookup_rows FROM grade_lookup;   -- expect 101

-- Q2c: Q2 rewrite 2: equality join to grade_lookup instead of range join
SELECT s.matric_no, s.full_name, t.units_taken, t.gpa
FROM (SELECT r.student_id,
             SUM(c.credit_units) AS units_taken,
             ROUND(SUM(c.credit_units * gs.grade_point) / SUM(c.credit_units), 2) AS gpa
      FROM course_offerings o
      JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
      JOIN grades g        ON g.registration_id = r.registration_id
      JOIN courses c       ON c.course_id = o.course_id
      JOIN grade_lookup gs ON gs.score = g.total_score
      WHERE o.term_id = 6
      GROUP BY r.student_id
      HAVING units_taken >= 15) t
JOIN students s ON s.student_id = t.student_id
ORDER BY t.gpa DESC, t.units_taken DESC, s.matric_no
LIMIT 10;

CREATE INDEX idx_reg_cover ON registrations (offering_id, status, student_id);
ANALYZE TABLE registrations;

-- Q2d: Q2 rewrite 2 + covering index idx_reg_cover
--   Result must be identical to Q2 (same 10 rows).
SELECT s.matric_no, s.full_name, t.units_taken, t.gpa
FROM (SELECT r.student_id,
             SUM(c.credit_units) AS units_taken,
             ROUND(SUM(c.credit_units * gs.grade_point) / SUM(c.credit_units), 2) AS gpa
      FROM course_offerings o
      JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
      JOIN grades g        ON g.registration_id = r.registration_id
      JOIN courses c       ON c.course_id = o.course_id
      JOIN grade_lookup gs ON gs.score = g.total_score
      WHERE o.term_id = 6
      GROUP BY r.student_id
      HAVING units_taken >= 15) t
JOIN students s ON s.student_id = t.student_id
ORDER BY t.gpa DESC, t.units_taken DESC, s.matric_no
LIMIT 10;

EXPLAIN ANALYZE
SELECT s.matric_no, s.full_name, t.units_taken, t.gpa
FROM (SELECT r.student_id,
             SUM(c.credit_units) AS units_taken,
             ROUND(SUM(c.credit_units * gs.grade_point) / SUM(c.credit_units), 2) AS gpa
      FROM course_offerings o
      JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
      JOIN grades g        ON g.registration_id = r.registration_id
      JOIN courses c       ON c.course_id = o.course_id
      JOIN grade_lookup gs ON gs.score = g.total_score
      WHERE o.term_id = 6
      GROUP BY r.student_id
      HAVING units_taken >= 15) t
JOIN students s ON s.student_id = t.student_id
ORDER BY t.gpa DESC, t.units_taken DESC, s.matric_no
LIMIT 10;

-- ---------------------------------------------------------------------
-- 3.2  Q3: invisible-index test (is idx_reg_offering_status still needed?)
--      An invisible index is maintained but ignored by the optimiser, so
--      it is the safe way to test a drop. Alternate the two states and
--      compare several runs each; small differences are noise.
-- ---------------------------------------------------------------------
ALTER TABLE registrations ALTER INDEX idx_reg_offering_status INVISIBLE;

SELECT c.course_code, c.title,
       COUNT(*) AS enrolled,
       ROUND(AVG(g.total_score), 1) AS avg_score,
       ROUND(100 * AVG(g.total_score >= 40), 1) AS pass_pct
FROM course_offerings o
JOIN courses c       ON c.course_id = o.course_id
JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
JOIN grades g        ON g.registration_id = r.registration_id
WHERE o.term_id = 6
GROUP BY o.offering_id, c.course_code, c.title
ORDER BY pass_pct ASC, c.course_code
LIMIT 10;   -- run 3-5 times, note the time

ALTER TABLE registrations ALTER INDEX idx_reg_offering_status VISIBLE;
SELECT c.course_code, c.title,
       COUNT(*) AS enrolled,
       ROUND(AVG(g.total_score), 1) AS avg_score,
       ROUND(100 * AVG(g.total_score >= 40), 1) AS pass_pct
FROM course_offerings o
JOIN courses c       ON c.course_id = o.course_id
JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
JOIN grades g        ON g.registration_id = r.registration_id
WHERE o.term_id = 6
GROUP BY o.offering_id, c.course_code, c.title
ORDER BY pass_pct ASC, c.course_code
LIMIT 10;   -- run 3-5 times, note the time

-- ---------------------------------------------------------------------
-- 3.3  Q5: composite index column order
--      Three candidates; USE INDEX forces each so they can be compared.
--      Rule: equality column first, range column second.
-- ---------------------------------------------------------------------
CREATE INDEX idx_reg_date        ON registrations (registered_at);
CREATE INDEX idx_reg_date_status ON registrations (registered_at, status);
CREATE INDEX idx_reg_status_date ON registrations (status, registered_at);
ANALYZE TABLE registrations;

-- Q5a: Q5 with single-column index idx_reg_date (registered_at)
SELECT DATE(registered_at) AS reg_day, COUNT(*) AS drops
FROM registrations USE INDEX (idx_reg_date)
WHERE status = 'DROPPED'
  AND registered_at >= '2026-10-05' AND registered_at < '2026-10-12'
GROUP BY DATE(registered_at)
ORDER BY reg_day;

-- Q5c: Q5 with reversed composite idx_reg_date_status (registered_at, status)
SELECT DATE(registered_at) AS reg_day, COUNT(*) AS drops
FROM registrations USE INDEX (idx_reg_date_status)
WHERE status = 'DROPPED'
  AND registered_at >= '2026-10-05' AND registered_at < '2026-10-12'
GROUP BY DATE(registered_at)
ORDER BY reg_day;

-- Q5b: Q5 with composite idx_reg_status_date (status, registered_at)
SELECT DATE(registered_at) AS reg_day, COUNT(*) AS drops
FROM registrations USE INDEX (idx_reg_status_date)
WHERE status = 'DROPPED'
  AND registered_at >= '2026-10-05' AND registered_at < '2026-10-12'
GROUP BY DATE(registered_at)
ORDER BY reg_day;

-- Q5: Dropped registrations per day, first week of current term
--   Optimiser's own choice with all three present.
SELECT DATE(registered_at) AS reg_day, COUNT(*) AS drops
FROM registrations
WHERE status = 'DROPPED'
  AND registered_at >= '2026-10-05' AND registered_at < '2026-10-12'
GROUP BY DATE(registered_at)
ORDER BY reg_day;

EXPLAIN ANALYZE
SELECT DATE(registered_at) AS reg_day, COUNT(*) AS drops
FROM registrations USE INDEX (idx_reg_status_date)
WHERE status = 'DROPPED'
  AND registered_at >= '2026-10-05' AND registered_at < '2026-10-12'
GROUP BY DATE(registered_at)
ORDER BY reg_day;

-- Keep only the winner; the other two add write cost for no benefit.
DROP INDEX idx_reg_date        ON registrations;
DROP INDEX idx_reg_date_status ON registrations;
ANALYZE TABLE registrations;

-- ---------------------------------------------------------------------
-- 3.4  Q6: index on the generated column total_score (highly selective:
--      about 0.7% of rows are >= 90)
-- ---------------------------------------------------------------------
CREATE INDEX idx_grades_total ON grades (total_score);
ANALYZE TABLE grades;

-- Q6: Top 20 highest scores ever recorded (>= 90)
SELECT s.matric_no, s.full_name, c.course_code, g.total_score
FROM grades g
JOIN registrations r    ON r.registration_id = g.registration_id
JOIN students s         ON s.student_id = r.student_id
JOIN course_offerings o ON o.offering_id = r.offering_id
JOIN courses c          ON c.course_id = o.course_id
WHERE g.total_score >= 90
ORDER BY g.total_score DESC, g.registration_id
LIMIT 20;

EXPLAIN ANALYZE
SELECT s.matric_no, s.full_name, c.course_code, g.total_score
FROM grades g
JOIN registrations r    ON r.registration_id = g.registration_id
JOIN students s         ON s.student_id = r.student_id
JOIN course_offerings o ON o.offering_id = r.offering_id
JOIN courses c          ON c.course_id = o.course_id
WHERE g.total_score >= 90
ORDER BY g.total_score DESC, g.registration_id
LIMIT 20;

-- ---------------------------------------------------------------------
-- 3.5  Q7: an index the optimiser rightly ignores (76% of rows match)
--      Compare the plan (type ALL) with the forced-index version.
-- ---------------------------------------------------------------------
-- Q7: Pass count and average CA for passing scores (low selectivity filter)
--   idx_grades_total now exists, but the plan should still say type ALL.
SELECT COUNT(*) AS passes, ROUND(AVG(ca_score), 1) AS avg_ca
FROM grades
WHERE total_score >= 40;

EXPLAIN ANALYZE
SELECT COUNT(*) AS passes, ROUND(AVG(ca_score), 1) AS avg_ca
FROM grades
WHERE total_score >= 40;

-- Q7f: Q7 with FORCE INDEX (proof the optimiser was right to ignore it)
--   Forcing the index makes the query slower.
SELECT COUNT(*) AS passes, ROUND(AVG(ca_score), 1) AS avg_ca
FROM grades FORCE INDEX (idx_grades_total)
WHERE total_score >= 40;

EXPLAIN ANALYZE
SELECT COUNT(*) AS passes, ROUND(AVG(ca_score), 1) AS avg_ca
FROM grades FORCE INDEX (idx_grades_total)
WHERE total_score >= 40;

-- ---------------------------------------------------------------------
-- 3.6  Q8: rewrite a correlated subquery
--      Q8a (Part 1) re-ran the subquery for every outer row.
--      Q8b: window function.  Q8c: join to a grouped derived table.
--      All three return the same 21 rows. Compare the times.
-- ---------------------------------------------------------------------
-- Q8b: Q8 rewrite: window function RANK()
SELECT offering_id, student_id, total_score
FROM (SELECT o.offering_id, r.student_id, g.total_score,
             RANK() OVER (PARTITION BY o.offering_id ORDER BY g.total_score DESC) AS rk
      FROM course_offerings o
JOIN courses c       ON c.course_id = o.course_id AND c.department_id = 1 AND c.course_id <= 160
JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
JOIN grades g        ON g.registration_id = r.registration_id
      WHERE o.term_id = 6) ranked
WHERE rk = 1
ORDER BY offering_id, student_id;

EXPLAIN ANALYZE
SELECT offering_id, student_id, total_score
FROM (SELECT o.offering_id, r.student_id, g.total_score,
             RANK() OVER (PARTITION BY o.offering_id ORDER BY g.total_score DESC) AS rk
      FROM course_offerings o
JOIN courses c       ON c.course_id = o.course_id AND c.department_id = 1 AND c.course_id <= 160
JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
JOIN grades g        ON g.registration_id = r.registration_id
      WHERE o.term_id = 6) ranked
WHERE rk = 1
ORDER BY offering_id, student_id;

-- Q8c: Q8 rewrite: join to a grouped derived table
SELECT o.offering_id, r.student_id, g.total_score
FROM course_offerings o
JOIN courses c       ON c.course_id = o.course_id AND c.department_id = 1 AND c.course_id <= 160
JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
JOIN grades g        ON g.registration_id = r.registration_id
JOIN (SELECT r3.offering_id, MAX(g3.total_score) AS best
      FROM registrations r3
      JOIN grades g3 ON g3.registration_id = r3.registration_id
      WHERE r3.status = 'REGISTERED'
      GROUP BY r3.offering_id) m ON m.offering_id = o.offering_id AND m.best = g.total_score
WHERE o.term_id = 6
ORDER BY o.offering_id, r.student_id;

-- ---------------------------------------------------------------------
-- 3.7  Q9: a full-history report cannot be indexed away
--      Step 1: equality lookup join (Q9b).
--      Step 2: a plan regression to be aware of: idx_reg_status_date (built
--              for Q5) may now be chosen for status = 'REGISTERED', which
--              matches 98% of rows. Compare Q9b with Q9bi (IGNORE INDEX).
--      Step 3: pre-compute CGPA into a summary table (Q9c). Trade-off: the
--              summary is only as fresh as its last refresh.
-- ---------------------------------------------------------------------
-- Q9b: Q9 rewrite: equality join to grade_lookup
SELECT COUNT(*) AS at_risk
FROM (SELECT r.student_id,
             ROUND(SUM(c.credit_units * gl.grade_point) / SUM(c.credit_units), 2) AS cgpa
      FROM grades g
      JOIN registrations r    ON r.registration_id = g.registration_id AND r.status = 'REGISTERED'
      JOIN course_offerings o ON o.offering_id = r.offering_id
      JOIN courses c          ON c.course_id = o.course_id
      JOIN grade_lookup gl    ON gl.score = g.total_score
      GROUP BY r.student_id) x
WHERE cgpa < 1.5;

-- Q9bi: Q9 rewrite with IGNORE INDEX (idx_reg_status_date) to avoid the regression
SELECT COUNT(*) AS at_risk
FROM (SELECT r.student_id,
             ROUND(SUM(c.credit_units * gl.grade_point) / SUM(c.credit_units), 2) AS cgpa
      FROM grades g
      JOIN registrations r IGNORE INDEX (idx_reg_status_date) ON r.registration_id = g.registration_id AND r.status = 'REGISTERED'
      JOIN course_offerings o ON o.offering_id = r.offering_id
      JOIN courses c          ON c.course_id = o.course_id
      JOIN grade_lookup gl    ON gl.score = g.total_score
      GROUP BY r.student_id) x
WHERE cgpa < 1.5;

-- Summary table: build once, refresh after results are published.
CREATE TABLE student_cgpa_summary (
  student_id   INT UNSIGNED PRIMARY KEY,
  total_units  INT UNSIGNED  NOT NULL,
  cgpa         DECIMAL(4,2)  NOT NULL,
  refreshed_at TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_summary_cgpa (cgpa)
) ENGINE=InnoDB;
INSERT INTO student_cgpa_summary (student_id, total_units, cgpa)
SELECT r.student_id, SUM(c.credit_units),
       ROUND(SUM(c.credit_units * gl.grade_point) / SUM(c.credit_units), 2)
FROM grades g
JOIN registrations r IGNORE INDEX (idx_reg_status_date) ON r.registration_id = g.registration_id AND r.status = 'REGISTERED'
JOIN course_offerings o ON o.offering_id = r.offering_id
JOIN courses c          ON c.course_id = o.course_id
JOIN grade_lookup gl    ON gl.score = g.total_score
GROUP BY r.student_id;
ANALYZE TABLE student_cgpa_summary;

-- Q9c: Q9 rewrite: read the pre-computed summary table
--   Must return the same count as Q9.
SELECT COUNT(*) AS at_risk
FROM student_cgpa_summary
WHERE cgpa < 1.5;

EXPLAIN ANALYZE
SELECT COUNT(*) AS at_risk
FROM student_cgpa_summary
WHERE cgpa < 1.5;

-- ---------------------------------------------------------------------
-- 3.8  Q10: histogram statistics for an un-indexed column
--      Compare the optimiser's estimated rows before and after.
-- ---------------------------------------------------------------------
ANALYZE TABLE grades UPDATE HISTOGRAM ON exam_score WITH 64 BUCKETS;

EXPLAIN ANALYZE
SELECT COUNT(*) AS high_exam
FROM grades
WHERE exam_score >= 65;

SELECT schema_name, table_name, column_name,
       JSON_EXTRACT(histogram,'$."number-of-buckets-specified"') AS buckets
FROM information_schema.COLUMN_STATISTICS WHERE table_name = 'grades';

-- ---------------------------------------------------------------------
-- 3.9  Cost of indexes: write overhead and size
--      Run the UPDATE inside a transaction and roll it back. Repeat with
--      and without idx_reg_status_date (DROP / CREATE it between runs).
-- ---------------------------------------------------------------------
START TRANSACTION;

UPDATE registrations
SET registered_at = registered_at + INTERVAL 1 SECOND
WHERE registration_id BETWEEN 1 AND 50000;   -- note the time, then:
ROLLBACK;


-- Index inventory and on-disk size (MB)
SHOW INDEX FROM registrations;
SHOW INDEX FROM grades;
SELECT table_name, index_name, ROUND(stat_value * @@innodb_page_size / 1048576, 1) AS size_mb
FROM mysql.innodb_index_stats
WHERE database_name = 'lumapoly' AND stat_name = 'size'
  AND table_name IN ('registrations','grades','grade_lookup','student_cgpa_summary')
ORDER BY table_name, index_name;

-- =====================================================================
-- PART 4: REGRESSION CHECK
-- Re-run Q1, Q3, Q4, Q5, Q6, Q7 and Q2d (Part 3.1) on the final index
-- set. Every result must be unchanged and no query should be slower than
-- its baseline by more than normal run-to-run variation.
-- =====================================================================

SELECT *
FROM v_transcript
WHERE matric_no = 'LP/24/021345'
ORDER BY session_label, semester, course_code;

SELECT c.course_code, c.title,
       COUNT(*) AS enrolled,
       ROUND(AVG(g.total_score), 1) AS avg_score,
       ROUND(100 * AVG(g.total_score >= 40), 1) AS pass_pct
FROM course_offerings o
JOIN courses c       ON c.course_id = o.course_id
JOIN registrations r ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
JOIN grades g        ON g.registration_id = r.registration_id
WHERE o.term_id = 6
GROUP BY o.offering_id, c.course_code, c.title
ORDER BY pass_pct ASC, c.course_code
LIMIT 10;

SELECT l.staff_no, l.full_name,
       COUNT(DISTINCT o.offering_id) AS courses,
       COUNT(r.registration_id)      AS students
FROM lecturers l
JOIN course_offerings o ON o.lecturer_id = l.lecturer_id AND o.term_id = 7
JOIN registrations r    ON r.offering_id = o.offering_id AND r.status = 'REGISTERED'
GROUP BY l.lecturer_id, l.staff_no, l.full_name
ORDER BY students DESC, l.staff_no
LIMIT 10;

SELECT DATE(registered_at) AS reg_day, COUNT(*) AS drops
FROM registrations
WHERE status = 'DROPPED'
  AND registered_at >= '2026-10-05' AND registered_at < '2026-10-12'
GROUP BY DATE(registered_at)
ORDER BY reg_day;

SELECT s.matric_no, s.full_name, c.course_code, g.total_score
FROM grades g
JOIN registrations r    ON r.registration_id = g.registration_id
JOIN students s         ON s.student_id = r.student_id
JOIN course_offerings o ON o.offering_id = r.offering_id
JOIN courses c          ON c.course_id = o.course_id
WHERE g.total_score >= 90
ORDER BY g.total_score DESC, g.registration_id
LIMIT 20;

SELECT COUNT(*) AS passes, ROUND(AVG(ca_score), 1) AS avg_ca
FROM grades
WHERE total_score >= 40;


-- =====================================================================
-- PART 5: RESET TO BASELINE (uncomment to repeat the experiments)
-- =====================================================================
-- DROP TABLE IF EXISTS grade_lookup;
-- DROP TABLE IF EXISTS student_cgpa_summary;
-- DROP INDEX idx_reg_cover       ON registrations;
-- DROP INDEX idx_reg_status_date ON registrations;
-- DROP INDEX idx_grades_total    ON grades;
-- ANALYZE TABLE grades DROP HISTOGRAM ON exam_score;
-- ANALYZE TABLE registrations, grades;
