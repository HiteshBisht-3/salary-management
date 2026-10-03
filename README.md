# ACME Salary Management System

A full-stack salary management application for HR teams managing employee
compensation across multiple countries.

## Tech Stack

### Backend

- Ruby on Rails API
- PostgreSQL
- Minitest

### Frontend

- ReactJS
- Vite
- React Router

## Features

- Employee CRUD
- Employee search
- Department and country filters
- Server-side pagination
- Salary history
- Salary updates
- Multi-currency salary analytics
- Department compensation analytics
- Country compensation analytics
- 10,000-employee seed dataset
- Automated backend tests

## Architecture

React communicates with the Rails API using JSON REST endpoints.

Employee and Salary are separate entities so salary history can be
preserved.

See `docs/ARCHITECTURE.md` for additional details.

## Local Setup

### Requirements

- Ruby
- Rails
- PostgreSQL
- Node.js
- npm

### Backend

```bash
cd backend
bundle install
rails db:create
rails db:migrate
rails db:seed
rails server

### Demo Video
https://drive.google.com/file/d/1FF2qn3nxrT5_XP89HzOFG8uMksiu-W2A/view?usp=sharing
