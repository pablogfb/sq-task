# Update crontab to run disbursements every day at 8am
every 1.days, at: "8:00 am" do
  rake "tasks:disburse:disburse_now"
end

# Update crontab to run monthly fee adjustments at 2am first day of the month
every "0 1 1 * *" do
  rake "tasks:fee_adjustment:monthly_fee_adjustments"
end
