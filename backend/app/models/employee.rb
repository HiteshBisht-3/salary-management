class Employee < ApplicationRecord
  has_many :salaries, dependent: :destroy

  validates :employee_code, presence: true, uniqueness: { case_sensitive: false }

  validates :first_name,
            :last_name,
            :country,
            :department,
            :job_title,
            :joining_date,
            presence: true

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "must be a valid email address"
            }

  before_validation :normalize_email
  before_validation :normalize_employee_code

  def current_salary
    salaries.recent_first.first
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def normalize_employee_code
    self.employee_code = employee_code.to_s.strip.upcase
  end
end
