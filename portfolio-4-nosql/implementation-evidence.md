# NoSQL Implementation & Shell Execution Evidence

## 1. MongoDB Shell Implementation
To demonstrate practical implementation, the student transcript document was inserted and queried in a MongoDB environment:

```javascript
// Connect to database
use southern_tech_university_nosql;

// Insert Student Document
db.student_transcripts.insertOne({
  matric_no: "STU/2024/001",
  personal_info: { first_name: "Denyefa", last_name: "Wari" },
  department: "Computer Science",
  cumulative_cgpa: 4.85,
  status: "Active"
});

// Query Student Transcript by Matriculation Number
db.student_transcripts.find({ matric_no: "STU/2024/001" }).pretty();
