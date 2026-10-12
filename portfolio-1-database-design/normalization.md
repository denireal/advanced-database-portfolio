# Database Normalisation Documentation

The Southern Technical University database design has been rigorously normalised up to **Third Normal Form (3NF)** to eliminate data redundancy, prevent insertion/update anomalies, and ensure optimal write performance.

## 1. First Normal Form (1NF)
* **Rule:** All attribute values must be atomic (indivisible), and repeating groups or arrays must be eliminated.
* **Application:** Multi-valued fields (such as listing multiple courses directly inside a student row or listing multiple students in a course row) have been removed. Instead, atomicity is enforced by isolating individual data fields and utilizing the junction table `Enrollment` to manage many-to-many relationships between students and courses.

## 2. Second Normal Form (2NF)
* **Rule:** The relation must be in 1NF, and all non-key attributes must be fully functionally dependent on the entire primary key (no partial dependencies).
* **Application:** In single-key tables like `Student` and `Course`, every non-key attribute (e.g., `course_title`, `credits`) depends entirely on the primary key (`student_id` and `course_id` respectively). In compound or mapped structures, partial dependencies are eliminated by ensuring non-key attributes like `score` and `grade` depend strictly on the complete unique combination defining the registration instance in `Enrollment`.

## 3. Third Normal Form (3NF)
* **Rule:** The relation must be in 2NF, and there must be **no transitive dependencies** (non-key attributes must not depend on other non-key attributes).
* **Application:** Departmental metadata—such as `dept_name` and `head_of_dept`—is isolated within the `Department` relation. If department information were stored directly inside the `Student` or `Course` tables, updating a head of department would require updating every student and course record linked to that department, introducing update anomalies. Isolating this data ensures dependencies flow directly through primary and foreign keys.