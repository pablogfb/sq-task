namespace :tasks do
  namespace :fee_adjustment do
    desc "Monthly fee adjustments"

    # Monthly fee adjustments for previous month
    task monthly_fee_adjustments: :environment do
      Merchant.active.each { |merchant| merchant.check_fee_adjustment(Time.now.beginning_of_month - 1.day) }
    end

    # Historical monthly fee adjustments
    task historic_monthly_fee_adjustments: :environment do
      Merchant.all.each do |merchant|
        puts " ====================== Start Merchant: #{merchant.reference} ======================"
        date = merchant.live_on
        last = merchant.orders.order(created_at: :desc).first.created_at
        while date <= last
          merchant.check_fee_adjustment(date)
          date += 1.month
        end
      end
    end
  end
end
