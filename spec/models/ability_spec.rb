# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'Guest abilities' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :read, Reward }
    it { should_not be_able_to :manage, :all }
  end

  describe 'User abilities' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { build(:question, user: user) }
    let(:question2) { build(:question, user: user2) }
    let(:answer) { build(:answer, question: question, user: user) }
    let(:answer2) { build(:answer, question: question, user: user2) }
    let(:answer3) { build(:answer, question: question2, user: user) }
    let!(:vote) { create(:vote, user: user, votable: question2, rating: 1) }

    describe 'View reward' do
      it { should be_able_to :read, Reward }
    end

    describe '#create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    describe '#update' do
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, question2 }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, answer2 }
    end

    describe '#destroy' do
      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, question2 }
      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, answer2 }
      it { should be_able_to :destroy, build(:link, linkable: question) }
      it { should_not be_able_to :destroy, build(:link, linkable: question2) }
      it { should be_able_to :destroy, build(:link, linkable: answer) }
      it { should_not be_able_to :destroy, build(:link, linkable: answer2) }
      it {
        question.files.attach(create_file_blob)
        should be_able_to :destroy, question.files.first
      }
      it {
        answer.files.attach(create_file_blob)
        should be_able_to :destroy, answer.files.first
      }
      it {
        question2.files.attach(create_file_blob)
        should_not be_able_to :destroy, question2.files.first
      }
      it {
        answer2.files.attach(create_file_blob)
        should_not be_able_to :destroy, answer2.files.first
      }
    end

    describe '#vote' do
      it { should_not be_able_to :like, question2 }
      it { should_not be_able_to :like, question }
      it { should be_able_to :unvote, question2 }
      it { should be_able_to :like, answer2 }
      it { should_not be_able_to :like, answer }
      it { should be_able_to :dislike, question2 }
      it { should_not be_able_to :dislike, question }
      it { should be_able_to :dislike, answer2 }
      it { should_not be_able_to :dislike, answer }
      it { should be_able_to :dislike, answer2 }
      it { should_not be_able_to :dislike, answer }
    end

    describe '#set best' do
      it { should be_able_to :set_best, answer2 }
      it { should_not be_able_to :set_best, answer }
      it { should_not be_able_to :set_best, answer3 }
    end

    describe '/api/v1/profiles/me' do
      it { should be_able_to :me, user }
    end
  end
end
