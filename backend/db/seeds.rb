# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Starting database seed..."

Salary.delete_all
Employee.delete_all

departments = [
  "Engineering",
  "Product",
  "Finance",
  "Human Resources",
  "Sales",
  "Marketing",
  "Operations",
  "Customer Support"
].freeze

countries = {
  "United States" => {
    currency: "USD",
    salary_range: 60_000..180_000
  },
  "India" => {
    currency: "INR",
    salary_range: 600_000..3_000_000
  },
  "United Kingdom" => {
    currency: "GBP",
    salary_range: 45_000..130_000
  },
  "Germany" => {
    currency: "EUR",
    salary_range: 50_000..140_000
  },
  "Canada" => {
    currency: "CAD",
    salary_range: 60_000..160_000
  }
}.freeze

job_titles = {
  "Engineering" => [
    "Software Engineer",
    "Senior Software Engineer",
    "Backend Engineer",
    "Frontend Engineer",
    "Engineering Manager"
  ],
  "Product" => [
    "Product Manager",
    "Senior Product Manager",
    "Product Analyst"
  ],
  "Finance" => [
    "Financial Analyst",
    "Senior Financial Analyst",
    "Finance Manager"
  ],
  "Human Resources" => [
    "HR Specialist",
    "HR Manager",
    "Talent Acquisition Specialist"
  ],
  "Sales" => [
    "Sales Representative",
    "Account Executive",
    "Sales Manager"
  ],
  "Marketing" => [
    "Marketing Specialist",
    "Marketing Manager",
    "Content Strategist"
  ],
  "Operations" => [
    "Operations Analyst",
    "Operations Manager",
    "Business Operations Specialist"
  ],
  "Customer Support" => [
    "Support Specialist",
    "Customer Success Manager",
    "Technical Support Engineer"
  ]
}.freeze

first_names = %w[
  James Mary John Patricia Robert Jennifer Michael Linda
  William Elizabeth David Barbara Richard Susan Joseph Jessica
  Thomas Sarah Charles Karen Daniel Nancy Matthew Lisa
  Anthony Margaret Mark Sandra Steven Ashley Paul Kimberly
  Andrew Emily Joshua Donna Kenneth Michelle Kevin Carol
  Brian Amanda George Melissa Edward Deborah Ronald Stephanie
  Timothy Rebecca Jason Sharon Jeffrey Laura Ryan Cynthia
  Jacob Kathleen Gary Amy Nicholas Angela Eric Shirley
  Stephen Anna Jonathan Brenda Larry Pamela Justin Emma
  Scott Nicole Brandon Helen Benjamin Samantha Samuel Katherine
  Gregory Christine Alexander Debra Patrick Rachel Jack Carolyn
].freeze

last_names = %w[
  Smith Johnson Williams Brown Jones Garcia Miller Davis
  Rodriguez Martinez Hernandez Lopez Gonzalez Wilson Anderson
  Thomas Taylor Moore Jackson Martin Lee Perez Thompson
  White Harris Sanchez Clark Ramirez Lewis Robinson Walker
  Young Allen King Wright Scott Torres Nguyen Hill
  Flores Green Adams Nelson Baker Hall Rivera Campbell
  Mitchell Carter Roberts Gomez Phillips Evans Turner Diaz
  Parker Cruz Edwards Collins Reyes Stewart Morris Morales
  Murphy Cook Rogers Gutierrez Ortiz Morgan Cooper Peterson
  Bailey Reed Kelly Howard Ramos Kim Cox Ward
].freeze

random = Random.new(42)

employee_rows = []
salary_rows = []

now = Time.current

10_000.times do |index|
  employee_number = index + 1

  first_name = first_names[random.rand(first_names.length)]
  last_name = last_names[random.rand(last_names.length)]
  department = departments[random.rand(departments.length)]

  country = countries.keys[random.rand(countries.length)]
  country_data = countries.fetch(country)

  available_titles = job_titles.fetch(department)
  job_title = available_titles[random.rand(available_titles.length)]

  joining_date =
    Date.new(2015, 1, 1) +
    random.rand((Date.current - Date.new(2015, 1, 1)).to_i + 1)

  employee_rows << {
    employee_code: format("EMP%05d", employee_number),
    first_name: first_name,
    last_name: last_name,
    email: "employee#{employee_number}@acme.example",
    country: country,
    department: department,
    job_title: job_title,
    joining_date: joining_date,
    created_at: now,
    updated_at: now
  }
end

puts "Inserting 10,000 employees..."

Employee.insert_all!(employee_rows)

employees = Employee.order(:id).to_a

employees.each do |employee|
  country_data = countries.fetch(employee.country)

  base_salary = random.rand(country_data[:salary_range])

  bonus_percentage = random.rand(0..20)
  bonus = (base_salary * bonus_percentage / 100.0).round(2)

  salary_rows << {
    employee_id: employee.id,
    base_salary: base_salary,
    bonus: bonus,
    currency: country_data[:currency],
    effective_from: employee.joining_date,
    created_at: now,
    updated_at: now
  }
end

puts "Inserting salary records..."

Salary.insert_all!(salary_rows)

puts "Database seed completed."
puts "Employees: #{Employee.count}"
puts "Salaries: #{Salary.count}"