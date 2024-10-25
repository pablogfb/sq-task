require "console_table"

namespace :tasks do
  namespace :summary do
    desc "Summary report"

    # Summary report
    task table: :environment do |t, args|
      # Return if no years provided as an argument
      if args.extras.empty?
        puts "You need to specify a years. [2021,2022,2023]"
        next
      end
      years = args.extras.map(&:to_i)

      # Print table
      ConsoleTable.define([ "Year",
                          "Number of Disbursements",
                          "Amount Disbursed",
                          "Order Fees",
                          "Number of Monthly Adjustments",
                          "Amount of Monthly Adjustments"
                          ]) do |table|
        years.each do |year|
          disbursements = Disbursement.where(disbursed_at: Date.new(year, 1, 1).all_year)
          adjustments = FeeAdjustment.where(adjustment_date: Date.new(year, 1, 1).all_year)
          # Fill the row for the current year
          table << [ year,
                 disbursements.count,
                 cents_to_euro(disbursements.sum(:disbursed_amount)),
                 cents_to_euro(disbursements.sum(:fee_amount)),
                 adjustments.count,
                 cents_to_euro(adjustments.sum(:adjustment_amount))
                 ]
        end
      end
    end

    def cents_to_euro(amount)
      euros = (amount.to_f / 100.0).ceil(2)
      ActionController::Base.helpers.number_to_currency(euros,
                                                        unit: "€",
                                                        delimiter: ".",
                                                        separator: ",",
                                                        format: "%n %u"
                                                        )
    end
  end
end
