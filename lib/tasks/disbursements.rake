namespace :tasks do
  desc "Disbursements"
  task disburse: :environment do
    # TODO: move to background job with sidekiq
    Merchant.active.each(&:disburse)
  end
end
