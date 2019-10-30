require 'rails_helper'

RSpec.describe User, type: :model do
  # модель тестировать не обязательно, т.к. это делает devise
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :questions }
  it { should have_many :answers }

  describe 'user is_author?' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context 'user is question author' do
      it 'should return true' do
        expect(user).to eq question.user
      end
    end

    context 'user is not question author' do
      it 'should return true' do
        expect(user2).to_not eq question.user
      end
    end

    context 'user is answer author' do
      it 'should return true' do
        expect(user).to eq answer.user
      end
    end

    context 'user is not answer author' do
      it 'should return true' do
        expect(user2).to_not eq answer.user
      end
    end

  end
end
