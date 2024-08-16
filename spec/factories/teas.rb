FactoryBot.define do
  factory :tea do
    title { Faker::Tea.type }
    description { "This is the best tea" }
    temperature { rand(75..100) }
    brew_time { rand(1..20) }
  end
end
