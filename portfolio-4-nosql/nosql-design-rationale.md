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

---

### Component 2: Multi-Model Examples (`advanced-data-models.json`)
Save this file in your `portfolio-4-nosql/` folder, showcasing how different NoSQL paradigms map to various subsystems of the university portal:

```json
{
  "document_model": {
    "paradigm": "Document Store (MongoDB)",
    "portal_use_case": "Storing complete student academic transcripts and semester performance logs in a hierarchical JSON layout.",
    "sample_data": {
      "collection": "student_transcripts",
      "document_key": "STU/2024/001",
      "structure": "Nested objects for personal info and arrays for multi-semester course records."
    }
  },
  "key_value_model": {
    "paradigm": "Key-Value Store (Redis)",
    "portal_use_case": "Managing high-speed student session tokens, user authentication state, and caching real-time exam timetables.",
    "sample_data": {
      "key": "session:token:a8f9c21e",
      "value": {
        "student_id": 1,
        "matric_no": "STU/2024/001",
        "role": "Student",
        "expires_in": 3600
      }
    }
  },
  "column_family_model": {
    "paradigm": "Wide-Column Store (Apache Cassandra / HBase)",
    "portal_use_case": "Logging high-velocity portal audit trails, security access logs, and student exam clickstream data.",
    "sample_data": {
      "row_key": "STU/2024/001#2026-10-13",
      "columns": {
        "action": "PORTAL_LOGIN",
        "ip_address": "192.168.1.50",
        "status": "SUCCESS"
      }
    }
  },
  "graph_model": {
    "paradigm": "Graph Database (Neo4j)",
    "portal_use_case": "Mapping complex curriculum prerequisites, course dependency trees, and departmental faculty hierarchies.",
    "sample_data": {
      "nodes": [
        { "id": "CSC501", "label": "Course", "title": "Advanced Database Systems" },
        { "id": "CSC301", "label": "Course", "title": "Database Management I" }
      ],
      "relationships": [
        { "from": "CSC501", "to": "CSC301", "type": "REQUIRES_PREREQUISITE" }
      ]
    }
  }
}
