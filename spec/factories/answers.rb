FactoryBot.define do
  factory :answer do
    association :question
    association :author
    body { "MyText" }

    trait :invalid do
      body { nil }
    end
  end
end
