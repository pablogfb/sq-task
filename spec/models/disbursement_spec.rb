require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:merchant).on(:create) }
  end

  describe 'associations' do
    it { should respond_to(:merchant) }
    it { should respond_to(:orders) }
  end

  describe 'amounts calculation' do
    it 'stores disbursed_at on save' do
      disbursement = build(:disbursement)
      expect(disbursement.disbursed_at).to eq(nil)
      disbursement.save
      expect(disbursement.disbursed_at).not_to eq(nil)
    end
    it 'calculates disbursed amount on save' do
      order1 = create(:order)
      order2 = create(:order, merchant: order1.merchant)
      disbursement = Disbursement.new(merchant: order1.merchant)
      disbursement.orders = [ order1, order2 ]
      disbursement.save
      expect(disbursement.disbursed_amount).to eq(
                                                  (order1.amount + order2.amount) -
                                                  (order1.disbursed_fee + order2.disbursed_fee)
                                                  )
    end
  end
end
