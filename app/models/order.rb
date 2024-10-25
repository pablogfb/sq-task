class Order < ApplicationRecord
  # Associations
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  # Validations
  validates :merchant_id, presence: true
  validates :disbursed, inclusion: { in: [ true, false ] }
  validates_absence_of :disbursement, on: :create

  # Methods
  def disbursable?
    !disbursed
  end

  def calc_disbursed_fee
    percentage =  case amount
                  when 0...5000 then 0.01
                  when 5000...30000 then 0.0095
                  else 0.0085
                  end # rubocop:disable Layout/EndAlignment

    # Calculate fee rounding always up
    self.disbursed_fee = (amount * percentage).ceil(0)
    self.save
  end
end
