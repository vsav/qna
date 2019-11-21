FactoryBot.define do
  factory :link do
    name { "MyString" }

    trait :valid_url do
      url { 'http://example.com' }
    end
  end
end
