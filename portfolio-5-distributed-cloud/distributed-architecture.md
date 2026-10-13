# Distributed and Cloud Database Architecture: Southern Technical University

## 1. High Availability and Replication Strategy
To prevent single points of failure during critical academic windows (such as portal course registrations or semester examinations), the database deployment implements a **Replica Set** architecture (e.g., MongoDB Atlas / MySQL Group Replication):
* **Primary Node:** Handles all write operations (e.g., course registrations, grade uploads, fee payments) and high-priority consistency reads.
* **Secondary Nodes (Replicas):** Synchronously or semi-synchronously replicate data from the primary node. They handle read-heavy operations like student transcript searches and course catalog browsing, offloading traffic from the primary node.
* **Automatic Failover:** If the primary node experiences hardware failure or network partitioning, the replica set automatically triggers an election via the Raft consensus algorithm to promote a secondary node to primary within seconds.

---

## 2. Horizontal Scaling and Sharding Strategy
As the student population scales across multiple campuses, a single database instance will face storage and throughput bottlenecks. We implement **horizontal sharding**:
* **Sharding Key Selection:** The `matric_no` (e.g., `STU/2024/001`) or a hashed composite key (`dept_id + student_id`) is chosen as the shard key.
* **Range-Based / Hashed Distribution:** Hashing ensures even distribution of student documents across shard clusters, preventing write hotspots during concurrent departmental registrations.

---

## 3. Cloud Deployment Topologies
* **Multi-Region Cloud Hosting:** Deployed on cloud infrastructure (AWS/GCP) across redundant availability zones (AZs) in West Africa to ensure low latency and fault tolerance.
* **Load Balancing:** Nginx load balancers distribute incoming HTTPS traffic from students and lecturers across stateless application servers before reaching the database connection pool.
