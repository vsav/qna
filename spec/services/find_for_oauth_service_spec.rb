# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindForOauthService do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123') }
  subject { FindForOauthService.new(auth) }

  context 'user already has an oauth provider' do
    let(:auth) { create(:oauth_provider, user: user) }

    it 'returns user' do
      expect(subject.call).to eq user
      expect { subject.call }.to_not change(user.oauth_providers, :count)
    end
  end

  context 'user has no oauth provider' do
    context 'user exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123', info: { email: user.email }) }

      it 'does not create new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'creates oauth provider for user' do
        expect { subject.call }.to change(user.oauth_providers, :count).by(1)
      end

      it 'creates oauth provider with provider and uid' do
        oauth_provider = subject.call.oauth_providers.first

        expect(oauth_provider.provider).to eq auth.provider
        expect(oauth_provider.uid).to eq auth.uid
      end

      it 'returns user' do
        expect(subject.call).to eq user
      end
    end
    context 'user does not exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123', info: { email: 'new_user@test.com' }) }

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject.call).to be_a(User)
      end

      it 'fills user email' do
        user = subject.call
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates oauth provider for user' do
        expect { subject.call }.to change(OauthProvider, :count).by(1)
      end

      it 'creates oauth provider with provider and uid' do
        oauth_provider = subject.call.oauth_providers.first
        expect(oauth_provider.provider).to eq auth.provider
        expect(oauth_provider.uid).to eq auth.uid
      end
    end
  end
end
