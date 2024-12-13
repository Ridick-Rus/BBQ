# spec/factories/events.rb
FactoryBot.define do
  factory :event do
    title { "Test Event Title" }
    description { "This is a test description for the event." }
    address { "123 Test Street, Test City" }
    datetime { DateTime.now + 1.day }
    pincode { "1234" }
    association :user # Связь с моделью User

    # Дополнительно можно настроить вложенные фабрики, если потребуется
    trait :with_comments do
      after(:create) do |event|
        create_list(:comment, 3, event: event)
      end
    end

    trait :with_subscriptions do
      after(:create) do |event|
        create_list(:subscription, 2, event: event)
      end
    end

    trait :with_photos do
      after(:create) do |event|
        create_list(:photo, 5, event: event)
      end
    end
  end
end
