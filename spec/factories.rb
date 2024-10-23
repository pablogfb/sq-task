require 'faker'

FactoryBot.define do
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
