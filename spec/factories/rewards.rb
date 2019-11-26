FactoryBot.define do
  factory :reward do
    sequence(:title) { |n| "Reward-#{n}" }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/jpeg') }
    association :question
  end
end
