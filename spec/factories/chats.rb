FactoryBot.define do
  factory :chat do
    association :application
    number { rand(1..100000) }
  end
end
