FactoryBot.define do
    factory :application do
      token { ActiveSupport::Digest.hexdigest(name) }
      name { Faker::Name.name }

      trait :with_chats do
        after(:create) do |application|
          create_list(:chat, 3, application: application)
        end
      end
    end
  end