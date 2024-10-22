class Order < ApplicationRecord
  # Associations
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  # Validations
  validates :merchant_id, presence: true
  validates :disbursed, inclusion: { in: [ true, false ] }
  validates_absence_of :disbursed_fee, :disbursement, on: :create
end
