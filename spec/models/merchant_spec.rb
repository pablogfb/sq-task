require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    # Needed for uniqueness validation
    subject { Merchant.new(reference: "Corp inc",
                          email: "info@corp-inc.com",
                          live_on: Date.new(2022, 01, 01),
                          disbursement_frequency: 2,
                          minimum_monthly_fee: 29.0)
            }
    it { should validate_presence_of(:reference) }
    it { should validate_uniqueness_of(:reference) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:live_on) }
    it { should validate_presence_of(:disbursement_frequency) }
    it { should validate_presence_of(:minimum_monthly_fee) }
  end
  describe 'associations' do
    it { should respond_to(:orders) }
    it { should respond_to(:disbursements) }
  end
end
