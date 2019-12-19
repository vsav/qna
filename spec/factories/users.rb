FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  factory :user do
    sequence :email do |n|
      "user#{n}@test.com"
    end
    password { '123qwe' }
    password_confirmation { '123qwe' }
    confirmed_at { Time.zone.now }

    trait :unconfirmed_email do
      confirmed_at { nil }
    end
  end
end
