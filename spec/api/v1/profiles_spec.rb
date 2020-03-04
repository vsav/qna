# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end
  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns status 2xx' do
        expect(response).to be_successful
      end

      it_behaves_like 'Returns all public fields' do
        let(:public_fields) { %w[id email created_at updated_at] }
        let(:resource_response) { json['user'] }
        let(:resource) { me }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'Authorized' do
      let(:users) { create_list(:user, 3) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it 'returns status 2xx' do
        puts response.status
        expect(response).to be_successful
      end

      it 'returns all users without me' do
        expect(json['users'].size).to eq(users.size - 1)
        expect(json['users']).to_not include(me)
      end

      it_behaves_like 'Returns all public fields' do
        let(:public_fields) { %w[id email created_at updated_at] }
        let(:resource_response) { json['users'].last }
        let(:resource) { users.last }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['users'].last).to_not have_key(attr)
        end
      end
    end
  end
end
