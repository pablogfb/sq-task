require 'rails_helper'

RSpec.describe FeeAdjustment, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:merchant) }
    it { should validate_presence_of(:adjustment_date) }
    it { should validate_presence_of(:adjustment_amount) }
  end
end
