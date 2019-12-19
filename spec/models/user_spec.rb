require 'rails_helper'

RSpec.describe User, type: :model do

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should allow_value('user@test.com').for(:email)}
  it { should_not allow_value('user@test').for(:email)}
  it { should_not allow_value('user').for(:email)}
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:oauth_providers).dependent(:destroy) }

  describe 'user is_author?' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let!(:vote1) { create(:vote, :like, user: user2, votable: question) }
    let!(:vote2) { create(:vote, :dislike, user: user3, votable: question) }

    context 'user is question author' do
      it 'should return true' do
        expect(user).to be_is_author(question)
      end
    end

    context 'user is not question author' do
      it 'should return true' do
        expect(user2).to_not be_is_author(question)
      end
    end

    context 'user is answer author' do
      it 'should return true' do
        expect(user).to be_is_author(answer)
      end
    end

    context 'user is not answer author' do
      it 'should return true' do
        expect(user2).to_not be_is_author(answer)
      end
    end

    context 'user can rate votable' do
      it 'should return true if user2 liked question' do
        expect(user2).to be_liked(question)
      end

      it 'should return true if user3 disliked question' do
        expect(user3).to be_disliked(question)
      end
    end

    context 'user voted for votable' do
      it 'should return true if user2 voted for question' do
        expect(user2).to be_voted(question)
      end
      it 'should return true if user3 voted for question' do
        expect(user3).to be_voted(question)
      end
      it 'should return true if user2 do not voted for answer' do
        expect(user2).to_not be_voted(answer)
      end
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
