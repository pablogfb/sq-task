require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    # Test merchant association
    it { should respond_to(:merchant) }
    it { should respond_to(:disbursement) }

    it { should_not validate_presence_of(:amount) }
    it { should_not validate_presence_of(:disbursed) }
    it { should validate_absence_of(:disbursement).on(:create) }
  end

  it 'sets default disbursed to false' do
    order = Order.new
    expect(order.disbursed).to eq(false)
  end

  it 'sets default disbursement to nil' do
    order = Order.new
    expect(order.disbursement).to eq(nil)
  end

  describe 'fee calculation' do
    it 'calculates the right fee amount for less than 50 on creation' do
      order = create(:order, amount: rand(0...4999))
      order.calc_disbursed_fee
      expect(order.disbursed_fee).to eq((order.amount * 0.01).ceil(0))
    end

    it 'calculates the right fee amount 50...300 on creation' do
      order = create(:order, amount: rand(5000...30000))
      order.calc_disbursed_fee
      expect(order.disbursed_fee).to eq((order.amount * 0.0095).ceil(0))
    end

    it 'calculates the right fee amount for more than 300 on creation' do
      order = create(:order, amount: rand(30000...9999999))
      order.calc_disbursed_fee
      expect(order.disbursed_fee).to eq((order.amount * 0.0085).ceil(0))
    end
  end
end
