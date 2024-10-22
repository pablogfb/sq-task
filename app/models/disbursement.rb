class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates_presence_of :merchant

  # Callback
  after_create :process_disbursement

  def process_disbursement
    # Calculate total orders and fees. It is redundant but we are dealing with money
    self.fee_amount = calculate_total_fees
    self.disbursed_amount = calculate_total_orders - self.fee_amount
    self.disbursed_at = Time.now

    # If can save, mark all orders as disbursed
    if self.save
      self.orders.update_all(disbursed: true)
    end
  end

  def calculate_total_orders
    self.orders.sum(:amount)
  end

  def calculate_total_fees
    self.orders.sum(:disbursed_fee)
  end
end
