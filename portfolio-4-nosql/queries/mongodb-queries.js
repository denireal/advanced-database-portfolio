// Portfolio 4 — Luma Polytechnic MongoDB queries

// 1. Find a student by matriculation number.
db.students.find({ matric_number: "LP/2025/001" });

// 2. Find students with an A-grade registration.
db.students.find({ "registrations.letter_grade": "A" });

// 3. Find students with a total score of 80 or above.
db.students.find({ "registrations.total_score": { $gte: 80 } });

// 4. Create and verify the ascending matriculation-number index.
db.students.createIndex({ matric_number: 1 }, { name: "matric_number_1" });
db.students.getIndexes();

// 5. Aggregate statistics across embedded course results.
// $unwind excludes students whose registrations array is empty.
db.students.aggregate([
  { $unwind: "$registrations" },
  {
    $group: {
      _id: null,
      total_course_results: { $sum: 1 },
      average_total_score: { $avg: "$registrations.total_score" },
      highest_total_score: { $max: "$registrations.total_score" },
      lowest_total_score: { $min: "$registrations.total_score" }
    }
  }
]);

// 6. Explain the indexed lookup. Output varies by MongoDB version.
db.students.find({ matric_number: "LP/2025/001" }).explain("executionStats");
