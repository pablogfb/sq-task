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
    it 'calculates disbursed fee on save' do
      order = Order.new
      order.amount = 100
      order.save
      expect(order.disbursed_fee).not_to eq(0)
    end
    it 'calculates the right fee amount for less than 50 on creation' do
      order = create(:order, amount: rand(0.01...49.99))
      expect(order.disbursed_fee).to eq((order.amount * 0.01).ceil(2))
    end

    it 'calculates the right fee amount 50...300 on creation' do
      order = create(:order, amount: rand(50.00...300.00))
      expect(order.disbursed_fee).to eq((order.amount * 0.0095).ceil(2))
    end

    it 'calculates the right fee amount for more than 300 on creation' do
      order = create(:order, amount: rand(299.99...9999.99))
      expect(order.disbursed_fee).to eq((order.amount * 0.0085).ceil(2))
    end
  end
end
