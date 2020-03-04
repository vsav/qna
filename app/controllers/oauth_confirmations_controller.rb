# frozen_string_literal: true

class OauthConfirmationsController < Devise::ConfirmationsController
  def new; end

  def create
    @email = oauth_confirmation_params[:email]
    password = Devise.friendly_token[0, 10]
    @user = User.new(email: @email, password: password, password_confirmation: password)

    if @user.save
      @user.send_confirmation_instructions
      redirect_to root_path, notice: "Confirmation instructions has been sent to #{@email}"
    else
      render :new
    end
  end

  private

  def after_confirmation_path_for(_resource_name, user)
    session_data = { provider: session[:provider], uid: session[:uid] }
    user.oauth_providers.create!(session_data) if session_data.values.all?
    sign_in user, event: :authentication
    signed_in_root_path(@user)
  end

  def oauth_confirmation_params
    params.permit(:email)
  end
end
