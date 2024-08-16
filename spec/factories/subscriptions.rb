FactoryBot.define do
  factory :subscription do
    title { Faker::Subscription.plan }
    price { rand(100..5000) }
    status { rand(1..2) }
    frequency { rand(1..4) }
  end
end
