require 'faker'

FactoryBot.define do
  factory :fee_adjustment do
    merchant
    adjustment_date { Faker::Date }
    adjustment_amount { Faker::Number.between(from: 0, to: 100000) }
  end

  factory :merchant do
    reference { Faker::Company.name }
    email { Faker::Internet.email }
    live_on { Date.new(2022, 01, 01) }
    disbursement_frequency { 1 }
    minimum_monthly_fee { 29 }
  end

  factory :order do
    merchant
    amount { rand(0..99999) }
    disbursed { false }
  end

  factory :disbursement do
    merchant
    disbursed_at { Time.now }
  end
end
