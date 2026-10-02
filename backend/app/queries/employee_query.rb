class EmployeeQuery
  ALLOWED_SORT_COLUMNS = %w[
    employee_code
    first_name
    last_name
    email
    country
    department
    job_title
    joining_date
    created_at
  ].freeze

  ALLOWED_DIRECTIONS = %w[asc desc].freeze

  def initialize(relation = Employee.all, params = {})
    @relation = relation
    @params = params
  end

  def call
    employees = @relation

    employees = apply_search(employees)
    employees = apply_department_filter(employees)
    employees = apply_country_filter(employees)
    employees = apply_sorting(employees)

    employees
  end

  private

  def apply_search(employees)
    search = @params[:search].to_s.strip

    return employees if search.blank?

    pattern = "%#{ActiveRecord::Base.sanitize_sql_like(search)}%"

    employees.where(
      "employee_code ILIKE :search OR
       first_name ILIKE :search OR
       last_name ILIKE :search OR
       email ILIKE :search",
      search: pattern
    )
  end

  def apply_department_filter(employees)
    department = @params[:department].to_s.strip

    return employees if department.blank?

    employees.where(department: department)
  end

  def apply_country_filter(employees)
    country = @params[:country].to_s.strip

    return employees if country.blank?

    employees.where(country: country)
  end

  def apply_sorting(employees)
    sort = @params[:sort].to_s
    direction = @params[:direction].to_s.downcase

    sort = "created_at" unless ALLOWED_SORT_COLUMNS.include?(sort)
    direction = "desc" unless ALLOWED_DIRECTIONS.include?(direction)

    employees.order(sort => direction)
  end
end