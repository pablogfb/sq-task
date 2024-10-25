class DisbursementJob
  include Sidekiq::Job

  def perform(id)
    Merchant.find(id).disburse
  end
end
