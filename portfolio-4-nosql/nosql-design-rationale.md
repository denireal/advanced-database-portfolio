# NoSQL Document Model Design: Southern Technical University Academic Portal

## 1. Case Study Context & Objective
In Portfolio 1, we implemented a normalized relational database (3NF) for Southern Technical University, handling core entities like `Student`, `Department`, `Course`, and `Enrollment`. However, high-velocity operations such as **real-time student portal dashboard loading**, **historical transcript rendering**, and **notification audit logging** introduce performance bottlenecks when relying solely on multi-table `JOIN` operations.

To solve this, Portfolio 4 introduces a **document-oriented NoSQL model (MongoDB)**. Instead of fragmenting a student's records across four separate relational tables, a student's complete demographic data, departmental info, and multi-semester academic logs are denormalized into a single, cohesive document.

## 2. Document Schema Structure (`student-transcript.json`)
```json
{
  "_id": {
    "$oid": "650c1f2e1a2b3c4d5e6f7a8b"
  },
  "matric_no": "STU/2024/001",
  "personal_info": {
    "first_name": "Denyefa",
    "last_name": "Wari",
    "email": "denyefa.wari@southerntech.edu",
    "admission_year": 2024
  },
  "department": {
    "dept_code": "CSC",
    "dept_name": "Computer Science",
    "faculty": "Engineering and Technology"
  },
  "academic_records": [
    {
      "academic_session": "2026/2027",
      "semester": "First Semester",
      "courses_enrolled": [
        {
          "course_code": "CSC501",
          "course_title": "Advanced Database Systems",
          "credits": 3,
          "score": 88.5,
          "grade": "A"
        },
        {
          "course_code": "CSC503",
          "course_title": "Graph Machine Learning",
          "credits": 3,
          "score": 92.0,
          "grade": "A"
        }
      ],
      "semester_gpa": 5.00
    }
  ],
  "cumulative_cgpa": 5.00,
  "status": "Active",
  "last_updated": {
    "$date": "2026-10-13T00:00:00Z"
  }
}
