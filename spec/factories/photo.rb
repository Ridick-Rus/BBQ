FactoryBot.define do
  factory :photo do
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_image.png'), 'image/png') }
    user
    event
  end
end
