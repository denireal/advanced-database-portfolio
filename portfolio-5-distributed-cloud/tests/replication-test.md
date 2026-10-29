# Replica-Set Inspection Test

## Commands
Run in an authorised MongoDB shell connected to Atlas:
```javascript
db.adminCommand({ hello: 1 })
db.adminCommand({ replSetGetStatus: 1 })
```

## Observations reported
- Replica-set name: `atlas-s0oks8-shard-0`.
- `hello` reported `isWritablePrimary: true` for the connected member.
- The output advertised three host entries.
- The supplied `replSetGetStatus` excerpt showed a member with `stateStr: "PRIMARY"` and `health: 1`.
- It showed a member with `stateStr: "SECONDARY"` and `health: 1`.
- The secondary's `syncSourceHost` pointed to the primary.
- The supplied excerpt contained two member records; it does not establish the state of the third advertised host.

## Interpretation
The output confirms replica-set architecture and the roles/health reported for the two displayed members. It does not prove that failover occurred.


