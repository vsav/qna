# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth

  def github; end

  def vkontakte; end

  private

  def oauth
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: auth.provider.capitalize)
      end
    elsif @user
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      redirect_to new_user_confirmation_path, notice: 'Please provide your email'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
