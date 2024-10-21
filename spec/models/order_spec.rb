require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    # Test merchant association
    it { should respond_to(:merchant) }

    it { should_not validate_presence_of(:amount) }
    it { should_not validate_presence_of(:disbursed) }
    it { should validate_absence_of(:disbursed_fee).on(:create) }
  end

  it 'sets default disbursed to false' do
    order = Order.new
    expect(order.disbursed).to eq(false)
  end
end
