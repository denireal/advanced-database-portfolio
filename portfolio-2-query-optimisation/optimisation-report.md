###  `optimisation-report.md`
Save this performance tuning and indexing report inside your `portfolio-2-query-optimisation/` folder:

```markdown
# Database Indexing and Performance Optimisation Report

##  Index Inspection
To inspect existing indexes on critical relational tables, the following inspection command was executed:
```sql
SHOW INDEX FROM Enrollment;
SHOW INDEX FROM Student;
