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
    it 'disbursable? should return true if disbursable' do
      merchant = build(:merchant)
      merchant.disbursement_frequency = :weekly
      merchant.disbursements = [ Disbursement.new(
                                                    merchant: merchant,
                                                    disbursed_at: 7.days.ago
                                                  )
                                ]
      expect(merchant.disbursable?).to eq(true)
    end

    it 'disbursable? should return false if not disbursable' do
      merchant = build(:merchant)
      merchant.disbursement_frequency = :weekly
      merchant.disbursements = [ Disbursement.new(
                                        merchant: merchant,
                                        disbursed_at: 2.days.ago
                                      )
                                ]
      expect(merchant.disbursable?).to eq(false)
    end

    it 'returns false on disbursement if not disbursable' do
      merchant = create(:merchant)
      # By default disbursed_at is set to Time.now on creation
      merchant.disbursements = [ Disbursement.new(
                                        merchant: merchant
                                      )
                                ]
      expect(merchant.disburse).to eq(false)
    end

    it 'returns a true if disbursable' do
      merchant = create(:merchant)
      disbursement = Disbursement.new(merchant: merchant)
      merchant.disbursements = [ disbursement ]
      disbursement.update(disbursed_at: 25.hours.ago)
      expect(merchant.disburse).to eq(true)
    end

    it 'should create a new disbursement if disbursable' do
      merchant = create(:merchant)
      disbursement = Disbursement.new(merchant: merchant)
      merchant.disbursements = [ disbursement ]
      disbursement.update(disbursed_at: 25.hours.ago)
      merchant.disburse
      expect(merchant.disbursements.count).to eq(2)
    end
  end
end
