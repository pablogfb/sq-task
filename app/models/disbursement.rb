class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates_presence_of :merchant
  validates_absence_of :disbursed_at, on: :create
end
