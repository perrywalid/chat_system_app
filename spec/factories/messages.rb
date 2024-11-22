FactoryBot.define do
  factory :message do
    association :chat
    number { rand(1..100000) }
    body { Faker::Lorem.sentence }
    created_at { Faker::Time.backward(days: 14, period: :evening) }
  end
end
