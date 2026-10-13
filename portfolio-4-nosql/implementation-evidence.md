# NoSQL Implementation and Query Execution Evidence

## 1. MongoDB Implementation Script
To validate the model practically, the following shell commands were executed in MongoDB Compass / MongoDB Atlas:

```javascript
// Switch to university NoSQL database
use southern_tech_university_nosql;

// Insert Student Transcript Document
db.student_transcripts.insertOne({
  matric_no: "STU/2024/001",
  personal_info: { 
    first_name: "Denyefa", 
    last_name: "Wari",
    email: "denyefa.wari@southerntech.edu"
  },
  department: {
    dept_code: "CSC",
    dept_name: "Computer Science"
  },
  academic_records: [
    {
      academic_session: "2026/2027",
      semester: "First Semester",
      courses_enrolled: [
        { course_code: "CSC501", credits: 3, score: 88.5, grade: "A" }
      ],
      semester_gpa: 5.00
    }
  ],
  cumulative_cgpa: 5.00,
  status: "Active"
});

// Query Student Transcript by Matriculation Number with Indexing
db.student_transcripts.find({ matric_no: "STU/2024/001" });
