# Update crontab to run disbursements every day at 8am
every 1.days, at: "8:00 am" do
  rake "tasks:disburse"
end
