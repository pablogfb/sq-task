class FeeAdjustment < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :merchant, :adjustment_date, :adjustment_amount
end
