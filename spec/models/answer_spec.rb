require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer1) { create(:answer, question: question, user: user) }
  let!(:best_answer) { create(:answer, question: question, user: user, best: true) }
  let!(:answer3) { create(:answer, question: question, user: user) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_presence_of :body }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id).on(:create) }

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
  end

  describe 'best answer renders on top' do
    it 'best answer should be first in array' do
      expect(question.answers).to eq([best_answer, answer1, answer3])
    end
  end
end
