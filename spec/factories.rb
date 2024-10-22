require 'faker'

FactoryBot.define do
  factory :merchant do
    reference { Faker::Company.name }
    email { Faker::Internet.email }
    live_on { Date.new(2022, 01, 01) }
    disbursement_frequency { 1 }
    minimum_monthly_fee { 29.0 }
  end

  factory :order do
    merchant
    amount { Faker::Number.decimal(r_digits: 2) }
    disbursed { false }
  end

  factory :disbursement do
    merchant
  end
end
