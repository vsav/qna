# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    association :user
    association :votable

    trait :like do
      rating { 1 }
    end

    trait :dislike do
      rating { -1 }
    end
  end
end
