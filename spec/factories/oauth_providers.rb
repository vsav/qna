# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_provider do
    user
    provider { 'Provider' }
    uid { '123' }
  end
end
