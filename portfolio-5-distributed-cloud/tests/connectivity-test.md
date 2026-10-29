# Connectivity Test Log

## Objective
Verify that MongoDB Compass can connect to Atlas and retrieve a Luma Polytechnic student document.

## Environment
- Client: MongoDB Compass
- Database: `luma_nosql`
- Collection: `students`

## Filter
```json
{
  "matric_number": "LP/2025/001"
}
```

## Observed result
The user reported that the connection and query were successful. The query returned Ada Okafor's document (`LP/2025/001`).

## Result
PASS — based on the result reported during the practical. Attach the actual screenshot before submission.

Evidence filename: `../evidence/02-cloud-query-test.png`
