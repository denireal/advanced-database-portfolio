# Portfolio 5: Distributed and Cloud Database Exercise

## Case study
Luma Polytechnic

## Objective
Demonstrate cloud database connectivity, successful student-data retrieval, replica-set inspection, and an evidence-based discussion of replication and availability.

## Environment
- Cloud service: MongoDB Atlas
- Client: MongoDB Compass / MongoDB shell
- Database: `luma_nosql`
- Collection: `students`
- Replica set: `atlas-s0oks8-shard-0` (reported by `hello`)
- Provider/region tags: AWS / `AF_SOUTH_1`

## Tests performed
1. Connected to Atlas using MongoDB Compass.
2. Queried `students` for `matric_number: "LP/2025/001"`; the query returned Ada Okafor's document.
3. Ran `db.adminCommand({ hello: 1 })`. The output reported `isWritablePrimary: true` for the connected member and advertised three host entries.
4. Ran `db.adminCommand({ replSetGetStatus: 1 })`. The supplied output excerpt showed one member as `PRIMARY` with `health: 1`, and one member as `SECONDARY` with `health: 1`. The secondary's sync source was the primary.
5. The supplied status excerpt showed two member records only, so it does not establish the status of the third advertised host.

## Interpretation
The query confirms cloud connectivity and data access. The command outputs confirm replica-set architecture and show a healthy primary and secondary in the displayed excerpt. Replica sets can support availability through replicated data and election of an eligible secondary if the primary becomes unavailable.

No primary failure was deliberately triggered, and no failover or recovery-time test was performed. Failover is therefore discussed as an architectural capability, not as a test result.

## Contents
- `docs/distributed-cloud-analysis.md` — architecture discussion and limitations.
- `tests/connectivity-test.md` — repeatable query and result log.
- `tests/replication-test.md` — commands and observations.
- `config/connection-notes.md` — safe configuration notes.
- `evidence/evidence-checklist.md` — screenshot checklist.

