FactoryBot.define do
  factory :subscription do
    title { Faker::Subscription.plan }
    price { rand(100..5000) }
    status { rand(0..1) }
    frequency { rand(0..2) }
  end
end
