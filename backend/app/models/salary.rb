class Salary < ApplicationRecord
  belongs_to :employee

  validates :base_salary,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :bonus,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :currency,
            presence: true,
            length: { is: 3 }

  validates :effective_from,
            presence: true

  before_validation :normalize_currency

  scope :recent_first, -> { order(effective_from: :desc, created_at: :desc) }

  private

  def normalize_currency
    self.currency = currency.to_s.strip.upcase
  end
end