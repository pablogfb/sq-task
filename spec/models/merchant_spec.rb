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
    it { should be_valid }
  end
  describe 'associations' do
    it { should respond_to(:orders) }
    it { should respond_to(:disbursements) }
  end

  describe 'disbursement methods' do
    before(:each) do
      @merchant = create(:merchant, disbursement_frequency: :daily)
      @disbursement = create(:disbursement, merchant: @merchant)
    end

    it 'disbursable? should return true if disbursable' do
      @disbursement.update(disbursed_at: 2.days.ago)
      expect(@merchant.disbursable?).to eq(true)
    end

    it 'disbursable? should return false if not disbursable' do
      @merchant.update(disbursement_frequency: :weekly)
      expect(@merchant.disbursable?).to eq(false)
    end

    it 'returns false on disbursement if not disbursable' do
      @merchant.update(disbursement_frequency: :weekly)
      expect(@merchant.disburse(Time.now)).to eq(false)
    end

    it 'returns a true if disbursable' do
      @disbursement.update(disbursed_at: 2.days.ago)
      expect(@merchant.disburse(Time.now)).to eq(true)
    end

    it 'should create a new disbursement if disbursable' do
      @disbursement.update(disbursed_at: 2.days.ago)
      create(:order, merchant: @merchant)
      @merchant.disburse(Time.now)
      expect(@merchant.disbursements.count).to eq(2)
    end

    it 'historicaly_disbursable? should return true if disbursable' do
      @disbursement.update(disbursed_at: 1.month.ago)
      @merchant.update(live_on: 2.months.ago)
      start_date = 1.month.ago + 1.day
      expect(@merchant.disbursable?(start_date)).to eq(true)
    end

    it 'historicaly_disbursable? should return false if not disbursable' do
      @disbursement.update(disbursed_at: 1.month.ago)
      @merchant.update(live_on: 2.months.ago, disbursement_frequency: :weekly)
      start_date = 1.month.ago + 1.day
      expect(@merchant.disbursable?(start_date)).to eq(false)
    end
  end
end
