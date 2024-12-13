FactoryBot.define do
  factory :user do
    name { "User #{Faker::Number.unique.number(digits: 3)}" }
    email { Faker::Internet.unique.email }
    password { Devise.friendly_token.first(8) }
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_avatar.png'), 'image/png') }

    # Фабрика для пользователей с провайдерами OAuth
    trait :github_user do
      provider { 'github' }
      url { "https://github.com/#{Faker::Internet.username}" }
    end

    trait :yandex_user do
      provider { 'yandex' }
      url { Faker::Internet.uuid }
    end
  end
end
