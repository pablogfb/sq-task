class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates_presence_of :merchant
end
