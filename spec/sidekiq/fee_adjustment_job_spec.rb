require 'rails_helper'
require "sidekiq/testing"

RSpec.describe FeeAdjustmentJob, type: :job do
  describe '#perform' do
    let(:merchant) { create(:merchant) }
    let(:id) { merchant.id }

    it 'calls the FeeAdjustment method on the merchant' do
      expect(Merchant).to receive(:find).with(id).and_return(merchant)
      expect(merchant).to receive(:check_fee_adjustment)
      FeeAdjustmentJob.new.perform(id)
    end
  end

  describe '#perform_async' do
    let(:merchant) { create(:merchant) }
    let(:id) { merchant.id }

    it 'enqueues the job' do
      expect { FeeAdjustmentJob.perform_async(id) }.to change(Sidekiq::Queues['default'], :size).by(1)
    end
  end
end
