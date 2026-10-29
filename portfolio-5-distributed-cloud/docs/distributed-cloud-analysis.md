# Distributed and Cloud Database Analysis

## 1. Aim
This practical investigates a cloud-hosted MongoDB deployment for the Luma Polytechnic case study, focusing on connectivity, data retrieval, and replica-set status.

## 2. Cloud connectivity
MongoDB Compass connected successfully to Atlas. A query on `students` using `matric_number: "LP/2025/001"` returned Ada Okafor's document. This confirms client access to the cloud database at the time of testing.

## 3. Replica-set architecture
The `hello` command reported replica set `atlas-s0oks8-shard-0`, `isWritablePrimary: true` for the connected member, AWS as provider, and region tag `AF_SOUTH_1`. It advertised three host entries.

The supplied `replSetGetStatus` excerpt showed one member with `stateStr: "PRIMARY"` and `health: 1`, and one with `stateStr: "SECONDARY"` and `health: 1`. The secondary identified the primary as its sync source. The excerpt contained only two member records, so the state of the third advertised host cannot be concluded from that excerpt.

## 4. Distributed database concepts
A replica set maintains multiple copies of data across members. The primary accepts writes and replicates changes to secondary members. If the primary becomes unavailable, eligible members can participate in an election to select a new primary, supporting service continuity. Actual behaviour depends on configuration, member health, quorum, and client settings.

## 5. Findings and limitations
The practical verified cloud connectivity, a successful student query, replica-set identification, and the roles and reported health of the two displayed members. It did not deliberately trigger a failure, observe an election, or measure recovery time. It therefore does not claim that failover was experimentally tested. The dataset is small and this was a functional demonstration, not a performance benchmark.

## 6. Conclusion
The Luma Polytechnic MongoDB database was accessible through Atlas, and the commands provided evidence of replica-set architecture. The observed primary and secondary were reported healthy in the supplied output. The exercise illustrates how cloud hosting and replication can support data availability while distinguishing observed results from untested capabilities.
