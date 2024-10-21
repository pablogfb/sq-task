class Merchant < ApplicationRecord
  # Relationships
  has_many :disbursements, dependent: :destroy

  # Enum for faster db queries
  enum disbursement_frequency: { daily: 1, weekly: 2 }

  # Validations
  validates :reference, :email, :live_on, :disbursement_frequency, :minimum_monthly_fee, presence: true
  validates :reference, uniqueness: true
end
