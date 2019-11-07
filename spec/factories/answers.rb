FactoryBot.define do
  factory :answer do
    question
    body { "MyAnswerText" }
    user
    best { false }
    trait :invalid do
      body { nil }
    end
  end
end
