class Merchant < ApplicationRecord
  # Relationships
  has_many :disbursements, dependent: :destroy
  has_many :orders, dependent: :destroy

  # Enum for faster db queries
  enum disbursement_frequency: { daily: 1, weekly: 2 }

  # Validations
  validates :reference, :email, :live_on, :disbursement_frequency, :minimum_monthly_fee, presence: true
  validates :reference, uniqueness: true

  # Scopes
  scope :active, -> { where("live_on <= ?", Time.now) }

  # Methods
  def active?
    live_on <= Time.now
  end
  def disbursable?
    return true  if disbursements == []
    disbursements.last.disbursed_at < (weekly? ? 7.days.ago : 1.day.ago)
  end

  def disburse
    if disbursable?
      disbursement = Disbursement.new(
                                      merchant_id: self.id,
                                      orders: self.orders.where(disbursed: false)
                                    )
      disbursement.save!
    else
      false
    end
  end
end
