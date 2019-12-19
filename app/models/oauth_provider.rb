class OauthProvider < ApplicationRecord
  belongs_to :user
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider, message: "You're  already have linked #{@provider} account" }
end
