# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  describe 'Github' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.env['omniauth.auth'] = mock_auth_hash(:github, email: 'user@test.com')
    end

    let!(:oauth_data) { mock_auth_hash(:github, email: 'user@test.com') }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user esxists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'logins user if it exists' do
        expect(subject.current_user).to eq user
      end
      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path if user does not exists' do
        expect(response).to redirect_to root_path
      end
      it 'does not login user if it not exists' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Vkontakte' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.env['omniauth.auth'] = mock_auth_hash(:vkontakte)
    end

    let!(:oauth_data) { mock_auth_hash(:vkontakte) }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context 'user esxists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it 'logins user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it 'redirects to root path if user does not exists' do
        expect(response).to redirect_to root_path
      end
      it 'does not login user if it not exists' do
        expect(subject.current_user).to_not be
      end
    end
  end
end
