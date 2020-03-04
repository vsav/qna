# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'MyString' }

    trait :valid_url do
      url { 'http://example.com' }
    end

    trait :invalid_url do
      url { 'http://aaa' }
    end

    trait :valid_gist do
      url { 'https://gist.github.com/vsav/d0a264036e740851c80c313292b08899' }
    end
  end
end
