require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:reward) { create(:reward, question: question) }
  let!(:answer1) { create(:answer, question: question, user: user) }
  let!(:best_answer) { create(:answer, question: question, user: user, best: true) }
  let!(:answer3) { create(:answer, question: question, user: user2) }

  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_presence_of :body }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id).on(:create) }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like Votable

  describe 'answer mark_best' do

    before do
      answer1.mark_best!
      answer1.reload
      best_answer.reload
    end

    it 'should mark answer2 as best' do
      expect(answer1).to be_best
    end

    it 'should change best answer' do
      expect(best_answer).to_not be_best
      expect(answer1).to be_best
    end

    it 'should grant reward to other user' do
      expect(user.rewards).to eq([reward])
      answer3.mark_best!
      user.reload
      user2.reload
      expect(user.rewards).to eq([])
      expect(user2.rewards).to eq([reward])
    end
  end

  describe 'best answer renders on top' do
    it 'best answer should be first in array' do
      expect(question.answers).to eq([best_answer, answer1, answer3])
    end
  end
end
