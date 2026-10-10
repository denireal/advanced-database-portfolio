

## 1 First Normal Form (1NF)

A relation satisfies First Normal Form when attributes contain atomic values and repeating groups are eliminated.

For example, student information is stored as individual attributes:

```text
student_id
matric_no
first_name
last_name
email
programme_id
```

Rather than storing multiple students or multiple programmes inside a single field.

Similarly, course registrations are represented as individual rows rather than storing several registered courses in a single student record.

Therefore, the design satisfies the requirements of 1NF.

---

## 2 Second Normal Form (2NF)

Second Normal Form requires:

1. the relation to already satisfy 1NF; and
2. non-key attributes to depend on the whole primary key.

The design separates entities so that attributes depend on their appropriate keys.

For example, student attributes depend on:

```text
student_id
```

while course information depends on:

```text
course_id
```

Course registration information is separated into:

```text
course_registrations
```

rather than being duplicated within the student or course tables.

This removes partial dependency problems and supports 2NF.

---

## 3 Third Normal Form (3NF)

Third Normal Form requires that non-key attributes do not depend transitively on another non-key attribute.

For example, department information is not stored repeatedly in the student table.

Instead:

```text
students
    ↓
programmes
    ↓
departments
```

The student's programme identifies the programme, while the programme identifies the department.

Similarly, lecturer information is maintained in the `lecturers` table rather than being repeatedly stored in `course_offerings`.

Academic session information is separated from semesters, and course information is separated from course offerings.

This prevents transitive dependencies and reduces redundancy.

The resulting database therefore satisfies the design objectives of 3NF.
