# NoSQL Data Model: Luma Polytechnic (MongoDB Document Model)

## 1. Selected NoSQL Database
**Database:** MongoDB (Document-oriented NoSQL).
**Collection:** `student_transcripts`

## 2. Document Structure (JSON/BSON)
In the relational model (`luma_db`), a transcript requires joining `students`, `programmes`, `registrations`, `course_offerings`, `courses`, `grades`, and `grade_scale`. 

In MongoDB, we embed this data into a single, nested document. This follows the "Data that is accessed together, should be stored together" principle.

```json
{
  "_id": ObjectId("65f8a1b2c3d4e5f6a7b8c9d0"),
  "matric_no": "LP/26/CSC/0001",
  "full_name": "Ada Okafor",
  "programme": {
    "name": "Computer Science",
    "award": "ND"
  },
  "academic_record": [
    {
      "session": "2026/2027",
      "semester": "FIRST",
      "gpa": 3.58,
      "courses": [
        {
          "course_code": "COM111",
          "title": "Introduction to Computing",
          "credit_units": 3,
          "ca_score": 27,
          "exam_score": 58,
          "total_score": 85,
          "grade": "A",
          "grade_point": 4.00
        },
        {
          "course_code": "COM112",
          "title": "Programming Fundamentals",
          "credit_units": 4,
          "ca_score": 22,
          "exam_score": 48,
          "total_score": 70,
          "grade": "AB",
          "grade_point": 3.50
        }
      ]
    }
  ],
  "cgpa": 3.58
}
