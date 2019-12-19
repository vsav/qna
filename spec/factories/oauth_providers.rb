FactoryBot.define do
  factory :oauth_provider do
    user
    provider { "Provider" }
    uid { "123" }
  end
end
