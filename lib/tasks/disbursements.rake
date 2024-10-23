namespace :tasks do
  desc "Disbursements"
  task disburse: :environment do
    # TODO: move to background job with sidekiq
    Merchant.active.each(&:disburse)
  end

  task historic_disburse: :environment do
    merchants = Merchant.all
    merchants.each do |merchant|
      puts " ====================== Start Merchant: #{merchant.reference} ======================"
      extra_days = merchant.disbursement_frequency == "weekly" ? 7.days : 1.day
      date = merchant.live_on.beginning_of_day
      last = merchant.orders.order(created_at: :desc).first.created_at.beginning_of_day + extra_days

      while date <= last
        date += extra_days
        merchant.disburse(date)
      end
    end
  end
end
