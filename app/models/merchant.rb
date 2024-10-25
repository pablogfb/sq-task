class Merchant < ApplicationRecord
  # Relationships
  has_many :disbursements, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :fee_adjustments, dependent: :destroy

  # Enum for faster db queries
  enum :disbursement_frequency, { daily: 1, weekly: 2 }

  # Validations
  validates :reference, :email, :live_on, :disbursement_frequency, :minimum_monthly_fee, presence: true
  validates :reference, uniqueness: true

  # Scopes
  scope :active, -> { where("live_on <= ?", Time.now) }

  # Methods

  # Disburses orders within a specified date range if the merchant is disbursable.
  # returns true if disbursement is successful, false otherwise
  def disburse(date = Time.now)
    if disbursable?(date)
      orders = self.orders.where(
        "disbursed = false AND
        created_at <= ? AND
        created_at >= ?",
        date,
        self.live_on
      )
      return true if orders.empty?
      orders.each(&:calc_disbursed_fee)
      disbursement = Disbursement.new(
                                      merchant_id: self.id,
                                      orders: orders,
                                      disbursed_at: date
                                    )
      disbursement.save
    else
      false
    end
  end

  # Check if the merchant could be disbursed in the specified date
  def disbursable?(date = Time.now)
    # Was active in the past?
    return false if date < live_on.beginning_of_day
    latest_disbursement = disbursements.where("disbursed_at <= ?", date).order(disbursed_at: :desc).first
    # No previous disbursments?
    return true if latest_disbursement.nil?
    # Last disbursment was older than period?
    time_ago = date.beginning_of_day - (weekly? ? 7 : 1).days
    latest_disbursement.disbursed_at.beginning_of_day <= time_ago
  end

  # Create if fee adjustment is needed on the provided date
  def check_fee_adjustment(date)
    return false if fee_adjustments.where(adjustment_date: date.all_month).any?
    monthly_disbursements = disbursements.where(disbursed_at: date.all_month).sum(:fee_amount)
    if monthly_disbursements < minimum_monthly_fee
      fee_adjustment = FeeAdjustment.new(
        merchant: self,
        adjustment_date: date.beginning_of_month,
        adjustment_amount: (minimum_monthly_fee - monthly_disbursements)
      )
      fee_adjustment.save
    end
  end
end
