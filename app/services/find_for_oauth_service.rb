class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    oauth_provider = OauthProvider.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return oauth_provider.user if oauth_provider

    email = auth.info[:email]
    user = User.find_by(email: email)
    if user
      user.oauth_providers.create!(provider: auth.provider, uid: auth.uid.to_s)
    elsif email
      password = Devise.friendly_token[0, 10]
      user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: Time.zone.now)
      user.oauth_providers.create!(provider: auth.provider, uid: auth.uid.to_s)
    else
      user = User.new
    end
    user
  end
end
