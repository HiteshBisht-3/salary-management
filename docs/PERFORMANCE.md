# Performance Considerations

The application is designed around a dataset of 10,000 employees.

## Server-side Pagination

Employee endpoints return a limited page of records rather than all
employees.

## Database Filtering

Search and filters are executed by PostgreSQL rather than filtering records
inside React or Ruby.

## Database Indexes

Indexes are used for commonly queried employee fields including employee
code, email, department, and country.

Salary records are indexed by employee and effective date.

## Aggregation

Salary analytics use database aggregation functions such as COUNT, AVG,
MIN, MAX, and SUM.

This avoids loading thousands of salary records into application memory for
calculation.

## Future Improvements

At substantially larger scale, possible improvements include:

- Cursor-based pagination
- Search-specific indexes
- Cached analytics
- Read replicas
- Background analytics processing
- Application performance monitoring