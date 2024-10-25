class FeeAdjustmentJob
  include Sidekiq::Job

  def perform(id)
    Merchant.find(id).check_fee_adjustment(Time.now.beginning_of_month - 1.day)
  end
end
