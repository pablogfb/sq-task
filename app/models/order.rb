class Order < ApplicationRecord
  # Associations
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  # Validations
  validates :merchant_id, presence: true
  validates :disbursed, inclusion: { in: [ true, false ] }
  validates_absence_of :disbursement, on: :create
  validates :amount, numericality: { decimal: true, greater_than: 0 }

  # Callbacks
  before_save :update_disbursed_fee

  # Methods
  def disbursable?
    !disbursed
  end

  def update_disbursed_fee
    percentage =  case amount
                  when 0...50 then 0.01
                  when 50...300 then 0.0095
                  else 0.0085
                  end # rubocop:disable Layout/EndAlignment

    # Calculate fee rounding always up
    self.disbursed_fee = (amount * percentage).ceil(2)
  end
end
