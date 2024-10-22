require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:merchant).on(:create) }
  end

  describe 'associations' do
    it { should respond_to(:merchant) }
    it { should respond_to(:orders) }
  end
end
