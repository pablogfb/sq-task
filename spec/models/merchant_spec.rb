require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
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
