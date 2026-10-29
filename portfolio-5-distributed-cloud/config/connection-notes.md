# Connection and Configuration Notes

- MongoDB Atlas was accessed using MongoDB Compass.
- Database: `luma_nosql`
- Collection: `students`
- Replica set observed: `atlas-s0oks8-shard-0`
- Provider/region tags observed: AWS / `AF_SOUTH_1`

## Security
Do not commit a full connection URI containing credentials, passwords, API keys, certificates, or private details. Store secrets outside the repository and exclude them with `.gitignore`.

## Limitations
These notes record the values shown in the supplied command output. They do not independently verify the current Atlas billing tier, backup policy, region topology, or failover configuration.
