FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  factory :user, aliases: [:author] do
    email
    password { '123qwe' }
    password_confirmation { '123qwe' }
  end
end
