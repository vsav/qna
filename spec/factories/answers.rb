FactoryBot.define do
  factory :answer do
    question
    body { "MyAnswerText" }
    user
    trait :invalid do
      body { nil }
    end
  end
end
