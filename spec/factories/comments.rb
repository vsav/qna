FactoryBot.define do
  factory :comment do

    sequence :body do |n|
      "Comment #{n} text"
    end
  end

  trait :invalid do
    body { nil }
  end
end
