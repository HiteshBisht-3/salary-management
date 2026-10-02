# Salary Management System - Requirements

## 1. Goal

Build a web-based salary management system for ACME's HR team to manage
salary information for approximately 10,000 employees across multiple
countries.

The application will replace spreadsheet-based salary management with a
centralized system that allows HR managers to efficiently maintain employee
compensation data and understand how employees are paid across the organization.

## 2. Primary User

### HR Manager

The primary user of the application is an HR Manager who needs to:

- View employee and salary information.
- Search and filter employees.
- Add and update employee information.
- Manage employee salary information.
- Review salary history.
- Understand salary distribution across departments and countries.
- View organization-level salary statistics.

## 3. Core Features

### Employee Management

HR managers can:

- View a paginated list of employees.
- Search employees by name, email, or employee code.
- Filter employees by department and country.
- View individual employee details.
- Add new employees.
- Update existing employee information.
- Delete employee records.

Employee information includes:

- Employee code
- First name
- Last name
- Email
- Country
- Department
- Job title
- Joining date

### Salary Management

HR managers can:

- View the current salary of an employee.
- Add a new salary record.
- Update an employee's compensation while preserving salary history.
- View historical salary records.

Salary information includes:

- Base salary
- Bonus
- Currency
- Effective date

### Salary Analytics

The dashboard will provide:

- Total number of employees.
- Total payroll.
- Average salary.
- Minimum and maximum salary.
- Salary statistics by department.
- Salary statistics by country.

## 4. Data Volume

The system must support at least 10,000 employees.

A database seed script will generate 10,000 realistic employee records with
salary information for development and demonstration.

## 5. Performance Requirements

To support 10,000 employees efficiently:

- Employee lists will use server-side pagination.
- Search and filtering will be performed in the database.
- Frequently queried database columns will be indexed.
- API responses will return only the data required by the UI.
- Aggregate salary calculations will be performed by the database where possible.

## 6. Technical Approach

### Backend

- Ruby on Rails in API mode
- RESTful JSON APIs
- PostgreSQL relational database

### Frontend

- ReactJS
- Vite
- Reusable UI components

The React application will communicate with the Rails backend through REST APIs.

## 7. Validation and Quality

The backend will validate required employee and salary information.

Automated tests will cover core functionality including:

- Employee validations
- Salary validations
- Employee API operations
- Salary management
- Salary analytics

Tests should be deterministic, fast, and easy to understand.

## 8. Out of Scope

The following features are intentionally excluded from the initial version:

### Authentication and Role-Based Access Control

The assessment focuses primarily on salary management functionality.
In a production HR system, authentication and authorization would be required
before exposing sensitive salary information.

### Payroll Processing

The application manages salary information but does not calculate taxes,
deductions, payslips, or execute salary payments.

### Currency Conversion

Salary values retain their original currencies. Automatic currency conversion
would require an external exchange-rate provider and decisions about historical
exchange rates.

### Employee Self-Service

The initial application is designed specifically for HR managers rather than
individual employees.

### External HR Integrations

Integrations with payroll providers, accounting systems, or HR platforms are
excluded to keep the assessment focused on the core product.

## 9. Success Criteria

The solution is successful when an HR manager can:

1. Manage employee records through the web interface.
2. Manage and review employee salary information.
3. Efficiently search and filter a dataset of 10,000 employees.
4. View useful organization-level salary analytics.
5. Use the application through a responsive React interface backed by Rails APIs.