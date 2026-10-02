# Architecture

## Overview

The Salary Management System uses a client-server architecture.

ReactJS provides the user interface and communicates with a Ruby on Rails
API over HTTP using JSON. PostgreSQL stores employee and salary data.

ReactJS
    |
REST JSON API
    |
Ruby on Rails
    |
PostgreSQL

## Backend

The backend is implemented using Ruby on Rails in API mode.

Primary models:

- Employee
- Salary

An Employee has many Salary records. Salary changes create new records
rather than overwriting previous compensation, preserving salary history.

Query objects contain filtering and analytics logic to keep controllers small.

## Frontend

The frontend is implemented using ReactJS and Vite.

The application contains:

- Salary analytics dashboard
- Employee directory
- Employee search and filters
- Pagination
- Employee creation and editing
- Employee details
- Salary history
- Salary updates

## API Design

The API follows RESTful conventions.

Employee operations are exposed through `/api/v1/employees`.

Salary records are nested under employees because a salary belongs to an
employee.

Analytics endpoints provide organization-level compensation insights.

## Data Scale

The assessment requires support for 10,000 employees.

The application uses server-side filtering, sorting, and pagination rather
than loading all employee records into the browser.

## Salary History

Salary is modeled separately from Employee so compensation changes do not
destroy historical information.

The most recent effective salary is treated as the current salary.

## Multi-Currency Analytics

Salary values from different currencies are not combined into a single
organization-wide monetary total.

Analytics are grouped by currency to avoid mathematically misleading totals
without an exchange-rate normalization strategy.